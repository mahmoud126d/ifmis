class MessageModel {
  late int messageID;
  late String userID;
  late String chatID;
  late String message;
  late String image;
  late String video;
  late UserMessage user;
  late ChatMessage chatMessage;
  late String date;

  MessageModel({
    required this.messageID,
    required this.userID,
    required this.chatID,
    required this.message,
    required this.image,
    required this.video,
    required this.user,
    required this.chatMessage,
    required this.date,
  });

  factory MessageModel.fromJSON(Map<String, dynamic> json) {
    return MessageModel(
      messageID: json['id'],
      userID: json['user_id'],
      chatID: json['chat_group_id'],
      message: json['message'] ?? '',
      image: json['image'] ?? '',
      video: json['video'] ?? '',
      user: UserMessage.fromJSON(json['user']),
      chatMessage: ChatMessage.fromJSON(json['chat']),
      date: json['date'] ?? '',
    );
  }
}

class UserMessage {
  late int id;
  late String name;
  late String image;
  late String country;

  UserMessage({
    required this.id,
    required this.name,
    required this.image,
    required this.country,
  });

  factory UserMessage.fromJSON(Map<String, dynamic> json) {
    return UserMessage(
      id: json['id'],
      name: json['name'],
      image: json['image'] == null
          ? ''
          : 'https://iffsma-2030.com/public/uploads/users/${json['image']}',
      country: json['country'] ?? '',
    );
  }
}

class ChatMessage {
  late int id;
  late String messageAdmin;

  ChatMessage({
    required this.id,
    required this.messageAdmin,
  });

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      messageAdmin: json['user_id'] ?? '',
    );
  }
}
