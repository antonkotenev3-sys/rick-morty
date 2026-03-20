import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../logic/cubit/character_cubit.dart';
import '../../data/models/character_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CharacterCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      // ValueListenableBuilder следит за всеми изменениями в коробке favorites
      body: ValueListenableBuilder<Box<CharacterModel>>(
        valueListenable: Hive.box<CharacterModel>('favorites').listenable(),
        builder: (context, box, _) {
          final favorites = box.values.toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('Список избранного пуст'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final char = favorites[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(char.image),
                ),
                title: Text(char.name),
                subtitle: Text('${char.status} - ${char.species}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Удаляем и обновляем состояние через Cubit
                    cubit.toggleFavorite(char);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
