
import '../language/language.dart';

class VisitDetailsModel {
  late int id;
  late LanguageModel title;
  late LanguageModel description;
  late String video;
  late List<VisitImageModel> images;

  VisitDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.video,
    required this.images,
  });

  VisitDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = LanguageModel.fromJSON(json['title']);
    description = LanguageModel.fromJSON(json['description']);
    video = json['video_link'];
    if (json['images'] != null) {
      images = <VisitImageModel>[];
      json['images'].forEach((v) {
        images.add(VisitImageModel.fromJSON(v));
      });
    }
  }
}

class VisitImageModel {
  late int id;
  late String image;

  VisitImageModel({
    required this.id,
    required this.image,
  });

  factory VisitImageModel.fromJSON(Map<String, dynamic> json) {
    return VisitImageModel(
      id: json['id'],
      image: json['image'],
    );
  }
}
