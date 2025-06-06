import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripWeather extends StatelessWidget {
  final String cityName;
  final String hostBase = "https://api.openweathermap.org/data/2.5/weather?q=";
  final String apiKey = "&appid=4f18d1d90921b6af1b1b17cb7eee8472";

  const TripWeather({super.key, required this.cityName});

  String get query => "$hostBase$cityName$apiKey";

  Future<String> get getWeather async {
    try {
      final response = await http.get(Uri.parse(query));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return body['weather'][0]['icon'].toString();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      return 'error';
    }
  }

  String getIconUrl(String iconCode) {
    return "https://openweathermap.org/img/wn/$iconCode@2x.png";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getWeather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Erreur');
        } else if (snapshot.hasData && snapshot.data != 'error') {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Météo", style: TextStyle(fontSize: 20.0)),
                Image.network(
                  getIconUrl(snapshot.data!),
                  width: 50.0,
                  height: 50.0,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50.0);
                  },
                ),
              ],
            ),
          );
        } else {
          return const Text('Failed to load weather data');
        }
      },
    );
  }
}
