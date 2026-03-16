import 'package:flutter/material.dart';
import 'package:rick_morty_test_ex/rick_and_morty_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: RickAndMorty()));
  }
}
