import '../language/language.dart';

class CompetitorModel {
  late int id;
  late LanguageModel name;
  late String image;
  late String countryImage;
  late String videoLink;
  late String video;
  late String score;
  late LanguageModel center;
  late String numberComments;
  late String userID;

  CompetitorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.countryImage,
    required this.videoLink,
    required this.video,
    required this.score,
    required this.center,
    required this.numberComments,
    required this.userID,
  });

  factory CompetitorModel.fromJSON(Map<String, dynamic> json) {
    return CompetitorModel(
      id: json['id'],
      name: json['name'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['name']),
      image: json['image'],
      countryImage: json['country_image'],
      videoLink: json['video_link'] ?? '',
      video: json['video'] ?? '',
      score: json['total_votes'],
      center: json['center'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['center']),
      numberComments: json['number_of_comments'],
      userID: json['user_id'] ?? "",
    );
  }
}
