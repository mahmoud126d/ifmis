class BannerModel{
  late int id;
  late String image;
  late String type;
  late String link;

  BannerModel({
    required this.id,
    required this.image,
    required this.type,
    required this.link,
  });

  factory BannerModel.fromJSON(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'] ?? '',
      type: json['type']??'',
      link: json['link']??'',
    );
  }
}