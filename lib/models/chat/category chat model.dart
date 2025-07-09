
import '../language/language.dart';
class CategoryChatModel {
  late int id;
  late LanguageModel name;
  late String image;

  CategoryChatModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryChatModel.fromJSON(Map<String, dynamic> json) {
    return CategoryChatModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['name']),
      image: json['image'] ?? '',
    );
  }
}
