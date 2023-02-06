import 'dart:convert';

AllOffers allOffersFromJson(String str) => AllOffers.fromJson(json.decode(str));

String allOffersToJson(AllOffers data) => json.encode(data.toJson());

class AllOffers {
  AllOffers({
    this.status,
    this.offers,
  });

  int status;
  List<Offer> offers;

  factory AllOffers.fromJson(Map<String, dynamic> json) => AllOffers(
        status: json["status"],
        offers: List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
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

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        shopId: json["shop_id"],
        title: json["title"],
        code: json["code"],
        discount: json["discount"],
        type: json["type"],
        validity: DateTime.parse(json["validity"]),
        minimumSpent: json["minimum_spent"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
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
      };
}
