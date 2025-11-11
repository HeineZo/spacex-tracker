import 'package:flutter/foundation.dart';
import '../services/favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _service = FavoritesService.instance;
  Set<String> _favoriteIds = <String>{};
  bool _isLoading = true;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favoriteIds = await _service.getFavoriteIds();
    } catch (e) {
      _favoriteIds = <String>{};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String launchId) => _favoriteIds.contains(launchId);

  Future<void> _updateFavorite(String launchId, bool add) async {
    try {
      if (add) {
        await _service.addFavorite(launchId);
        _favoriteIds.add(launchId);
      } else {
        await _service.removeFavorite(launchId);
        _favoriteIds.remove(launchId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating favorite: $e');
    }
  }

  Future<void> toggleFavorite(String launchId) async {
    await _updateFavorite(launchId, !isFavorite(launchId));
  }

  Future<void> addFavorite(String launchId) async {
    if (!isFavorite(launchId)) {
      await _updateFavorite(launchId, true);
    }
  }

  Future<void> removeFavorite(String launchId) async {
    if (isFavorite(launchId)) {
      await _updateFavorite(launchId, false);
    }
  }

  Future<void> clearFavorites() async {
    try {
      await _service.clearFavorites();
      _favoriteIds.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }
}

