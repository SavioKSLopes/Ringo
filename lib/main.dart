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
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.redAccent,
          surface: Color(0xFF1A1A1A),
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.red,
        ),
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