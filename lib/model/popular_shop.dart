import 'dart:convert';
import 'package:get/get.dart';

PopularShop popularShopFromJson(String str) =>
    PopularShop.fromJson(json.decode(str));

String popularShopToJson(PopularShop data) => json.encode(data.toJson());

class PopularShop {
  PopularShop({
    this.status,
    this.data,
  });

  int status;
  List<Datums> data;

  factory PopularShop.fromJson(Map<String, dynamic> json) => PopularShop(
        status: json["status"],
        data: List<Datums>.from(json["data"].map((x) => Datums.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datums {
  Datums({
    this.shopId,
    this.shopStatus,
    this.catId,
    this.userId,
    this.name,
    this.vat,
    this.deliveryCharge,
    this.favorite,
    this.time,
    this.logo,
    this.totalReview,
    this.rating,
    this.address,
    this.lat,
    this.lng,
  });

  int shopId;
  int shopStatus;
  int catId;
  int userId;
  String name;
  var vat;
  double deliveryCharge;
  bool favorite;
  String time;
  String logo;
  int totalReview;
  double rating;
  String address;
  String lat;
  String lng;
  var isFavorite = false.obs;

  factory Datums.fromJson(Map<String, dynamic> json) => Datums(
        shopId: json["shopId"],
        shopStatus: json["shopStatus"],
        catId: json["catId"],
        userId: json["userId"],
        name: json["name"],
        vat: json["vat"].toDouble(),
        deliveryCharge: json["delivery_charge"].toDouble(),
        favorite: json["favorite"],
        time: json["time"],
        logo: json["logo"],
        totalReview: json["totalReview"],
        rating: double.parse(json["rating"].toString()),
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "shopId": shopId,
        "shopStatus": shopStatus,
        "catId": catId,
        "userId": userId,
        "name": name,
        "vat": vat,
        "delivery_charge": deliveryCharge,
        "favorite": favorite,
        "time": time,
        "logo": logo,
        "totalReview": totalReview,
        "rating": rating.toString(),
        "address": address,
        "lat": lat,
        "lng": lng,
      };
}
