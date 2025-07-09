import '../language/language.dart';

class GameModel {
  late int id;
  late LanguageModel name;
  late String image;

  GameModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory GameModel.fromJSON(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['name']),
      image: json['image'],
    );
  }
}
