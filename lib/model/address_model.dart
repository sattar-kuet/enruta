//import 'dart:convert';

class Addres {
  Addres(
      {this.id,
      this.locationType,
      this.locationTitle,
      this.locationDetails,
      this.uLat,
      this.ulong});

  int id;
  String locationType;
  String locationTitle;
  String locationDetails;
  double uLat;
  double ulong;

  factory Addres.fromJson(Map<String, dynamic> json) => Addres(
        id: json["id"],
        locationType: json["locationType"],
        locationTitle: json["locationTitle"],
        locationDetails: json["locationDetails"],
        uLat: json["uLat"],
        ulong: json["ulong"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "locationType": locationType,
        "locationTitle": locationTitle,
        "locationDetails": locationDetails,
        "uLat": uLat,
        "ulong": ulong,
      };
}
