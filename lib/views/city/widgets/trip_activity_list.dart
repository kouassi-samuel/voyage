import 'package:demo3/models/activity_model.dart';
import 'package:demo3/views/city/widgets/trip_activity_card.dart';
import 'package:flutter/material.dart';



class TripActivityList extends StatelessWidget {
  final List<Activity>? activities;
  final Function? deleteTripActivity;

  const TripActivityList({super.key, this.activities, this.deleteTripActivity});

  @override
  Widget build(BuildContext context) {
    if (activities == null || activities!.isEmpty) {
      return const Center(
        child: Text("No activities found."),
      );
    }

    return ListView(
      children: activities!.map((activity) => TripActivityCard(
        key: ValueKey(activity.id),
        activity: activity,
        deleteTripActivity: deleteTripActivity ?? (Activity activityToDelete) {
        },
      )).toList(),
    );
  }
}