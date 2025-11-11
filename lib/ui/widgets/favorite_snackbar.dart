import 'package:flutter/material.dart';
import '../../data/providers/favorites_provider.dart';
import '../screens/favorites_screen.dart';

class FavoriteSnackBar {
  static SnackBar added(
    String launchId,
    FavoritesProvider favoritesProvider,
    BuildContext? context,
  ) {
    return SnackBar(
      content: Row(
        spacing: 12,
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 20,
          ),
          const Expanded(
            child: Text('Ajouté aux favoris'),
          ),
        ],
      ),
      backgroundColor: Colors.pink.shade600,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Voir',
        textColor: Colors.white,
        onPressed: () {
          if (context != null && context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  static SnackBar removed(String launchId, FavoritesProvider favoritesProvider) {
    return SnackBar(
      content: Row(
        spacing: 12,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 20,
          ),
          const Expanded(
            child: Text('Retiré des favoris'),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade700,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Annuler',
        textColor: Colors.white,
        onPressed: () async {
          await favoritesProvider.addFavorite(launchId);
        },
      ),
    );
  }
}

