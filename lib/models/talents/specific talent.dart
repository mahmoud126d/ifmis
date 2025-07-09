
import '../language/language.dart';

class SpecificTalentModel {
  late int id;
  late LanguageModel playerName;
  late String age;
  late String school;
  late String position;
  late String height;
  late String classRoom;
  late String video;
  late String userID;
  late String countryName;
  late String countryImage;
  double points = 0.0;
  late List<ImageServices> images;
  late List<TalentComments> comments;

  SpecificTalentModel({
    required this.id,
    required this.playerName,
    required this.age,
    required this.school,
    required this.position,
    required this.height,
    required this.classRoom,
    required this.images,
    required this.video,
    required this.comments,
    required this.points,
    required this.userID,
    required this.countryName,
    required this.countryImage,
  });

  SpecificTalentModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    playerName = json['player_name'] == null
        ? LanguageModel(ar: '', en: '')
        : LanguageModel.fromJSON(json['player_name']);
    age = json['player_age'] ?? '';
    school = json['school_name'] ?? '';
    position = json['Player_position'] ?? '';
    height = json['Player_height'] ?? '';
    classRoom = json['class_room'] ?? '';
    if (json['media'] != null) {
      images = <ImageServices>[];
      json['media'].forEach((v) {
        images.add(ImageServices.fromJson(v));
      });
    }
    if (json['comments'] != []) {
      comments = <TalentComments>[];
      json['comments'].forEach((v) {
        comments.add(TalentComments.fromJson(v));
      });
    }
    if (json['rating'] != []) {
      json['rating'].forEach((v) {
        points += double.parse(v['rate']);
      });
    }
    video = json['video_link'];
    userID = json['user_id'] ?? '';
    countryName = json['country_name'] ?? '';
    countryImage = json['country_image'] ?? '';
  }
}

class ImageServices {
  late int id;
  late String image;

  ImageServices({
    required this.id,
    required this.image,
  });

  factory ImageServices.fromJson(Map<String, dynamic> json) {
    return ImageServices(
      id: json['id'],
      image: json['image'],
    );
  }
}

class TalentComments {
  late String comment;
  late String date;
  late String name;
  late String image;

  TalentComments({
    required this.comment,
    required this.date,
    required this.name,
    required this.image,
  });

  factory TalentComments.fromJson(Map<String, dynamic> json) {
    return TalentComments(
      comment: json['comment'],
      date: json['created_at'],
      name: json['user_name'],
      image: json['user_image'] ?? '',
    );
  }
}
