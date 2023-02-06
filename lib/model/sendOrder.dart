import 'dart:convert';

SendOrderModel sendOrderModelFromJson(String str) =>
    SendOrderModel.fromJson(json.decode(str));

String sendOrderModelToJson(SendOrderModel data) => json.encode(data.toJson());

class SendOrderModel {
  SendOrderModel(
      {this.userId,
      this.delivery_address,
      this.tax,
      this.delivery_charge,
      this.coupon,
      this.voucher,
      this.offer,
      this.shop_category,
      this.paymentOption,
      this.lng,
      this.lat,
      this.items,
      this.shop_name,
      this.delivery_time_in_minutes,
      this.order_deadline});

  int userId;
  String delivery_address;
   String deliveryAddressType;
  double tax;
  double delivery_charge;
  double coupon;
  int voucher;
  int offer;
  String shop_category;
  String paymentOption;
  String shop_name;
  int delivery_time_in_minutes;
  String lng;
  String lat;
  String order_deadline;
  List<Item> items;

  factory SendOrderModel.fromJson(Map<String, dynamic> json) => SendOrderModel(
        userId: json["user_id"],
        delivery_address: json["delivery_address"],
        tax: json["tax"].toDouble(),
        delivery_charge: json["delivery_charge"].toDouble(),
        coupon: json["coupon"],
        voucher: json["voucher"],
        offer: json["offer"],
        shop_name: json["shop_name"],
        delivery_time_in_minutes: json["delivery_time_in_minutes"],
        shop_category: json["shop_category"],
        paymentOption: json["payment_option"],
        lng: json["lng"],
        lat: json["lat"],
        order_deadline: json["order_deadline"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "delivery_address": delivery_address,
        "tax": tax,
        "delivery_charge": delivery_charge,
        "coupon": coupon,
        "voucher": voucher,
        "offer": offer,
        "order_deadline": order_deadline,
        "shop_name": shop_name,
        "delivery_time_in_minutes": delivery_time_in_minutes,
        "shop_category": shop_category,
        "payment_option": paymentOption,
        "lng": lng,
        "lat": lat,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item(
      {this.name, this.productId, this.price, this.qty, this.color, this.size});
  String name;
  int productId;
  double price;
  int qty;
  String color = "";
  String size = "";

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
