import 'dart:convert';
import 'package:get/get.dart';

NearByPlace nearByPlaceFromJson(String str) =>
    NearByPlace.fromJson(json.decode(str));

String nearByPlaceToJson(NearByPlace data) => json.encode(data.toJson());

class NearByPlace {
  NearByPlace({
    this.status,
    this.data,
  });

  int? status;
  List<Datum>? data;

  factory NearByPlace.fromJson(Map<String, dynamic> json) => NearByPlace(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.shopId,
    this.shopStatus,
    this.catId,
    this.userId,
    this.discountOffer,
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

  int? shopId;
  int? shopStatus;
  int? catId;
  int? userId;
  int? discountOffer;
  String? name;
  double? vat;
  double? deliveryCharge;
  bool? favorite;
  String? time;
  String? logo;
  int? totalReview;
  double? rating;
  String? address;
  String? lat;
  String? lng;
  var isFavorite = false.obs;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        shopId: json["shopId"],
        shopStatus: json["shopStatus"],
        catId: json["catId"],
        userId: json["userId"],
        name: json["name"],
        discountOffer:
            json["discountOffer"] == null ? 0 : json["discountOffer"],
        vat: json["vat"] == null ? 0 : json["vat"].toDouble(),
        deliveryCharge: json["delivery_charge"].toDouble(),
        favorite: json["favorite"],
        time: json["time"],
        logo: json["logo"],
        totalReview: json["totalReview"],
        rating: double.parse(json["rating"]),
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
        "discountOffer": discountOffer,
        "time": time,
        "logo": logo,
        "totalReview": totalReview,
        "rating": rating.toString(),
        "address": address,
        "lat": lat,
        "lng": lng,
      };

  // factory Datum.fromJson(Map<String, dynamic> json) => Datum(
  //       shopId: json["shopId"],
  //       catId: json["catId"],
  //       userId: json["userId"],
  //       name: json["name"],
  //       favorite: json["favorite"],
  //       time: json["time"],
  //       logo: json["logo"],
  //       totalReview: json["totalReview"],
  //       rating: json["rating"].toDouble(),
  //       vat: json["vat"] == null ? null : json["vat"],
  //       deliveryCharge:
  //           json["delivery_charge"] == null ? null : json["delivery_charge"],
  //     );
  //
  // Map<String, dynamic> toJson() => {
  //       "shopId": shopId,
  //       "catId": catId,
  //       "userId": userId,
  //       "name": name,
  //       "favorite": favorite,
  //       "time": time,
  //       "logo": logo,
  //       "totalReview": totalReview,
  //       "rating": rating,
  //       "vat": vat == null ? null : vat,
  //       "delivery_charge": deliveryCharge == null ? null : deliveryCharge,
  //     };
}
