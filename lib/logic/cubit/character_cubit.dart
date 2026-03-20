import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character_model.dart';
import '../../data/repository/character_repository.dart';

class CharacterCubit extends Cubit<List<CharacterModel>> {
  final CharacterRepository repo;
  int _currentPage = 1;
  bool _isFetching = false;

  CharacterCubit(this.repo) : super([]);

  Future<void> loadCharacters() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final newChars = await repo.fetchCharacters(_currentPage);
      // Добавляем новые данные к текущему списку
      if (newChars.isNotEmpty) {
        emit([...state, ...newChars]);
        _currentPage++;
      }
    } catch (e) {
    } finally {
      _isFetching = false;
    }
  }

  void toggleFavorite(CharacterModel char) async {
    await repo.toggleFavorite(char);

    // Создаем новый список для уведомления BlocBuilder
    final newState = state.map((c) {
      if (c.id == char.id) {
        return char; // char уже имеет обновленный isFavorite внутри репозитория
      }
      return c;
    }).toList();

    emit(newState);
  }
}
