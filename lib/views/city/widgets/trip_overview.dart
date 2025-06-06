import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/trip_model.dart';

class TripOverview extends StatelessWidget {

  final VoidCallback ?setDate;
  final Trip ? trip;
  final String ? cityName;
  final double ? amount;

  const TripOverview({super.key, this.setDate, this.trip, this.cityName, this.amount});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    return Container(
      width: orientation==Orientation.landscape ? size.width/2 : size.width,
      height: 200,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           cityName!,
            style: TextStyle(fontSize: 30,decoration: TextDecoration.underline),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(

                child: Text(DateFormat("d/M/y").format(trip!.date!), style: TextStyle(fontSize: 20),),

              ),
              ElevatedButton(
                  onPressed: setDate,
                  child: Text("Sélectionner une date")),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("Montant/personne :",style: TextStyle(fontSize: 20)) ,),
              Text("$amount \$ ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
