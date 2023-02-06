import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel(
      {this.status,
      this.locationType,
      this.locationTitle,
      this.locationDetails,
      this.lat,
      this.lng});

  int status;
  String locationType;
  String locationTitle;
  String locationDetails;
  String lat;
  String lng;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        status: json["status"],
        locationType: json["locationType"],
        locationTitle: json["locationTitle"],
        locationDetails: json["locationDetails"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "locationType": locationType,
        "locationTitle": locationTitle,
        "locationDetails": locationDetails,
        "lat": lat,
        "lng": lng,
      };
}
