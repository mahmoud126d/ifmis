class ProductComment {
  late int id;
  late String productId;
  late String userId;
  late double rate;
  late String comment;
  late User user;

  ProductComment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rate,
    required this.comment,
    required this.user,
  });

  ProductComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    rate = double.parse(json['rate']);
    comment = json['comment'];
    user = (json['user'] != null ? User.fromJson(json['user']) : null)!;
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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
