import 'package:demo3/views/activity-form/widgets/activity_form.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class ActivityFormView extends StatelessWidget {
  static const routeName = '/activity-form';
  const ActivityFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final String cityName = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une activité"),
      ),
      drawer: DymaDrawer(),
      body: ActivityForm(cityName: cityName),
    );
  }
}
