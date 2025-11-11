import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/launch.dart';
import '../../data/providers/favorites_provider.dart';
import '../utils/date_formatters.dart';
import '../utils/navigation_utils.dart';
import 'favorite_snackbar.dart';
import 'patch_image.dart';

class LaunchListItem extends StatelessWidget {
  final Launch launch;
  final VoidCallback? onTap;

  const LaunchListItem({super.key, required this.launch, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key('launch-${launch.id}'),
      direction: DismissDirection.endToStart,
      background: const SizedBox.shrink(),
      secondaryBackground: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFavorite = favoritesProvider.isFavorite(launch.id);
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isFavorite
                  ? Colors.grey.withValues(alpha: 0.12)
                  : Colors.pink.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 12,
              children: [
                Text(
                  isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isFavorite ? Colors.grey.shade700 : Colors.pink,
                        fontWeight: FontWeight.w700,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.grey.shade700 : Colors.pink,
                ),
              ],
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
          final isFavorite = favoritesProvider.isFavorite(launch.id);
          
          if (isFavorite) {
            await favoritesProvider.removeFavorite(launch.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                FavoriteSnackBar.removed(launch.id, favoritesProvider),
              );
            }
          } else {
            await favoritesProvider.addFavorite(launch.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                FavoriteSnackBar.added(launch.id, favoritesProvider, context),
              );
            }
          }
        }
        return false; 
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap ?? () => navigateToLaunchDetails(context, launch),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              spacing: 8,
              children: [
                _PatchThumb(
                  url: launch.links.patch.small ?? launch.links.patch.large,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        launch.name,
                                        style: theme.textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                    Consumer<FavoritesProvider>(
                                      builder: (context, favoritesProvider, child) {
                                        if (favoritesProvider.isFavorite(launch.id)) {
                                          return const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                              size: 16,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                                if ((launch.details?.trim().isNotEmpty ?? false))
                                  Text(
                                    launch.details!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateFormatters.formatDateTime(launch.dateUtc),
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatchThumb extends StatelessWidget {
  final String? url;
  const _PatchThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 56,
        height: 56,
        child: PatchImage(url: url, aspectRatio: 1),
      ),
    );
  }
}
