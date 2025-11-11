import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_launches';
  static FavoritesService? _instance;
  SharedPreferences? _prefs;

  FavoritesService._();

  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }

  Future<SharedPreferences> get _prefsInstance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Set<String>> getFavoriteIds() async {
    final prefs = await _prefsInstance;
    final jsonString = prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) {
      return <String>{};
    }
    try {
      final list = json.decode(jsonString) as List<dynamic>;
      return list.map((e) => e.toString()).toSet();
    } catch (e) {
      return <String>{};
    }
  }

  Future<void> addFavorite(String launchId) async {
    final favorites = await getFavoriteIds();
    favorites.add(launchId);
    await _saveFavorites(favorites);
  }

  Future<void> removeFavorite(String launchId) async {
    final favorites = await getFavoriteIds();
    favorites.remove(launchId);
    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(Set<String> favorites) async {
    final prefs = await _prefsInstance;
    await prefs.setString(_key, json.encode(favorites.toList()));
  }

  Future<void> clearFavorites() async {
    final prefs = await _prefsInstance;
    await prefs.remove(_key);
  }
}

