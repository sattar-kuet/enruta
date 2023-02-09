import 'dart:convert';

import 'package:enruta/model/Product_model.dart';
import 'package:get/get.dart';

CartItemModel cartItemModelFromJson(String str) =>
    CartItemModel.fromJson(json.decode(str));

String cartItemModelToJson(CartItemModel data) => json.encode(data.toJson());

class CartItemModel {
  CartItemModel({
    this.shopId,
    this.products,
  });

  int? shopId;
  List<Product>? products;

  Rx<Product?> _product = Rx<Product?>(null);
  set product(Product? value) => _product.value = value;
  Product? get product => _product.value;

  RxInt _quantity = RxInt(0);
  set quantity(int value) => _quantity.value = value;
  int get quantity => _quantity.value;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        shopId: json["shopId"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shopId": shopId,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

// class Product {
//     Product({
//         this.id,
//         this.title,
//         this.subTxt,
//         this.price,
//         this.logo,
//         this.qty,
//         this.pqty,
//     });

//     int id;
//     String title;
//     String subTxt;
//     int price;
//     String logo;
//     int qty;
//     int pqty;

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         title: json["title"],
//         subTxt: json["subTxt"],
//         price: json["price"],
//         logo: json["logo"],
//         qty: json["qty"],
//         pqty: json["pqty"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "subTxt": subTxt,
//         "price": price,
//         "logo": logo,
//         "qty": qty,
//         "pqty": pqty,
//     };
// }
