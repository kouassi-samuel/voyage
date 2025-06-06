import 'package:demo3/views/home/widgets/cityCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/city_provider.dart';
import '../../widgets/drawer.dart';
import '../../widgets/dyma_loader.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context); //use City data
    final filteredCities = cityProvider.getFilteredCities(_currentFilter);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Villes"),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      drawer: const DymaDrawer(),
      body: RefreshIndicator(
        onRefresh: cityProvider.fetchData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged:
                            (value) => setState(() => _currentFilter = value),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Rechercher une ville",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _currentFilter = "";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20),
              sliver:
                  cityProvider.isLoading
                      ? const SliverToBoxAdapter(
                        child: Center(child: DymaLoader()),
                      )
                      : filteredCities.isEmpty
                      ? const SliverToBoxAdapter(
                        child: Center(child: Text("Aucune ville trouvée")),
                      )
                      : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              CityCard(city: filteredCities[index]),
                          childCount: filteredCities.length,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
