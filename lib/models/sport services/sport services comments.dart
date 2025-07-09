class SportServicesCommentsModel {
  late int commentID;
  late String comment;
  late User user;

  SportServicesCommentsModel({
    required this.commentID,
    required this.comment,
    required this.user,
  });

  factory SportServicesCommentsModel.fromJSON(Map<String, dynamic> json) {
    return SportServicesCommentsModel(
      commentID: json['id'],
      comment: json['comment'],
      user: User.fromJSON(json['user']),
    );
  }
}

class User {
  late int id;
  late String name;
  late String image;

  User({
    required this.id,
    required this.name,
    required this.image,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      image: json['image'] == null
          ? ''
          : 'https://iffsma-2030.com/public/uploads/users/${json['image']}',
    );
  }
}
