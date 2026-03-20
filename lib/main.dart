import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rick_morty_test_ex/data/models/character_model.dart';
import 'package:rick_morty_test_ex/data/repository/character_repository.dart';
import 'package:rick_morty_test_ex/logic/cubit/character_cubit.dart';
import 'package:rick_morty_test_ex/presentation/screens/main_tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Регистрация адаптера
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CharacterModelAdapter());
  }

  // Открытие коробок
  await Hive.openBox<CharacterModel>('characters_cache');
  await Hive.openBox<CharacterModel>('favorites');

  final repo = CharacterRepository();
  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final CharacterRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Создаем Cubit один раз на весь проект
      create: (context) => CharacterCubit(repository)..loadCharacters(),
      child: MaterialApp(
        title: 'Rick and Morty App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const MainTabsScreen(),
      ),
    );
  }
}
