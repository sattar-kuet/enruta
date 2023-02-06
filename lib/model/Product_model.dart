import 'package:get/get.dart';

class Product {
  Product({this.id, this.shopId, this.title, this.subTxt, this.price, this.logo, this.qty, this.sizes, this.colors});

  int id;
  int shopId;
  String title;
  String subTxt;
  dynamic price;
  List<String> logo;
  List<String> sizes;
  String selectSize;
  String selectcolor;
  List<String> colors;

  var qty = 1;
  var pqty = 1.obs;
  var psize = "".obs;
  var pcolor = "".obs;

  Product.initial()
      : id = 0,
        title = '';

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        shopId: json["shop_id"],
        title: json["title"],
        subTxt: json["subTxt"],
        price: json["price"].toDouble(),
        logo: json["logo"] != null ? List<String>.from(json["logo"].map((x) => x)) : [],
        sizes: json["sizes"] != null ? List<String>.from(json["sizes"].map((x) => x)) : [],
        colors: json["colors"] != null ? List<String>.from(json["colors"].map((x) => x)) : [],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "title": title,
        "subTxt": subTxt,
        "price": price,
        "logo": List<dynamic>.from(logo.map((x) => x)),
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "qty": qty,
        "selectSize": selectSize,
        "selectcolor": selectcolor
      };
}
