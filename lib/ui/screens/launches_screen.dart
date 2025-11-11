import 'package:flutter/material.dart';

import '../../data/models/launch.dart';
import '../../data/services/spacex_api_service.dart';
import '../widgets/error_box.dart';
import '../widgets/launch_card.dart';
import '../widgets/launch_list_item.dart';
import '../widgets/view_mode_toggle.dart';
import 'favorites_screen.dart';

enum LaunchesViewMode { list, grid }

class LaunchesScreen extends StatefulWidget {
  const LaunchesScreen({super.key});

  @override
  State<LaunchesScreen> createState() => _LaunchesScreenState();
}

class _LaunchesScreenState extends State<LaunchesScreen> {
  final SpaceXApiService _api = SpaceXApiService();
  late Future<Launch> _nextFuture;
  late Future<List<Launch>> _latestFuture;
  LaunchesViewMode _mode = LaunchesViewMode.grid;

  @override
  void initState() {
    super.initState();
    _nextFuture = _api.fetchNextLaunch();
    _latestFuture = _api.fetchLatestLaunches(limit: 24);
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 16),
        centerTitle: false,
        title: const Text('SpaceX Tracker'),
        actions: [
          IconButton(
            tooltip: 'Favoris',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _nextFuture = _api.fetchNextLaunch();
            _latestFuture = _api.fetchLatestLaunches(limit: 24);
          });
          await Future.wait([_nextFuture, _latestFuture]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FutureBuilder<Launch>(
              future: _nextFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorBox(
                    message: 'Erreur lors du chargement du prochain lancement',
                  );
                }
                final launch = snapshot.data!;
                return LaunchCard(
                  launch: launch,
                  headerLabel: 'Prochain lancement',
                );
              },
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Derniers lancements',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ViewModeToggle<LaunchesViewMode>(
                      selectedMode: _mode,
                      gridMode: LaunchesViewMode.grid,
                      listMode: LaunchesViewMode.list,
                      onModeChanged: (mode) => setState(() => _mode = mode),
                    ),
                  ],
                ),
                FutureBuilder<List<Launch>>(
              future: _latestFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorBox(
                    message: 'Erreur lors du chargement des lancements',
                  );
                }
                final launches = snapshot.data!;
                if (launches.isEmpty) {
                  return const _EmptyBox(message: 'Aucun lancement disponible');
                }

                if (_mode == LaunchesViewMode.list) {
                  return Column(
                    children: launches
                        .map((l) => LaunchListItem(launch: l))
                        .toList(growable: false),
                  );
                } else {
                  return GridView.builder(
                    itemCount: launches.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                    itemBuilder: (context, index) =>
                        LaunchCard(launch: launches[index]),
                  );
                }
              },
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String message;
  const _EmptyBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
