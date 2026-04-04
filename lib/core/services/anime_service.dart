import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/anime/data/models/anime_model.dart';

class AnimeService {
  Future<List<AnimeModel>> fetchTopAnime() async {
    final url = Uri.parse('https://api.jikan.moe/v4/top/anime');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List list = data['data'];

      return list.map((item) => AnimeModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar animes');
    }
  }
}