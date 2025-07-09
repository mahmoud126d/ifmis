
import '../language/language.dart';

class SportServicesNewsModel {
  late int id;
  late LanguageModel title;
  late LanguageModel description;
  late String videoLink;
  late String sportServiceCategoryId;
  late String status;
  late String tellAboutYourself;
  late String publisherName;
  late String publisherAge;
  late String publisherCountryImage;
  late String date;
  late String publisherCountry;
  User? user;
  late List<ImageServices> images;

  SportServicesNewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoLink,
    required this.sportServiceCategoryId,
    required this.status,
    required this.images,
    required this.tellAboutYourself,
    required this.publisherName,
    required this.publisherAge,
    required this.publisherCountryImage,
    required this.publisherCountry,
    required this.date,
    required this.user,
  });

  SportServicesNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['title']);

    description = json['description'] == null
        ? LanguageModel(en: '', ar: '')
        : LanguageModel.fromJSON(json['description']);
    videoLink = json['video_link'] ?? '';
    sportServiceCategoryId = json['sport_service_category_id'] ?? '';
    status = json['status'] ?? '';
    tellAboutYourself = json['tell_about_yourself'] ?? '';
    publisherName = json['publisher_name'] ?? '';
    publisherAge = json['publisher_age'] ?? '';
    date = json['created_at'] ?? '';
    publisherCountryImage = json['publisher_country_image'] ?? '';
    publisherCountry = json['publisher_country'] ?? '';
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['media'] != null) {
      images = <ImageServices>[];
      json['media'].forEach((v) {
        images.add(ImageServices.fromJson(v));
      });
    }
  }
}

class ImageServices {
  late int id;
  late String image;
  late String sportServiceId;

  ImageServices({
    required this.id,
    required this.image,
    required this.sportServiceId,
  });

  factory ImageServices.fromJson(Map<String, dynamic> json) {
    return ImageServices(
      id: json['id'],
      image: json['image'],
      sportServiceId: json['sport_service_id'],
    );
  }
}

class User {
  late int id;
  late String name;
  ChatData? chat;

  User({
    required this.id,
    required this.name,
    required this.chat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      chat: json['chat'] != null
          ? ChatData.fromJson(json['chat'])
          : null as dynamic,
    );
  }
}

class ChatData {
  late int id;
  late String userId;
  late String categoryID;
  late LanguageModel name;

  ChatData({
    required this.id,
    required this.userId,
    required this.categoryID,
    required this.name,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'],
      userId: json['user_id'],
      categoryID: json['category_id'],
      name: LanguageModel.fromJSON(json['name']),
    );
  }
}
