import 'package:flutter/material.dart';

class TripOverviewCity extends StatelessWidget {
  final String? cityName;
  final String? cityImage;
  const TripOverviewCity({super.key, this.cityName, this.cityImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Hero(
            tag: cityName!,
            child: Image.asset(cityImage!, fit: BoxFit.cover),
          ),
          Container(color: Colors.black45),
          Center(
            child: Text(
              cityName!,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
