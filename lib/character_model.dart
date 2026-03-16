class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final OriginModel originModel;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.originModel,
  });
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'],
      image: json['image'],
      originModel: OriginModel.fromJson(json['origin']),
    );
  }
}

class OriginModel {
  final String name;
  final String url;

  OriginModel({required this.name, required this.url});
  factory OriginModel.fromJson(Map<String, dynamic> json) {
    return OriginModel(name: json['name'], url: json['url']);
  }
}
