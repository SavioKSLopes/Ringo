import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/services/anime_service.dart';
import '../../../anime/data/models/anime_model.dart';
import '../../../anime/data/models/genre_model.dart';
import '../../../favorites/controller/favorites_controller.dart';
import '../../../../app/widgets/app_drawer.dart';

enum SearchType { anime, manga }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<AnimeModel>>? futureItems;
  Future<List<GenreModel>>? futureGenres;
  final AnimeService animeService = AnimeService();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  SearchType selectedType = SearchType.anime;
  Set<int> selectedGenreIds = {};

  @override
  void initState() {
    super.initState();
    _loadDefault(SearchType.anime);
    _loadGenres(SearchType.anime);
  }

  void _loadGenres(SearchType type) {
    setState(() {
      selectedGenreIds = {};
      futureGenres = type == SearchType.anime
          ? animeService.fetchAnimeGenres()
          : animeService.fetchMangaGenres();
    });
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
      selectedGenreIds = {};
    });

    searchController.clear();
    _loadGenres(type);
    _loadDefault(type);
  }

  void _onGenreSelected(int genreId) {
    setState(() {
      if (selectedGenreIds.contains(genreId)) {
        selectedGenreIds.remove(genreId);
      } else {
        selectedGenreIds.add(genreId);
      }

      if (selectedGenreIds.isEmpty) {
        _loadDefault(selectedType);
      } else {
        final genreParam = selectedGenreIds.join(',');
        final category = selectedType == SearchType.anime ? 'anime' : 'manga';
        final url = Uri.parse(
            'https://api.jikan.moe/v4/$category?genres=$genreParam');
        futureItems = animeService.searchRaw(url);
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        final text = query.trim();
        final category = selectedType == SearchType.anime ? 'anime' : 'manga';
        final genreParam = selectedGenreIds.isNotEmpty
            ? '&genres=${selectedGenreIds.join(',')}'
            : '';

        if (text.isEmpty && selectedGenreIds.isEmpty) {
          _loadDefault(selectedType);
        } else {
          final url = Uri.parse(
              'https://api.jikan.moe/v4/$category?q=$text$genreParam');
          futureItems = animeService.searchRaw(url);
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
      drawer: const AppDrawer(),
      appBar: AppBar(
      title: const Text('Buscar'),
)     ,
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
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
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
          FutureBuilder<List<GenreModel>>(
            future: futureGenres,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox(height: 8);

              final genres = snapshot.data!;

              return SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: genres.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    final isSelected = selectedGenreIds.contains(genre.malId);

                    return FilterChip(
                      label: Text(genre.name),
                      selected: isSelected,
                      onSelected: (_) => _onGenreSelected(genre.malId),
                      selectedColor: Colors.red,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
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