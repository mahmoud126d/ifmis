
import '../language/language.dart';

class MatchSummary {
  final int id;
  final LanguageModel title;
  final String url;
  final String image;

  MatchSummary({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  factory MatchSummary.fromJSON(Map<String, dynamic> json, bool existURL) {
    return MatchSummary(
      id: json['id'],
      title: json['title'] == null ? LanguageModel(en: '', ar: '') : LanguageModel.fromJSON(json['title']),
      url: (existURL) ? json['video_link'] : '',
      image: json['image'],
    );
  }
}
