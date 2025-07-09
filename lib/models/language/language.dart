class LanguageModel {
  late String ar;
  late String en;

  LanguageModel({
    required this.en,
    required this.ar,
  });

  factory LanguageModel.fromJSON(Map<String, dynamic> json) {
    return LanguageModel(
      en: json['en'].toString().replaceAll('nbsp', '').replaceAll(';', '').replaceAll('&', '').replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<p style=\"text-align: left;\">', '').replaceAll('&ndash;', '').replaceAll('<p style="text-align: left">', ''),
      ar: json['ar'].toString().replaceAll('nbsp', '').replaceAll(';', '').replaceAll('&', '').replaceAll('<p>', '').replaceAll("</p>", '').replaceAll('<p style=\"text-align: left;\">', '').replaceAll('&ndash;', '').replaceAll('<p style="text-align: left">', ''),
    );
  }
}
