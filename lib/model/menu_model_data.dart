import 'dart:convert';

import 'Product_model.dart';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  MenuModel({
    this.shopname,
    this.status,
    this.shopid,
    this.vat,
    this.deliveryCharge,
    this.shopCategory,
    this.categoryName,
    this.shopcover,
    this.products,
  });

  int? status;
  String? shopid;
  String? shopname;
  double? vat;
  double? deliveryCharge;
  int? shopCategory;
  String? categoryName;
  String? shopcover;
  List<Product>? products;

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        status: json["status"],
        shopid: json["shopid"],
        shopname: json["shopname"],
        vat: json["vat"].toDouble(),
        deliveryCharge: json["deliveryCharge"].toDouble(),
        shopCategory: json["shopCategory"],
        categoryName: json["categoryName"],
        shopcover: json["shopcover"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "shopid": shopid,
        "shopname": shopname,
        "vat": vat,
        "deliveryCharge": deliveryCharge,
        "shopCategory": shopCategory,
        "categoryName": categoryName,
        "shopcover": shopcover,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
