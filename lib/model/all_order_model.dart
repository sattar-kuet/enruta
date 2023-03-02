// To parse this JSON data, do
//
//     final allOrderModel = allOrderModelFromJson(jsonString);

import 'dart:convert';

AllOrderModel allOrderModelFromJson(String str) => AllOrderModel.fromJson(json.decode(str));

String allOrderModelToJson(AllOrderModel data) => json.encode(data.toJson());

class AllOrderModel {
  AllOrderModel({
    this.status,
    this.orders,
  });

  int? status;
  List<OrderModel>? orders;

  factory AllOrderModel.fromJson(Map<String, dynamic> json) {
    final ordersMap = json["orders"];
    return AllOrderModel(
      status: json["status"],
      // orders: orders == null ? [] : List<OrderModel>.from(json["orders"].map((x) => OrderModel.fromJson(x))),
      orders: (ordersMap is Iterable && ordersMap.isEmpty) ? [] : List<OrderModel>.from(ordersMap?.map((x) => OrderModel.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class OrderModel {
  OrderModel(
      {this.products,
      this.id,
      this.titleTxt,
      this.subTxt,
      this.price,
      this.imagePath,
      this.date,
      this.shopName,
      this.status,
      this.isReviewTaken,
      this.statusValue,
      this.resType,
      this.shopId});

  // List<List<Product>>? products;
  List<Product>? products;
  int? id;
  int? shopId;
  String? titleTxt;
  String? subTxt;
  int? price;
  String? imagePath;
  String? date;
  String? shopName;
  String? status;
  String? resType;
  int? statusValue;
  bool? isReviewTaken;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final mapProducts = json["products"];
    final productsList = List<Map<String, dynamic>>.from(mapProducts);
    final products = productsList.map((map) => Product.fromJson(map)).toList();
    return OrderModel(
      // products: List<List<Product>>.from(json["products"].map((x) => List<Product>.from(x.map((x) => Product.fromJson(x))))),
      products: products,
      id: json["id"],
      shopId: json['shop_id'],
      titleTxt: json["titleTxt"],
      subTxt: json["subTxt"],
      price: json["price"],
      imagePath: json["imagePath"],
      date: json["date"],
      shopName: json["shopName"],
      status: json["status"],
      isReviewTaken: json['reveiw_taken'],
      statusValue: json['status_value'],
      resType: json['res_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "id": id,
        "shop_id": shopId,
        "titleTxt": titleTxt,
        "subTxt": subTxt,
        "price": price,
        "imagePath": imagePath,
        "date": date,
        "shopName": shopName,
        "status": status,
        "res_type": resType,
        "reveiw_taken": isReviewTaken,
        "status_value": statusValue
      };
}

class Product {
  Product({
    this.id,
    this.shopId,
    this.name,
    this.description,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.sizes,
    this.colors,
    this.logo,
    this.shop,
  });

  int? id;
  int? shopId;
  String? name;
  String? description;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic sizes;
  dynamic colors;
  List<Logo>? logo;
  Shop? shop;

  factory Product.fromJson(Map<String, dynamic> map) => Product(
        id: map["id"],
        shopId: map["shop_id"],
        name: map["name"],
        description: map["description"],
        price: map["price"],
        createdAt: DateTime.parse(map["created_at"]),
        updatedAt: DateTime.parse(map["updated_at"]),
        sizes: map["sizes"],
        colors: map["colors"],
        logo: List<Logo>.from(map["logo"].map((x) => Logo.fromJson(x))),
        shop: map["shop"] == null ? null : Shop.fromJson(map["shop"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "name": name,
        "description": description,
        "price": price,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "sizes": sizes,
        "colors": colors,
        "logo": List<dynamic>.from(logo!.map((x) => x.toJson())),
        "shop": shop == null ? null : shop!.toJson(),
      };
}

class Logo {
  Logo({
    this.id,
    this.diskName,
    this.fileName,
    this.fileSize,
    this.contentType,
    this.title,
    this.description,
    this.field,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.path,
    this.extension,
  });

  int? id;
  String? diskName;
  String? fileName;
  int? fileSize;
  String? contentType;
  dynamic title;
  dynamic description;
  String? field;
  int? sortOrder;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? path;
  String? extension;

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        id: json["id"],
        diskName: json["disk_name"],
        fileName: json["file_name"],
        fileSize: json["file_size"],
        contentType: json["content_type"],
        title: json["title"],
        description: json["description"],
        field: json["field"],
        sortOrder: json["sort_order"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        path: json["path"],
        extension: json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "disk_name": diskName,
        "file_name": fileName,
        "file_size": fileSize,
        "content_type": contentType,
        "title": title,
        "description": description,
        "field": field,
        "sort_order": sortOrder,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "path": path,
        "extension": extension,
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
    this.openAt,
    this.closeAt,
    this.close,
  });

  int? id;
  int? shopCategoryId;
  String? name;
  String? address;
  String? lat;
  String? lng;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? vat;
  double? deliveryCharge;
  int? shopOwnerId;
  String? openAt;
  String? closeAt;
  int? close;

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
        openAt: json["open_at"],
        closeAt: json["close_at"],
        close: json["close"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_category_id": shopCategoryId,
        "name": name,
        "address": address,
        "lat": lat,
        "lng": lng,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "vat": vat,
        "delivery_charge": deliveryCharge,
        "shop_owner_id": shopOwnerId,
        "open_at": openAt,
        "close_at": closeAt,
        "close": close,
      };
}
