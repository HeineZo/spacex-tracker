import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/favorites_provider.dart';
import 'favorite_snackbar.dart';

class FavoriteButton extends StatelessWidget {
  final String launchId;
  final double? size;
  final Color? favoriteColor;
  final Color? unfavoriteColor;
  final EdgeInsets? padding;
  final bool showAsIconButton;

  const FavoriteButton({
    super.key,
    required this.launchId,
    this.size,
    this.favoriteColor,
    this.unfavoriteColor,
    this.padding,
    this.showAsIconButton = false,
  });

  const FavoriteButton.compact({
    super.key,
    required this.launchId,
    this.size = 18,
    this.favoriteColor = Colors.pink,
    this.unfavoriteColor = Colors.white,
    this.padding = const EdgeInsets.all(8.0),
    this.showAsIconButton = false,
  });

  const FavoriteButton.icon({
    super.key,
    required this.launchId,
    this.size,
    this.favoriteColor = Colors.pink,
    this.unfavoriteColor = Colors.white,
    this.padding,
    this.showAsIconButton = true,
  });

  Future<void> _handleToggle(BuildContext context, FavoritesProvider favoritesProvider) async {
    final isFavorite = favoritesProvider.isFavorite(launchId);
    
    if (isFavorite) {
      await favoritesProvider.removeFavorite(launchId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          FavoriteSnackBar.removed(launchId, favoritesProvider),
        );
      }
    } else {
      await favoritesProvider.addFavorite(launchId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          FavoriteSnackBar.added(launchId, favoritesProvider, context),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(launchId);
        final icon = Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite 
              ? (favoriteColor ?? Colors.pink) 
              : (unfavoriteColor ?? Colors.white),
          size: size,
        );

        if (showAsIconButton) {
          return IconButton(
            icon: icon,
            onPressed: () => _handleToggle(context, favoritesProvider),
          );
        }

        return Material(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleToggle(context, favoritesProvider),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8.0),
              child: icon,
            ),
          ),
        );
      },
    );
  }
}

