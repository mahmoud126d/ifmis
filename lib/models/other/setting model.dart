
import '../language/language.dart';

class SettingModel {
  late int id;
  late LanguageModel newsTicker;
  late LanguageModel intellectualProperty;
  late LanguageModel membershipTerms;
  late LanguageModel privacyPolicy;
  late LanguageModel evacuationResponsibilaty;
  late LanguageModel vision;
  late int userCount;
  late int visitors;
  late String value;
  late String whatsNumber;
  late LanguageModel storeText;
  late LanguageModel courseText;
  late LanguageModel talentText;

  SettingModel({
    required this.id,
    required this.newsTicker,
    required this.intellectualProperty,
    required this.membershipTerms,
    required this.privacyPolicy,
    required this.evacuationResponsibilaty,
    required this.vision,
    required this.userCount,
    required this.value,
    required this.visitors,
    required this.whatsNumber,
    required this.storeText,
    required this.courseText,
    required this.talentText,
  });

  factory SettingModel.fromJSON(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'],
      newsTicker: json['news_ticker'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['news_ticker']),
      intellectualProperty: json['intellectual_property'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['intellectual_property']),
      membershipTerms: json['membership_terms'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['membership_terms']),
      privacyPolicy: json['privacy_policy'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['privacy_policy']),
      evacuationResponsibilaty: json['Evacuation_responsibilaty'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['Evacuation_responsibilaty']),
      vision: json['vision'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['vision']),
      userCount: json['users_count'],
      visitors: int.parse(json['number_of_visitor']),
      value: json['switch'],
      whatsNumber: json['whatsapp_number'],
      storeText: json['store_text'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['store_text']),
      courseText: json['course_text'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['course_text']),
      talentText: json['course_message'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['course_message']),
    );
  }
}
