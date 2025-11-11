import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/launch.dart';
import '../../data/providers/favorites_provider.dart';
import '../../data/services/spacex_api_service.dart';
import '../widgets/launch_card.dart';
import '../widgets/launch_list_item.dart';

enum FavoritesViewMode { list, grid }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final SpaceXApiService _api = SpaceXApiService();
  Future<List<Launch>>? _favoritesFuture;
  FavoritesViewMode _mode = FavoritesViewMode.grid;
  Set<String> _lastFavoriteIds = <String>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites(Set<String> favoriteIds) async {
    if (favoriteIds.isEmpty) {
      setState(() {
        _favoritesFuture = Future.value(<Launch>[]);
        _lastFavoriteIds = favoriteIds;
      });
      return;
    }

    setState(() {
      _favoritesFuture = _api.fetchLaunchesByIds(favoriteIds.toList());
      _lastFavoriteIds = favoriteIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Favoris'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SegmentedButton<FavoritesViewMode>(
              segments: const [
                ButtonSegment(
                  value: FavoritesViewMode.grid,
                  icon: Icon(Icons.grid_view),
                ),
                ButtonSegment(
                  value: FavoritesViewMode.list,
                  icon: Icon(Icons.list),
                ),
              ],
              selected: {_mode},
              showSelectedIcon: false,
              onSelectionChanged: (set) =>
                  setState(() => _mode = set.first),
            ),
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          // Reload favorites if the list has changed
          final currentIds = favoritesProvider.favoriteIds;
          if (currentIds.length != _lastFavoriteIds.length ||
              !currentIds.containsAll(_lastFavoriteIds) ||
              _favoritesFuture == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _loadFavorites(currentIds);
              }
            });
          }

          if (favoritesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (currentIds.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await _loadFavorites(currentIds);
            },
            child: FutureBuilder<List<Launch>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _ErrorBox(
                    message: 'Erreur lors du chargement des favoris',
                  );
                }
                final launches = snapshot.data ?? [];
                
                // Filter out launches that are no longer in favorites
                final favoriteIds = favoritesProvider.favoriteIds;
                final filteredLaunches = launches.where((launch) => favoriteIds.contains(launch.id)).toList();

                if (filteredLaunches.isEmpty) {
                  return _buildEmptyState();
                }

                if (_mode == FavoritesViewMode.list) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredLaunches.length,
                    itemBuilder: (context, index) {
                      final launch = filteredLaunches[index];
                      return LaunchListItem(launch: launch);
                    },
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredLaunches.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final launch = filteredLaunches[index];
                      return LaunchCard(launch: launch);
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(
            Icons.heart_broken_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          Column(
            spacing: 4,
            children: [
              Text(
                'Aucun favori',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Ajoutez des lancements aux favoris pour les retrouver ici',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

