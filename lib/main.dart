import 'package:demo3/providers/city_provider.dart';
import 'package:demo3/providers/trip_provider.dart';
import 'package:demo3/views/activity-form/activity_form_view.dart';
import 'package:demo3/views/city/city_view.dart';
import 'package:demo3/views/not-found/not_found.dart';
import 'package:demo3/views/trip/trip_view.dart';
import 'package:demo3/views/trips/trips_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/city_model.dart';
import 'views/home/home_view.dart';

void main() {
  runApp(DymaTrip());
}

class DymaTrip extends StatefulWidget {
  final List<City> cities = [];
  DymaTrip({super.key});

  @override
  State<DymaTrip> createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  // use data with provider
  final CityProvider cityProvider = CityProvider();
  final TripProvider tripProvider = TripProvider();

  @override
  void initState() {
    // fetch data from server
    cityProvider.fetchData();
    tripProvider.fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // use data with provider
        ChangeNotifierProvider.value(value: cityProvider),
        ChangeNotifierProvider.value(value: tripProvider),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: HomeView(),
        routes: {
          CityView.routeName: (context) => CityView(),
          TripsView.routeName: (context) => TripsView(),
          TripView.routeName: (context) => TripView(),
          ActivityFormView.routeName: (context) => ActivityFormView(),
        },
        onUnknownRoute:
            (context) => MaterialPageRoute(builder: (context) => NotFound()),
      ),
    );
  }
}
