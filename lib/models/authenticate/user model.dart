class UserModel {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String type;
  late String bio;
  late String image;
  late String facebook;
  late String instagram;
  late String twitter;
  late String snapchat;
  late String tiktok;
  late String country;
  late String age;
  late String position;
  late String placeOfWork;
  late String countryImage;
  List<SuccessFulCoursesModel> courses = [];

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.bio,
    required this.image,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.snapchat,
    required this.tiktok,
    required this.country,
    required this.age,
    required this.position,
    required this.placeOfWork,
    required this.countryImage,
    required this.courses,
  });

  UserModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'] ?? '';
    type = json['type'] ?? '';
    bio = json['bio'] ?? '';
    image = json['image'] ?? '';
    facebook = json['facebook'] ?? '  ';
    instagram = json['instagram'] ?? '  ';
    twitter = json['twitter'] ?? '  ';
    snapchat = json['snapchat'] ?? '  ';
    tiktok = json['tiktok'] ?? '  ';
    country = json['country'] ?? '';
    age = json['age'] ?? '';
    position = json['position'] ?? '';
    placeOfWork = json['Employer_name'] ?? ' ';
    countryImage = json['country_image'] ?? '';
    if (json['SuccessFulCourses'] != null) {
      courses = <SuccessFulCoursesModel>[];
      json['SuccessFulCourses'].forEach((v) {
        courses!.add(SuccessFulCoursesModel.fromJSON(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
      'bio': bio,
      'image': image,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'snapchat': snapchat,
      'tiktok': tiktok,
      'country': country,
      'age': age,
      'position': position,
      'Employer_name': placeOfWork,
      'country_image': countryImage,
    };
  }
}

class SuccessFulCoursesModel {
  late String course;
  late String degree;
  late String type;
  late String coach;

  SuccessFulCoursesModel({
    required this.course,
    required this.degree,
    required this.type,
    required this.coach,
  });

  factory SuccessFulCoursesModel.fromJSON(Map<String, dynamic> json) {
    return SuccessFulCoursesModel(
      course: json['course_name'] ?? '',
      degree: json['degree_success'] ?? '',
      coach: json['coach_name'] ?? '',
      type: json['type_of_course'] ?? '',
    );
  }
}
