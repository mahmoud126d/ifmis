
import '../language/language.dart';

class CategoryModel {
  late int id;
  late LanguageModel name;
  late String storeID;

  CategoryModel({
    required this.id,
    required this.name,
    required this.storeID,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['name']);
    storeID = json['store_model_id'];
  }
}
