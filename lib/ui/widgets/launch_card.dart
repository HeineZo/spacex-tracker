import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../data/models/launch.dart';
import '../utils/date_formatters.dart';
import '../utils/navigation_utils.dart';
import 'favorite_button.dart';
import 'patch_image.dart';

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
        onTap: onTap ?? () => navigateToLaunchDetails(context, launch),
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
                child: FavoriteButton.compact(launchId: launch.id),
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
                      DateFormatters.formatDateTime(launch.dateUtc),
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


