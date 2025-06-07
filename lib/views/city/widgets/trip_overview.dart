import 'package:demo3/views/city/widgets/trip_overview_city.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip_model.dart';

class TripOverview extends StatelessWidget {
  final VoidCallback? setDate;
  final Trip? trip;
  final String? cityName;
  final String? cityImage;
  final double? amount;

  const TripOverview({
    super.key,
    this.setDate,
    this.trip,
    this.cityName,
    this.amount,
    this.cityImage,
  });

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    return Container(
      width: orientation == Orientation.landscape ? size.width / 2 : size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripOverviewCity(cityName: cityName, cityImage: cityImage),

          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat("d/M/y").format(trip!.date!),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: setDate,
                  child: Text("Sélectionner une date"),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Montant/personne :",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Text(
                  "$amount \$ ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
