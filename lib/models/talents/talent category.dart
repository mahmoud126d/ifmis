
import '../language/language.dart';

class TalentCategoriesModel {
  late int id;
  late LanguageModel name;
  late String image;

  TalentCategoriesModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory TalentCategoriesModel.fromJSON(Map<String, dynamic> json) {
    return TalentCategoriesModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(ar: '', en: '')
          : LanguageModel.fromJSON(json['name']),
      image: json['image'] ?? '',
    );
  }
}
