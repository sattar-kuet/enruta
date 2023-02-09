import 'dart:convert';

import 'category_model.dart';

Respons responsFromJson(String str) => Respons.fromJson(json.decode(str));

String responsToJson(Respons data) => json.encode(data.toJson());

class Respons {
  Respons({
    this.status,
    this.categories,
  });

  int? status;
  List<Category>? categories;

  factory Respons.fromJson(Map<String, dynamic> json) => Respons(
        status: json["status"],
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}
