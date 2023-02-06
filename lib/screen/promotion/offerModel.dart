import 'dart:convert';

OfferModel offerModelFromJson(String str) => OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  OfferModel({
    this.status,
    this.offers,
  });

  int status;
  List<Offer> offers;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    status: json["status"],
    offers: json["offers"]==null?[]:List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "offers": List<dynamic>.from(offers?.map((x) => x.toJson())??[]),
  };
}

class Offer {
  Offer({
    this.id,
    this.shopId,
    this.title,
    this.code,
    this.discount,
    this.type,
    this.validity,
    this.minimumSpent,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.shop,
  });

  int id;
  int shopId;
  String title;
  String code;
  int discount;
  int type;
  DateTime validity;
  int minimumSpent;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  Shop shop;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json["id"],
    shopId: json["shop_id"],
    title: json["title"],
    code: json["code"],
    discount: json["discount"],
    type: json["type"],
    validity: json["validity"]==null?null:DateTime.parse(json["validity"]),
    minimumSpent: json["minimum_spent"],
    createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
    image: json["image"],
    shop: json["shop"]==null?null:Shop.fromJson(json["shop"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_id": shopId,
    "title": title,
    "code": code,
    "discount": discount,
    "type": type,
    "validity": validity.toIso8601String(),
    "minimum_spent": minimumSpent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image": image,
    "shop": shop.toJson(),
  };
}

class Shop {
  Shop({
    this.id,
    this.shopCategoryId,
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vat,
    this.deliveryCharge,
    this.shopOwnerId,
  });

  int id;
  int shopCategoryId;
  String name;
  String address;
  String lat;
  String lng;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  double vat;
  double deliveryCharge;
  int shopOwnerId;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json["id"],
    shopCategoryId: json["shop_category_id"],
    name: json["name"],
    address: json["address"],
    lat: json["lat"],
    lng: json["lng"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    vat: json["vat"].toDouble(),
    deliveryCharge: json["delivery_charge"].toDouble(),
    shopOwnerId: json["shop_owner_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_category_id": shopCategoryId,
    "name": name,
    "address": address,
    "lat": lat,
    "lng": lng,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "vat": vat,
    "delivery_charge": deliveryCharge,
    "shop_owner_id": shopOwnerId,
  };
}