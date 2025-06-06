import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/trip_weather.dart';
import '../../providers/city_provider.dart';
import 'widgets/trip_activities.dart';
import 'widgets/trip_city_bar.dart';
import '../../models/city_model.dart';

class TripView extends StatelessWidget {
  static const String routeName = '/trip';

  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Récupération sécurisée des arguments
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments == null || arguments is! Map<String, dynamic>) {
      return _buildErrorScreen('Arguments invalides');
    }

    // 2. Extraction sécurisée des valeurs
    final cityName = arguments['cityName']?.toString();
    final tripId = arguments['tripId']?.toString();

    if (cityName == null || tripId == null) {
      return _buildErrorScreen('Données manquantes');
    }

    // 3. Récupération de la ville avec gestion d'erreur
    final City? city;
    try {
      city = Provider.of<CityProvider>(
        context,
        listen: false,
      ).getCityByName(cityName);
    } catch (e) {
      return _buildErrorScreen('Ville non trouvée');
    }

    // 4. Construction de l'interface
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TripCityBar(city: city),
            TripWeather(cityName: cityName),
            TripActivities(tripId: tripId),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
