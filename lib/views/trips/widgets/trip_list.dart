import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip_model.dart';
import '../../trip/trip_view.dart';

class TripList extends StatelessWidget {
  final List<Trip> trips;
  const TripList({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(trips[index].city!),
          subtitle:
              trips[index].date != null
                  ? Text(DateFormat("d/M/y").format(trips[index].date!))
                  : null,
          trailing: Icon(Icons.info),
          onTap:
              () => Navigator.pushNamed(
                context,
                TripView.routeName,
                arguments: {
                  "tripId": trips[index].id,
                  "cityName": trips[index].city,
                },
              ),
        );
      },
    );
  }
}
