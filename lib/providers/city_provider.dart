import 'dart:collection';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';
import '../models/city_model.dart';

class CityProvider with ChangeNotifier {
  List<City> _cities = [];
  final String host = 'http://192.168.1.6';
  bool isLoading = false;

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) {
    try {
      return _cities.firstWhere(
        (city) => city.name?.toLowerCase() == cityName.toLowerCase(),
        orElse: () => throw Exception('Ville non trouvée'),
      );
    } catch (e) {
      throw Exception('Impossible de trouver la ville: $cityName');
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http
          .get(
            Uri.parse('$host/api/cities'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _cities = data.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erreur de récupération des villes: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      isLoading = true;
      notifyListeners();

      final city = getCityByName(newActivity.city!);
      final response = await http.post(
        Uri.parse('$host/api/cities/${city.id}/activities'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newActivity.toJson()),
      ).timeout(const Duration(seconds: 10));

      debugPrint('Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) {
        final updatedCity = City.fromJson(jsonDecode(response.body));
        final index = _cities.indexWhere((c) => c.id == city.id);
        if (index != -1) {
          _cities[index] = updatedCity;
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erreur addActivityToCity: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  UnmodifiableListView<City> getFilteredCities(String filter) {
    if (filter.isEmpty) return UnmodifiableListView(_cities);

    final searchTerm = filter.toLowerCase();
    return UnmodifiableListView(
      _cities
          .where(
            (city) => city.name?.toLowerCase().contains(searchTerm) ?? false,
          )
          .toList(),
    );
  }
}
