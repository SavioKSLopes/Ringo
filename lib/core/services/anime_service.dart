import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/anime/data/models/anime_model.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/anime/data/models/genre_model.dart';

class AnimeService {
  Future<List<AnimeModel>> fetchTopAnime() async {
    final url = Uri.parse('https://api.jikan.moe/v4/top/anime');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => AnimeModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar top animes');
    }
  }

  Future<List<AnimeModel>> searchAnime(String query) async {
    final url = Uri.parse('https://api.jikan.moe/v4/anime?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => AnimeModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar anime');
    }
  }

  Future<List<AnimeModel>> searchManga(String query) async {
    final url = Uri.parse('https://api.jikan.moe/v4/manga?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => AnimeModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar mangá');
    }
  }
  
  Future<List<AnimeModel>> fetchTopManga() async {
  final url = Uri.parse('https://api.jikan.moe/v4/top/manga');
  final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['data'];
      return list.map((item) => AnimeModel.fromJson(item)).toList();
      } else {
      throw Exception('Erro ao buscar top mangás');
    }
  }
  Future<List<GenreModel>> fetchAnimeGenres() async {
  final url = Uri.parse('https://api.jikan.moe/v4/genres/anime');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List list = data['data'];
    return list.map((item) => GenreModel.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao buscar gêneros de anime');
  }
}

Future<List<GenreModel>> fetchMangaGenres() async {
  final url = Uri.parse('https://api.jikan.moe/v4/genres/manga');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List list = data['data'];
    return list.map((item) => GenreModel.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao buscar gêneros de mangá');
  }
}

Future<List<AnimeModel>> searchByGenre(int genreId, SearchType type) async {
  final category = type == SearchType.anime ? 'anime' : 'manga';
  final url = Uri.parse('https://api.jikan.moe/v4/$category?genres=$genreId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List list = data['data'];
    return list.map((item) => AnimeModel.fromJson(item)).toList();
  } else {
    throw Exception('Erro ao buscar por gênero');
  }
  }
Future<List<AnimeModel>> searchRaw(Uri url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List list = data['data'];
    return list.map((item) => AnimeModel.fromJson(item)).toList();
  } else {
    throw Exception('Erro na busca');
  }
}
}

