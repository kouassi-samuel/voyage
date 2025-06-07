import 'package:flutter/material.dart';
import '../../../models/city_model.dart';

class CityCard extends StatelessWidget {
  final City city;

  const CityCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final image = city.image ?? 'assets/images/default_city.jpg';
    final name = city.name ?? 'Ville inconnue';

    return Card(
      elevation: 12,
      child: SizedBox(
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              child: Hero(
                tag: city.name!,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/city', arguments: city.name);
              },
            ),

            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black54,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
