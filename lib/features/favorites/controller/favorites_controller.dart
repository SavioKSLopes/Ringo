import 'package:flutter/foundation.dart';
import '../../anime/data/models/anime_model.dart';

class FavoritesController extends ChangeNotifier {
  final List<AnimeModel> _favorites = [];

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
  }
}