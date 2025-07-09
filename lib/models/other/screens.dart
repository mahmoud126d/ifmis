class ScreensModel {
  late String nameAR;
  late String nameEN;
  late int id;
  late String image;

  ScreensModel({
    required this.nameAR,
    required this.nameEN,
    required this.id,
    required this.image,
  });

  ScreensModel.fromJson(Map<String, dynamic> json) {
    nameAR = json['name_ar'];
    nameEN = json['name_en'];
    id = json['id'];
    image = json['image'];
  }

}
