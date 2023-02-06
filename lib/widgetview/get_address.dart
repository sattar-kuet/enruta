import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GetAddress extends StatelessWidget {
  // Geolocator _geolocator = Geolocator();
  String latitude = "";
  String longitude = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("address"),
      ),
    );
  }
}
