import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rick_morty_test_ex/data/models/character_model.dart';
import '../../logic/cubit/character_cubit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rick & Morty')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
            context.read<CharacterCubit>().loadCharacters();
          }
          return false;
        },
        child: BlocBuilder<CharacterCubit, List<CharacterModel>>(
          builder: (context, characters) {
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final char = characters[index];
                return Card(
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: char.image /*?? ''*/,
                      placeholder: (c, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(char.name /*?? ''*/),
                    subtitle: Text('${char.status} - ${char.species}'),
                    trailing: IconButton(
                      // Убираем сложный ключ, оставляем простую логику
                      icon: Icon(
                        char.isFavorite ? Icons.star : Icons.star_border,
                        color: char.isFavorite ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        context.read<CharacterCubit>().toggleFavorite(char);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
