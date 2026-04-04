import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const RingoApp());
}

class RingoApp extends StatelessWidget {
  const RingoApp({super.key});

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