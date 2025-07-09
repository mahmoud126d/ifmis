class CompetitionCommentModel {
  late int commentID;
  late String userID;
  late String competitorID;
  late String comment;
  late User user;

  CompetitionCommentModel({
    required this.commentID,
    required this.userID,
    required this.competitorID,
    required this.comment,
    required this.user,
  });

  factory CompetitionCommentModel.fromJSON(Map<String, dynamic> json) {
    return CompetitionCommentModel(
      commentID: json['id'],
      userID: json['user_id'],
      competitorID: json['contestant_id'],
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
