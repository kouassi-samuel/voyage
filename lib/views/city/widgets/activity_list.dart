import 'package:demo3/models/activity_model.dart';
import 'package:flutter/material.dart';


import 'activityCard.dart';

class ActivityList extends StatelessWidget {
  final dynamic activities;

  final List<Activity>? selectedActivities;
  final Function? toggleActivity;

  const ActivityList({
    super.key,
    this.activities,
    this.selectedActivities,
    this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ActivityCard(
          activity: activities[index],
          isSelected: selectedActivities!.contains(activities[index]),
          toggleActivity: () {
            toggleActivity!(
              activities[index],
            ); // Appel de la fonction toggleActivity avec l'ID de l'activité
          },
        );
      },
      itemCount: activities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}
