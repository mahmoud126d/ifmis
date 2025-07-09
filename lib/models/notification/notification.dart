class NotificationModel {
  late String id;
  late NotificationData data;

  NotificationModel({
    required this.id,
    required this.data,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = NotificationData.fromJson(json['data']);
  }
}

class NotificationData {
  late String titleEN;
  late String titleAR;
  late String bodyEN;
  late String bodyAR;

  NotificationData({
    required this.titleEN,
    required this.titleAR,
    required this.bodyEN,
    required this.bodyAR,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    titleEN = json['title_en'];
    titleAR = json['title_ar'];
    bodyEN = json['body_en'];
    bodyAR = json['body_ar'];
  }
}
