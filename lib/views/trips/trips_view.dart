import 'package:demo3/models/trip_model.dart';
import 'package:demo3/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/trip_provider.dart';
import '../../widgets/dyma_loader.dart';
import 'widgets/trip_list.dart';

class TripsView extends StatelessWidget {
  static const routeName = '/trips';

  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    // use data with provider
    TripProvider tripProvider = Provider.of<TripProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes voyages"),
          bottom: const TabBar(
            tabs: [Tab(text: "A Venir"), Tab(text: "Passés")],
          ),
        ),
        drawer: const DymaDrawer(),
        body:
            tripProvider.isLoading != true
                ? tripProvider.trips.isNotEmpty
                    ? TabBarView(
                      children: [
                        TripList(
                          trips:
                              tripProvider.trips
                                  .where(
                                    (trip) =>
                                        trip.date != null &&
                                        DateTime.now().isBefore(trip.date!),
                                  )
                                  .toList(),
                        ),
                        TripList(
                          trips:
                              tripProvider.trips
                                  .where(
                                    (trip) =>
                                        trip.date != null &&
                                        DateTime.now().isAfter(trip.date!),
                                  )
                                  .toList(),
                        ),
                      ],
                    )
                    : Center(child: Text("Aucun voyage trouvé"))
                : DymaLoader(),
      ),
    );
  }
}
