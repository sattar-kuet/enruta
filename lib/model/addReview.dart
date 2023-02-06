import 'dart:convert';

class OrderModel {
  OrderModel(
      {this.id,
      this.titleTxt,
      this.subTxt,
      this.price,
      this.imagePath,
      this.date,
      this.shopName,
      this.status});

  int id;
  String titleTxt;
  String subTxt;
  String price;
  String imagePath;
  String date;
  String shopName;
  String status;

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

  Map<String, dynamic> toJson() => {
        "id": id,
        "titleTxt": titleTxt,
        "subTxt": subTxt,
        "price": price,
        "imagePath": imagePath,
        "date": date,
        "status": status,
        "shopName": shopName
      };
}

class AddReview {
  int user_id;
  int shop_id;
  double rating;
  String comment;
  int order_id;
  AddReview({
    this.user_id,
    this.shop_id,
    this.rating,
    this.comment,
    this.order_id
  });
  factory AddReview.fromJson(Map<String, dynamic> json) => AddReview(
      user_id: json["user_id"],
      shop_id: json["shop_id"],
      rating: json["rating"],
      order_id: json['order_id'],
      comment: json["comment"]);

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "shop_id": shop_id,
        "rating": rating,
        "comment": comment,
        "order_id":order_id
      };
}
