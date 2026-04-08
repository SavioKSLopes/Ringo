import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../anime/data/models/anime_model.dart';

class FavoritesController extends ChangeNotifier {
  final List<AnimeModel> _favorites = [];
  static const _key = 'favorites';

  FavoritesController() {
    _loadFavorites();
  }

  List<AnimeModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(AnimeModel anime) {
    return _favorites.any((item) => item.malId == anime.malId);
  }

  void toggleFavorite(AnimeModel anime) {
    final exists = _favorites.any((item) => item.malId == anime.malId);

    if (exists) {
      _favorites.removeWhere((item) => item.malId == anime.malId);
    } else {
      _favorites.add(anime);
    }

    notifyListeners();
    _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _favorites.map((item) => jsonEncode({
      'mal_id': item.malId,
      'title': item.title,
      'image_url': item.imageUrl,
      'score': item.score,
      'synopsis': item.synopsis,
    })).toList();
    await prefs.setStringList(_key, list);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    _favorites.clear();
    for (final item in list) {
      final map = jsonDecode(item);
      _favorites.add(AnimeModel(
        malId: map['mal_id'],
        title: map['title'],
        imageUrl: map['image_url'],
        score: (map['score'] as num).toDouble(),
        synopsis: map['synopsis'],
      ));
    }

    notifyListeners();
  }
}