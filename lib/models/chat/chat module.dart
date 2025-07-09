import '../language/language.dart';

class ChatModel {
  late int id;
  late LanguageModel name;
  late String image;
  late String users;
  late String usersInChat;
  late String categoryID;
  late String chatAdmin;

  ChatModel({
    required this.id,
    required this.name,
    required this.image,
    required this.users,
    required this.usersInChat,
    required this.categoryID,
    required this.chatAdmin,
  });

  factory ChatModel.fromJSON(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'] == null
          ? LanguageModel(en: '', ar: '')
          : LanguageModel.fromJSON(json['name']),
      image: json['image'],
      users: json['number_of_users'],
      usersInChat: json['number_of_people'],
      categoryID: json['category_id'],
      chatAdmin: json['user_id'] ?? '',
    );
  }
}
