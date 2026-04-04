import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const AnimeCatalogApp());
}

class AnimeCatalogApp extends StatelessWidget {
  const AnimeCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ringo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}