import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/launch.dart';
import '../../data/providers/favorites_provider.dart';
import '../screens/launch_details_screen.dart';
import 'patch_image.dart';

final DateFormat _dateFormatDate = DateFormat.yMMMMd('fr_FR');
final DateFormat _dateFormatTime = DateFormat.Hm('fr_FR');

class LaunchCard extends StatelessWidget {
  final Launch launch;
  final String? headerLabel;
  final VoidCallback? onTap;

  const LaunchCard({super.key, required this.launch, this.headerLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? imageUrl = launch.links.patch.large ?? launch.links.patch.small;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LaunchDetailsScreen(launch: launch),
                ),
              );
            },
        child: SizedBox(
          height: 220,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(child: PatchImage(url: imageUrl, aspectRatio: 16 / 9)),
              // Blur overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black.withValues(alpha: 0.08)),
                ),
              ),
              // Bottom gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.70),
                        Colors.black.withValues(alpha: 0.30),
                        Colors.black.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Top-right favorite
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    final isFavorite = favoritesProvider.isFavorite(launch.id);
                    return Material(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          favoritesProvider.toggleFavorite(launch.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.pink : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom content (header, title, description, date/time)
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    if (headerLabel != null)
                      Text(
                        headerLabel!,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    Text(
                      launch.name,
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((launch.details?.trim().isNotEmpty ?? false))
                      Text(
                        launch.details!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      '${_dateFormatDate.format(launch.dateUtc.toLocal())} • ${_dateFormatTime.format(launch.dateUtc.toLocal())}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


