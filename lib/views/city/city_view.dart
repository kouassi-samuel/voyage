import 'package:demo3/models/trip_model.dart';
import 'package:demo3/views/city/widgets/activity_list.dart';
import 'package:demo3/views/city/widgets/trip_activity_list.dart';
import 'package:demo3/views/city/widgets/trip_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../models/city_model.dart';
import '../../providers/city_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/drawer.dart';

import '../activity-form/activity_form_view.dart';

import '../home/home_view.dart';

class CityView extends StatefulWidget {
  static const routeName = '/city';

  const CityView({super.key});
  Widget showContent({
    required BuildContext context,
    required List<Widget> children,
  }) {
    var orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        )
        : Column(children: children);
  }

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> with WidgetsBindingObserver {
  late Trip myTrip;
  late int index;

  @override
  void initState() {
    super.initState();
    myTrip = Trip(city: null, activities: [], date: DateTime.now());
    index = 0;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setDate() {
    //Selection Date card
    final initialDate = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(initialDate.year),
      lastDate: initialDate.add(const Duration(days: 365)),
    ).then((value) {
      if (value != null) {
        setState(() => myTrip.date = value);
      }
    });
  }

  void switchIndex(int newIndex) => setState(() => index = newIndex);

  void toggleActivity(Activity activity) {
    setState(() {
      myTrip.activities!.contains(activity)
          ? myTrip.activities!.remove(activity)
          : myTrip.activities!.add(activity);
    });
  }

  void deleteTripActivity(Activity activity) =>
      setState(() => myTrip.activities!.remove(activity));

  double get amount {
    return myTrip.activities!.fold(0.0, (sum, element) {
      return sum + (element.price ?? 0);
    });
  }

  Future<void> saveTrip(cityName) async {
    //function to save a trip
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text("Voulez-vous sauvegarder ?"),
            contentPadding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Annuler"),
                    onPressed: () => Navigator.pop(context, "cancel"),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context, "save"),
                    child: const Text(
                      "Sauvegarder",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );

    if (myTrip.date == null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Attention !"),
              content: const Text("Vous n'avez pas entré de date"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return; // Sortir de la fonction si pas de date
    }

    if (result == "save") {
      myTrip.city = cityName;
      Provider.of<TripProvider>(context, listen: false).addTrip(myTrip);
      Navigator.pushNamed(context, HomeView.routeName);
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)?.settings.arguments as String;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);

    return Scaffold(
      drawer: const DymaDrawer(),
      appBar: AppBar(
        title: const Text("Organisation voyage"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed:
                () => Navigator.pushNamed(context, ActivityFormView.routeName,arguments: cityName),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: widget.showContent(
          context: context,
          children: [
            TripOverview(
              trip: myTrip,
              setDate: setDate,
              cityName: city.name,
              amount: amount,
            ),
            Expanded(
              child:
                  index == 0
                      ? ActivityList(
                        activities: city.activities,
                        selectedActivities: myTrip.activities,
                        toggleActivity: toggleActivity,
                      )
                      : TripActivityList(
                        activities: myTrip.activities,
                        deleteTripActivity: deleteTripActivity,
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: () => saveTrip(city.name),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Découverte"),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: "Mes activités",
          ),
        ],
        onTap: switchIndex,
      ),
    );
  }
}
