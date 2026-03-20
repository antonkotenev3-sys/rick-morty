import 'package:hive_ce/hive_ce.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String image;

  @HiveField(5)
  bool isFavorite;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.isFavorite = false,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      species: json['species']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
