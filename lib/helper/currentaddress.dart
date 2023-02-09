import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class CurrentAddress {
  static String address = "";

  // static Future<String> getAddress() async {
// Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high,
//    forceAndroidLocationManager: true).catchError((err) => print(err));

//    final coordinates = Coordinates(position.latitude, position.longitude);

// // this fetches multiple address, but you need to get the first address by doing the following two codes
// var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
// var first = addresses.first;

// print("${first.featureName} : ${first.addressLine}");
// return first.toString();

  // Position position = await Geolocator()
  //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   Position position = await getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high,
  //           forceAndroidLocationManager: true)
  //       .catchError((err) => print(err + "sdfsdf"));
  //   // debugPrint('location: ${position.latitude}');
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   print("${first.featureName} : ${first.addressLine}");
  //   print("${first.addressLine}");
  //   return first.addressLine.toString();
  // }

  // static String addressShow() {
  //   String addresss = showAddress().toString();

  //   return address;
  // }

// ignore: unused_element
  _getLocation() async {
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return first.addressLine;
  }

  // static Future<String> showAddress() async {
  //   Position position = await getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high,
  //           forceAndroidLocationManager: true)
  //       .catchError((err) => print(err));
  //   debugPrint('location: ${position.latitude}');
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   // print("${first.featureName} : ${first.addressLine}");
  //   // print(first.addressLine);
  //   address = first.addressLine;
  // }
}
