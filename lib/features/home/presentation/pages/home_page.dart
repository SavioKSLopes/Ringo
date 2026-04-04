import 'package:flutter/material.dart';
import '../../../../core/services/anime_service.dart';
import '../../../anime/data/models/anime_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<AnimeModel>> futureAnime;
  final AnimeService animeService = AnimeService();

  @override
  void initState() {
    super.initState();
    futureAnime = animeService.fetchTopAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Animes'),
      ),
      body: FutureBuilder<List<AnimeModel>>(
        future: futureAnime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          final animes = snapshot.data ?? [];

          return ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, index) {
              final anime = animes[index];

              return ListTile(
                leading: Image.network(
                  anime.imageUrl,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(anime.title),
                subtitle: Text('Nota: ${anime.score}'),
              );
            },
          );
        },
      ),
    );
  }
}