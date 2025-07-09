class ProgrammerModel {
  late String name;
  late String image;
  late String background;
  late String bio;
  late String linkedIn;
  late String freelancer;
  late String whatsapp;

  ProgrammerModel({
    required this.name,
    required this.image,
    required this.background,
    required this.bio,
    required this.linkedIn,
    required this.freelancer,
    required this.whatsapp,
  });

  factory ProgrammerModel.fromJSON(Map<String, dynamic> json) {
    return ProgrammerModel(
      name: json['name'],
      image: json['image'],
      background: json['img_cover'],
      bio: json['bio'],
      whatsapp: json['whatsapp_phone'],
      freelancer: json['freelancer_link'],
      linkedIn: json['linked_link'],
    );
  }
}
