
import '../language/language.dart';

class MemberModel {
  late int id;
  late LanguageModel name;

  MemberModel({
    required this.id,
    required this.name,
  });

  factory MemberModel.fromJSON(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['name']),
    );
  }
}

class MemberDetailsModel {
  late int id;
  late LanguageModel name;
  late String image;
  late String whats;
  late LanguageModel job;
  late String countryImage;
  late LanguageModel countryName;
  late LanguageModel bio;

  MemberDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.job,
    required this.countryImage,
    required this.countryName,
    required this.bio,
    required this.whats,
  });

  factory MemberDetailsModel.fromJSON(Map<String, dynamic> json) {
    return MemberDetailsModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['name']),
      image: json['image'],
      job: json['job_title'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['job_title']),
      countryImage: json['country_image'],
      whats: json['whatsapp_number'],
      countryName: json['country_name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['country_name']),
      bio: json['bio'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['bio']),
    );
  }
}
