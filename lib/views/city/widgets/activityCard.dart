import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isSelected;
  final VoidCallback toggleActivity;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.isSelected,
    required this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand, //remplir toute l'image
        children: [
          Ink.image(
            image: AssetImage(activity.image!),
            fit: BoxFit.cover, //remplir toute l'image
            child: InkWell(onTap: toggleActivity),
          ),

          Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSelected)
                      Icon(Icons.check, size: 20, color: Colors.white),
                  ],
                ),
              ),

              Row(
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        activity.name!,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
