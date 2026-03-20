import 'package:dio/dio.dart';
import 'package:hive_ce/hive_ce.dart';
import '../models/character_model.dart';

class CharacterRepository {
  // Используем прямой экземпляр Dio
  final Dio _dio = Dio();

  // Получаем коробки (они уже должны быть открыты в main)
  Box<CharacterModel> get _cacheBox =>
      Hive.box<CharacterModel>('characters_cache');
  Box<CharacterModel> get _favBox => Hive.box<CharacterModel>('favorites');

  Future<List<CharacterModel>> fetchCharacters(int page) async {
    try {
      final String url = 'https://rickandmortyapi.com/api/character';

      final response = await _dio.get(url);

      // Извлекаем список из results
      final List results = response.data['results'];

      final chars = results.map((json) {
        final char = CharacterModel.fromJson(json);
        // Проверяем, есть ли он в избранном
        char.isFavorite = _favBox.containsKey(char.id);
        return char;
      }).toList();

      // Сохраняем в кэш для офлайна
      for (var c in chars) {
        await _cacheBox.put(c.id, c);
      }

      return chars;
    } catch (e) {
      // Если интернет упал, берем из кэша
      return _cacheBox.values.toList();
    }
  }

  // Метод для избранного
  Future<void> toggleFavorite(CharacterModel char) async {
    final favoritesBox = Hive.box<CharacterModel>('favorites');
    final cacheBox = Hive.box<CharacterModel>('characters_cache');

    if (favoritesBox.containsKey(char.id)) {
      await favoritesBox.delete(char.id);
      char.isFavorite = false;
    } else {
      char.isFavorite = true;

      // СОЗДАЕМ КОПИЮ, чтобы не было ошибки "Same instance"
      final favChar = CharacterModel(
        id: char.id,
        name: char.name,
        status: char.status,
        species: char.species,
        image: char.image,
        isFavorite: true,
      );

      await favoritesBox.put(char.id, favChar);
    }

    // Обновляем статус в кэше (там объект уже "свой", ошибки не будет)
    await cacheBox.put(char.id, char);
  }

  // Геттер для экрана избранного
  //Box<CharacterModel> get favoritesBox => _favBox;
  Box<CharacterModel> get favoritesBox => Hive.box<CharacterModel>('favorites');
}
