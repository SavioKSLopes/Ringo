import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../anime/data/models/anime_model.dart';
import '../../controller/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Consumer<FavoritesController>(
        builder: (context, favoritesController, child) {
          final List<AnimeModel> favorites = favoritesController.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Text('Nenhum favorito adicionado ainda.'),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              final isFavorite = favoritesController.isFavorite(item);

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
                    isFavorite ? Icons.favorite : Icons.favorite_border,
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
      ),
    );
  }
}