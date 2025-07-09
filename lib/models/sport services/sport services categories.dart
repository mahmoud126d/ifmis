
import '../language/language.dart';

class SportServicesCategoriesModel {
  late int id;
  late LanguageModel name;
  late String image;

  SportServicesCategoriesModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SportServicesCategoriesModel.fromJSON(Map<String, dynamic> json) {
    return SportServicesCategoriesModel(
      id: json['id'],
      name: json['name'] == null ? LanguageModel(ar: '', en: '') : LanguageModel.fromJSON(json['name']),
      image: json['image'] ?? '',
    );
  }
}
