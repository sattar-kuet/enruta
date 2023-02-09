import 'dart:convert';

SendOrderModel sendOrderModelFromJson(String str) =>
    SendOrderModel.fromJson(json.decode(str));

String sendOrderModelToJson(SendOrderModel data) => json.encode(data.toJson());

class SendOrderModel {
  SendOrderModel(
      {this.userId,
      this.deliveryAddress,
      this.tax,
      this.deliveryCharge,
      this.coupon,
      this.voucher,
      this.offer,
      this.shopCategory,
      this.paymentOption,
      this.lng,
      this.lat,
      this.items,
      this.shopName,
      this.deliveryTimeInMinutes,
      this.orderDeadline});

  int? userId;
  String? deliveryAddress;
   String? deliveryAddressType;
  double? tax;
  double? deliveryCharge;
  double? coupon;
  int? voucher;
  int? offer;
  String? shopCategory;
  String? paymentOption;
  String? shopName;
  int? deliveryTimeInMinutes;
  String? lng;
  String? lat;
  String? orderDeadline;
  List<Item>? items;

  factory SendOrderModel.fromJson(Map<String, dynamic> json) => SendOrderModel(
        userId: json["user_id"],
        deliveryAddress: json["delivery_address"],
        tax: json["tax"].toDouble(),
        deliveryCharge: json["delivery_charge"].toDouble(),
        coupon: json["coupon"],
        voucher: json["voucher"],
        offer: json["offer"],
        shopName: json["shop_name"],
        deliveryTimeInMinutes: json["delivery_time_in_minutes"],
        shopCategory: json["shop_category"],
        paymentOption: json["payment_option"],
        lng: json["lng"],
        lat: json["lat"],
        orderDeadline: json["order_deadline"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "delivery_address": deliveryAddress,
        "tax": tax,
        "delivery_charge": deliveryCharge,
        "coupon": coupon,
        "voucher": voucher,
        "offer": offer,
        "order_deadline": orderDeadline,
        "shop_name": shopName,
        "delivery_time_in_minutes": deliveryTimeInMinutes,
        "shop_category": shopCategory,
        "payment_option": paymentOption,
        "lng": lng,
        "lat": lat,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item(
      {this.name, this.productId, this.price, this.qty, this.color, this.size});
  String? name;
  int? productId;
  double? price;
  int? qty;
  String? color = "";
  String? size = "";

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      name: json["name"],
      productId: json["product_id"],
      price: json["price"],
      qty: json["qty"],
      size: json["size"],
      color: json["color"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "product_id": productId,
        "price": price,
        "qty": qty,
        "size": size,
        "color": color
      };
}
