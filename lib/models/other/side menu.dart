class SideMenuModel {
  late String nameAR;
  late String nameEN;
  late int id;

  SideMenuModel({
    required this.nameAR,
    required this.nameEN,
    required this.id,
  });

  SideMenuModel.fromJson(Map<String, dynamic> json) {
    nameAR = json['name_ar'];
    nameEN = json['name_en'];
    id = json['id'];
  }

}
