import 'product.dart';

class FavouriteModel {
  late int id;
  late String userId;
  late String productId;
  late ProductModel  product;

  FavouriteModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.product,
  });

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    product = (json['product'] != null ? ProductModel.fromJson(json['product']) : null)!;
  }
}