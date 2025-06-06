import 'dart:math';

import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';

class TripActivityCard extends StatefulWidget {
  final Activity activity;
  final Function deleteTripActivity;

  Color getColor(){
    const colors=[Colors.red,Colors.blue];
    return colors[Random().nextInt(colors.length)];
}
  const TripActivityCard({super.key, required this.activity, required this.deleteTripActivity});

  @override
  State<TripActivityCard> createState() => _TripActivityCardState();
}

class _TripActivityCardState extends State<TripActivityCard> {

  late Color color;

  @override
  initState(){
    super.initState();
    color = widget.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(widget.activity.image!),
            ),
            title: Text(widget.activity.name!, style: TextStyle(color: color),),
            subtitle: Text(widget.activity.city!),
            trailing:
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red,),
              onPressed: () {
                widget.deleteTripActivity(widget.activity.id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Activité supprimée"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "Annuler",
                      onPressed: () {
                        print("Annuler");
                      },
                    ),
                ));
              },
            )
        )
    );
  }
}
