import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';
import 'features/details/presentation/pages/details_page.dart';
import 'features/favorites/controller/favorites_controller.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/search/presentation/pages/search_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesController(),
      child: const RingoApp(),
    ),
  );
}

class RingoApp extends StatelessWidget {
  const RingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RINGO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.search: (context) => const SearchPage(),
        AppRoutes.favorites: (context) => const FavoritesPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.details) {
          final anime = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => DetailsPage(anime: anime),
          );
        }
        return null;
      },
    );
  }
}