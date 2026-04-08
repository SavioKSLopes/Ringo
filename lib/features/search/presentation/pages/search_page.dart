import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/services/anime_service.dart';
import '../../../anime/data/models/anime_model.dart';
import '../../../favorites/controller/favorites_controller.dart';

enum SearchType { anime, manga }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<AnimeModel>>? futureItems;
  final AnimeService animeService = AnimeService();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  SearchType selectedType = SearchType.anime;

  @override
  void initState() {
    super.initState();
    _loadDefault(SearchType.anime);
  }

  void _loadDefault(SearchType type) {
    setState(() {
      futureItems = type == SearchType.anime
          ? animeService.fetchTopAnime()
          : animeService.fetchTopManga();
    });
  }

  void _onTypeChanged(SearchType type) {
    setState(() {
      selectedType = type;
    });

    final text = searchController.text.trim();

    if (text.isEmpty) {
      _loadDefault(type);
    } else {
      _search(text, type);
    }
  }

  void _search(String query, SearchType type) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        futureItems = type == SearchType.anime
            ? animeService.searchAnime(query)
            : animeService.searchManga(query);
      });
    });
  }

  void _onSearchChanged(String query) {
    _search(query.trim(), selectedType);
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
        title: const Text('Buscar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: SegmentedButton<SearchType>(
              segments: const [
                ButtonSegment<SearchType>(
                  value: SearchType.anime,
                  label: Text('Anime'),
                  icon: Icon(Icons.movie),
                ),
                ButtonSegment<SearchType>(
                  value: SearchType.manga,
                  label: Text('Mangá'),
                  icon: Icon(Icons.menu_book),
                ),
              ],
              selected: {selectedType},
              onSelectionChanged: (selection) {
                _onTypeChanged(selection.first);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: selectedType == SearchType.anime
                    ? 'Pesquisar anime...'
                    : 'Pesquisar mangá...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AnimeModel>>(
              future: futureItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return const Center(
                    child: Text('Nenhum resultado encontrado'),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Consumer<FavoritesController>(
                      builder: (context, favoritesController, child) {
                        final isFavorite =
                            favoritesController.isFavorite(item);

                        return ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.title),
                          subtitle: Text('Nota: ${item.score}'),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              favoritesController.toggleFavorite(item);
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.details,
                              arguments: item,
                            );
                          },
                        );
                      },
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