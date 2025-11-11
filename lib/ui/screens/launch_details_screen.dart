import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/launch.dart';
import '../../data/providers/favorites_provider.dart';
import '../widgets/details_bottom_sheet.dart';
import '../widgets/expandable_details_text.dart';
import '../widgets/patch_image.dart';

final intl.DateFormat _dateFormatTime = intl.DateFormat.Hm('fr_FR');
final intl.DateFormat _dateFormatFull = intl.DateFormat.yMMMMd('fr_FR');

class LaunchDetailsScreen extends StatelessWidget {
  final Launch launch;

  const LaunchDetailsScreen({super.key, required this.launch});

  Future<void> _launchUrl(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL non disponible')));
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir l\'URL')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? patchImageUrl =
        launch.links.patch.large ?? launch.links.patch.small;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final isFavorite = favoritesProvider.isFavorite(launch.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : Colors.white,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(launch.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Retiré des favoris'
                                : 'Ajouté aux favoris',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              centerTitle: true,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCollapsed = constraints.maxHeight < 150;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [
                      if (isCollapsed)
                        // Version collapsed: texte tronqué sur une ligne
                        Text(
                          launch.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: theme.textTheme.titleMedium?.fontSize,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        // Version expanded: texte complet
                        Text(
                          launch.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: theme.textTheme.titleLarge?.fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (!isCollapsed) ...[
                        Text(
                          '${_dateFormatFull.format(launch.dateUtc.toLocal())} • ${_dateFormatTime.format(launch.dateUtc.toLocal())}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: theme.textTheme.labelSmall?.fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (launch.details != null &&
                            launch.details!.isNotEmpty)
                          ExpandableDetailsText(
                            text: launch.details!,
                            textStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: theme.textTheme.bodySmall?.fontSize,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            onShowMore: () => DetailsBottomSheet.show(
                              context,
                              launch.details!,
                            ),
                          ),
                      ],
                    ],
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (patchImageUrl != null)
                    PatchImage(url: patchImageUrl, aspectRatio: 16 / 9)
                  else
                    Container(color: theme.colorScheme.primaryContainer),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  // Statut du lancement
                  _buildStatusCard(context),

                  // Cores (boosters)
                  if (launch.cores.isNotEmpty) ...[
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Boosters'),
                        ...launch.cores.asMap().entries.map(
                          (entry) => _buildCoreCard(
                            context,
                            entry.value,
                            entry.key + 1,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Équipage
                  if (launch.crew.isNotEmpty) ...[
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Équipage'),
                        _buildInfoCard(
                          context,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: launch.crew
                                  .map((member) => Chip(label: Text(member)))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],

                  // Liens et médias
                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'Liens et médias'),
                      _buildLinksSection(context),
                    ],
                  ),

                  // Photos Flickr
                  if (launch.links.flickr != null &&
                      launch.links.flickr!.original.isNotEmpty) ...[
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Photos'),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: launch.links.flickr!.original.length,
                            itemBuilder: (context, index) {
                              final imageUrl =
                                  launch.links.flickr!.original[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index <
                                          launch.links.flickr!.original.length -
                                              1
                                      ? 12
                                      : 0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 300,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: theme
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              child: const Center(
                                                child: Icon(Icons.broken_image),
                                              ),
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              color: theme
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (launch.upcoming == true) {
      statusColor = theme.colorScheme.primary;
      statusIcon = Icons.schedule;
      statusText = 'À venir';
    } else if (launch.success == true) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Réussi';
    } else if (launch.success == false) {
      statusColor = theme.colorScheme.error;
      statusIcon = Icons.cancel;
      statusText = 'Échec';
    } else {
      statusColor = theme.colorScheme.surfaceContainerHighest;
      statusIcon = Icons.help_outline;
      statusText = 'Statut inconnu';
    }

    final bool hasFailures = launch.failures.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          // En-tête avec statut
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasFailures && launch.failures.length > 1)
                      Text(
                        '${launch.failures.length} échec${launch.failures.length > 1 ? 's' : ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Détails des échecs
          if (hasFailures)
            Column(
              spacing: 12,
              children: launch.failures.map((failure) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      // Raison de l'échec
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: statusColor,
                            size: 20,
                          ),
                          Expanded(
                            child: Text(
                              failure.reason.isEmpty
                                  ? 'Raison inconnue'
                                  : '${failure.reason[0].toUpperCase()}${failure.reason.substring(1)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (failure.time > 0 || failure.altitude != null)
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            if (failure.time > 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: statusColor.withValues(alpha: 0.7),
                                  ),
                                  Text(
                                    '${failure.time}s',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: statusColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            if (failure.altitude != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                children: [
                                  Icon(
                                    Icons.height,
                                    size: 16,
                                    color: statusColor.withValues(alpha: 0.7),
                                  ),
                                  Text(
                                    '${failure.altitude} km',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: statusColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
    Color? color,
    double? spacing,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing ?? 12,
        children: children,
      ),
    );
  }

  Widget _buildCoreCard(BuildContext context, dynamic core, int index) {
    final theme = Theme.of(context);
    return _buildInfoCard(
      context,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.rocket_launch, color: theme.colorScheme.primary),
            Text(
              'Booster $index',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (core.flight != null)
              Chip(
                label: Text('Vol n°${core.flight}'),
                avatar: const Icon(Icons.flight_takeoff, size: 18),
              ),
            if (core.reused == true)
              const Chip(
                label: Text('Réutilisé'),
                avatar: Icon(Icons.repeat, size: 18),
              ),
            if (core.gridfins == true)
              const Chip(
                label: Text('Gridfins'),
                avatar: Icon(Icons.grid_3x3, size: 18),
              ),
            if (core.legs == true)
              const Chip(
                label: Text('Legs'),
                avatar: Icon(Icons.straighten, size: 18),
              ),
          ],
        ),
        if (core.landingAttempt == true) ...[
          const Divider(),
          Row(
            spacing: 8,
            children: [
              Icon(
                core.landingSuccess == true ? Icons.check_circle : Icons.cancel,
                color: core.landingSuccess == true
                    ? Colors.green
                    : theme.colorScheme.error,
                size: 20,
              ),
              Expanded(
                child: Text(
                  'Atterrissage: ${core.landingSuccess == true ? "Réussi" : "Échoué"}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (core.landingType != null)
            Text(
              'Type: ${core.landingType}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    final links = launch.links;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (links.article != null)
          ActionChip(
            avatar: const Icon(Icons.article, size: 18),
            label: const Text('Article'),
            onPressed: () => _launchUrl(context, links.article),
          ),
        if (links.webcast != null || links.youtubeId != null)
          ActionChip(
            avatar: const Icon(Icons.video_library, size: 18),
            label: const Text('Vidéo'),
            onPressed: () => _launchUrl(
              context,
              links.webcast ?? 'https://youtube.com/watch?v=${links.youtubeId}',
            ),
          ),
        if (links.wikipedia != null)
          ActionChip(
            avatar: const Icon(Icons.language, size: 18),
            label: const Text('Wikipedia'),
            onPressed: () => _launchUrl(context, links.wikipedia),
          ),
        if (links.presskit != null)
          ActionChip(
            avatar: const Icon(Icons.description, size: 18),
            label: const Text('Press Kit'),
            onPressed: () => _launchUrl(context, links.presskit),
          ),
        if (links.reddit != null) ...[
          if (links.reddit!.campaign != null)
            ActionChip(
              avatar: const Icon(Icons.forum, size: 18),
              label: const Text('Reddit Campaign'),
              onPressed: () => _launchUrl(context, links.reddit!.campaign),
            ),
          if (links.reddit!.launch != null)
            ActionChip(
              avatar: const Icon(Icons.forum, size: 18),
              label: const Text('Reddit Launch'),
              onPressed: () => _launchUrl(context, links.reddit!.launch),
            ),
          if (links.reddit!.media != null)
            ActionChip(
              avatar: const Icon(Icons.image, size: 18),
              label: const Text('Reddit Media'),
              onPressed: () => _launchUrl(context, links.reddit!.media),
            ),
        ],
      ],
    );
  }
}

