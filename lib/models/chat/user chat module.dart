class UserChatModule {
  late int id;
  late String image;

  UserChatModule({
    required this.id,
    required this.image,
  });

  factory UserChatModule.fromJSON(Map<String, dynamic> json) {
    return UserChatModule(
      id: json['id'],
      image: json['image'] == null
          ? ''
          : 'https://iffsma-2030.com/public/uploads/users/${json['image']}',
    );
  }
}
