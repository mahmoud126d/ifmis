import '../language/language.dart';

class ChampionshipStatsModel{
  late int id;
  late LanguageModel title;
  late String image;
  late String link;

  ChampionshipStatsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
  });

  factory ChampionshipStatsModel.fromJSON(Map<String, dynamic> json) {
    return ChampionshipStatsModel(
      id: json['id'],
      title: json['title'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['title']),
      image: json['image'],
      link: json['link'],
    );
  }
}