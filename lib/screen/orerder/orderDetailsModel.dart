// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.status,
    this.order,
  });

  int? status;
  Order? order;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        status: json["status"],
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order": order!.toJson(),
      };
}

class Order {
  Order(
      {this.id,
      this.customerId,
      this.tax,
      this.deliveryCharge,
      this.paymentOption,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.shopOwnerId,
      this.number,
      this.lng,
      this.lat,
      this.coupon,
      this.voucher,
      this.offer,
      this.shopId,
      this.subTxt,
      this.price,
      this.imagePath,
      this.date,
      this.orderFrom,
      this.orderItemNames,
      this.address});

  int? id;
  int? customerId;
  double? tax;
  double? deliveryCharge;
  String? paymentOption;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? shopOwnerId;
  String? number;
  String? lng;
  String? lat;
  double? coupon;
  double? voucher;
  double? offer;
  int? shopId;
  String? subTxt;
  int? price;
  String? imagePath;
  String? date;
  String? address;
  String? orderFrom;
  String? orderItemNames;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["id"],
      customerId: json["customer_id"],
      tax: json["tax"].toDouble(),
      deliveryCharge: json["delivery_charge"].toDouble(),
      paymentOption: json["payment_option"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      shopOwnerId: json["shop_owner_id"],
      number: json["number"],
      lng: json["lng"],
      lat: json["lat"],
      coupon: json["coupon"].toDouble(),
      voucher: json["voucher"].toDouble(),
      offer: json["offer"].toDouble(),
      shopId: json["shop_id"],
      subTxt: json["subTxt"],
      price: json["price"],
      imagePath: json["imagePath"],
      date: json["date"],
      orderFrom: json["orderFrom"],
      orderItemNames: json["orderItemNames"],
      address: json["address"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "tax": tax,
        "delivery_charge": deliveryCharge,
        "payment_option": paymentOption,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "shop_owner_id": shopOwnerId,
        "number": number,
        "lng": lng,
        "lat": lat,
        "coupon": coupon,
        "voucher": voucher,
        "offer": offer,
        "shop_id": shopId,
        "subTxt": subTxt,
        "price": price,
        "imagePath": imagePath,
        "date": date,
        "orderFrom": orderFrom,
        "orderItemNames": orderItemNames,
        "address": address
      };
}
