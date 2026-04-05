import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../anime/data/models/anime_model.dart';
import '../../../favorites/controller/favorites_controller.dart';

class DetailsPage extends StatelessWidget {
  final dynamic anime;

  const DetailsPage({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    final item = anime as AnimeModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          Consumer<FavoritesController>(
            builder: (context, favoritesController, child) {
              final isFavorite = favoritesController.isFavorite(item);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  favoritesController.toggleFavorite(item);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              item.imageUrl,
              height: 250,
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nota: ${item.score}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              item.synopsis,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}