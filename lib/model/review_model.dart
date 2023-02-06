import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    this.status,
    this.reviews,
  });

  int status;
  List<Review> reviews;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        status: json["status"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Review {
  Review(
      {this.id,
      this.logo,
      this.title,
      this.subtitle,
      this.rating,
      this.date,
      this.qty});

  int id;
  String logo;
  String title;
  String subtitle;
  double rating;
  String date;
  String qty;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        logo: json["logo"],
        title: json["title"],
        subtitle: json["subtitle"],
        rating: json["rating"].toDouble(),
        date: json["date"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "title": title,
        "subtitle": subtitle,
        "rating": rating,
        "date": date,
        "qty": qty,
      };
}
