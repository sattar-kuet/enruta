import 'package:flutter/foundation.dart';

class OrderModel {
  OrderModel({this.id, this.titleTxt, this.subTxt, this.price, this.imagePath, this.date, this.shopName, this.status});

  int? id;
  String? titleTxt;
  String? subTxt;
  String? price;
  String? imagePath;
  String? date;
  String? shopName;
  String? status;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        titleTxt: json["titleTxt"],
        subTxt: json["subTxt"],
        price: json["price"],
        imagePath: json["imagePath"],
        date: json["date"],
        shopName: json["shopName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "titleTxt": titleTxt, "subTxt": subTxt, "price": price, "imagePath": imagePath, "date": date, "status": status, "shopName": shopName};
}

@immutable
class AddReview {
  const AddReview({this.userId, this.shopId, this.rating, this.comment, this.orderId});

  final int? userId;
  final int? shopId;
  final double? rating;
  final String? comment;
  final int? orderId;

  factory AddReview.fromJson(Map<String, dynamic> json) =>
      AddReview(userId: json["user_id"], shopId: json["shop_id"], rating: json["rating"], orderId: json['order_id'], comment: json["comment"]);

  Map<String, dynamic> toJson() => {"user_id": userId, "shop_id": shopId, "rating": rating, "comment": comment, "order_id": orderId};
}
