import 'dart:async';
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
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    futureAnime = animeService.fetchTopAnime();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.trim().isEmpty) {
          futureAnime = animeService.fetchTopAnime();
        } else {
          futureAnime = animeService.searchAnime(query.trim());
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Animes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar anime...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AnimeModel>>(
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

                if (animes.isEmpty) {
                  return const Center(
                    child: Text('Nenhum anime encontrado'),
                  );
                }

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
          ),
        ],
      ),
    );
  }
}