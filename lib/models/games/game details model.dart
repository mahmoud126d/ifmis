
import '../language/language.dart';

class GameDetailsModel {
  late int id;
  late LanguageModel name;
  late LanguageModel description;
  late String video;
  late String google;
  late String apple;
  late List<GameImageModel> images;

  GameDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.video,
    required this.google,
    required this.apple,
    required this.images,
  });

  GameDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['name']);
    description = json['description'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['description']);
    video = json['video_link'];
    google = json['link_of_google_play'] ?? '';
    apple = json['link_of_app_store'] ?? '';
    if (json['images'] != null) {
      images = <GameImageModel>[];
      json['images'].forEach((v) {
        images.add(GameImageModel.fromJSON(v));
      });
    }
  }
}

class GameImageModel {
  late int id;
  late String image;

  GameImageModel({
    required this.id,
    required this.image,
  });

  factory GameImageModel.fromJSON(Map<String, dynamic> json) {
    return GameImageModel(
      id: json['id'],
      image: json['image'],
    );
  }
}
