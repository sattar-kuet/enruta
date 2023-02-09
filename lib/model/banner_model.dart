// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
    BannerModel({
        this.status,
        this.banners,
    });

    int? status;
    List<Banner>? banners;

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        status: json["status"],
        banners: List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "banners": List<dynamic>.from(banners??[].map((x) => x.toJson())),
    };
}

class Banner {
    Banner({
        this.id,
        this.name,
        this.cover,
        this.shopIds,
    });

    int? id;
    String? name;
    String? cover;
    List<String>? shopIds;

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"],
        name: json["name"],
        cover: json["cover"],
        shopIds: List<String>.from(json["shop_ids"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover": cover,
        "shop_ids": List<dynamic>.from(shopIds!.map((x) => x)),
    };
}
