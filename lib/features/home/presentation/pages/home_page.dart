import 'package:flutter/material.dart';
import '../../../../app/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RINGO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.movie_filter, size: 90),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao catálogo de animes e mangás',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.search);
              },
              icon: const Icon(Icons.search),
              label: const Text('Ir para busca'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.favorites);
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Ver favoritos'),
            ),
          ],
        ),
      ),
    );
  }
}