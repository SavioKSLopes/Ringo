import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../../../../app/widgets/app_drawer.dart';
import '../../controller/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FavoritesController>();
    final favorites = controller.favorites;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Nenhum favorito adicionado ainda.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final anime = favorites[index];

                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        anime.imageUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 50,
                          height: 70,
                          color: Colors.grey[900],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    title: Text(
                      anime.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Nota: ${anime.score}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.toggleFavorite(anime),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.details,
                        arguments: anime,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}