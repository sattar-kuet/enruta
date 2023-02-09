import 'dart:convert';

import 'package:enruta/screen/myMap/address_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'addressTypeModel.dart';

class MyMapController extends GetxController {
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController _mapController;
  final address = ''.obs;
  var userlat = 0.0.obs;
  var pointerlat = 0.0.obs;
  var userlong = 0.0.obs;
  var pointerlong = 0.0.obs;
  var pointLat = 0.0.obs;
  var cheker = 0.obs;
  var pointLong = 0.0.obs;
  var pointAddress = "".obs;

  // var cartList = List<Addres>().obs;
  // ignore: deprecated_member_use
  var addressList = List<AddressModel>().obs;

  // ignore: deprecated_member_use
  List<AddressTypeModel> addresstypeList = List<AddressTypeModel>().obs;

  AddressTypeModel selectedAddressType;

  @override
  void onInit() {
    super.onInit();

    getLocation();

    getlocationlist();
  }

  void setaddresstype() {
    addresstypeList = [
      AddressTypeModel(1, "Current Location"),
      AddressTypeModel(2, "Home"),
      AddressTypeModel(3, "Office"),
      AddressTypeModel(4, "Other"),
      AddressTypeModel(5, "Favorite Shopping Center")
    ];
  }

  getLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final coordinates = new Coordinates(position.latitude, position.longitude);
        userlat.value = position.latitude;
        userlong.value = position.longitude;
        pointerlat.value = position.latitude;
        pointerlong.value = position.longitude;
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        address.value = first.addressLine;
        address(first.addressLine);
        print("get location called. got : $address");
      }
    } on PlatformException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  getpointerLocation(double let, double lo) async {
    print("call api");
    print(let);

    // ignore: unused_local_variable
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordi = new Coordinates(let, lo);
    pointLat.value = let;
    pointLong.value = lo;
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordi);

    var first = addresses.first;
    pointAddress.value = first.addressLine;
    // pointAddress(first.addressLine);

    // print(pointAddress);
  }

  getpoitlocation() {
    getpointerLocation(pointLat.value, pointLong.value);
  }

  searchandNavigate(String searchAddr) async {
    locationFromAddress(searchAddr).then((result) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(result[0]?.latitude, result[0]?.longitude),
            zoom: 10.0,
          ),
        ),
      );
    });
  }

  void getlocationlist() {
    GetStorage box = GetStorage();
    List a = box.read('addressList');
    var b;

    //
    if (a != null) {
      // addressList.value = a.cast();
      print("from storage $a");
      addressList.value = a.map((data) => AddressModel.fromJson(jsonDecode(jsonEncode(data)))).toList().obs;

      print(b);

      // addressList.value =
      //     a.map((data) => AddressModel.fromJson(jsonDecode(data))).toList();
      // // print("get Worling");
    }
  }

  Future<void> savelocation(var addrestype) async {
    print("save location called");
    AddressModel addressModel = new AddressModel();
    // List addresssList = GetStorage().read<List>('addressList');

    addressModel.locationType = "5";

    addressModel.locationTitle = addrestype;
    String type = addrestype.toString().toLowerCase();

    if (type == "curent") {
      addressModel.locationType = "1";
      addressModel.locationTitle = "Curent Address";
      // addressModel.locationTitle = "Curent";
    } else if (type == "home") {
      addressModel.locationType = "2";
      addressModel.locationTitle = "Home";
      // addressModel.locationTitle = "Curent";
    } else if (type == "office") {
      addressModel.locationType = "3";
      addressModel.locationTitle = "Office";
      // addressModel.locationTitle = "Home";
    } else if (type == "other") {
      addressModel.locationType = "4";
      addressModel.locationTitle = "Other";
      // addressModel.locationTitle = "Other";
    } else {
      addressModel.locationTitle = addrestype;
      addressModel.locationType = "5";
    }
    if (type == null || type == "") {
      addressModel.locationTitle = "Other";
      addressModel.locationType = "4";
    }

    // if (addressList.length == 0) {
    //   addressModel.locationType = "1";
    //   addressModel.locationTitle = "Curent ";
    // } else if (addressList.length == 1) {
    //   addressModel.locationType = "2";
    //   addressModel.locationTitle = "Home";
    // } else if (addressList.length == 2) {
    //   addressModel.locationType = "3";
    //   addressModel.locationTitle = "Office";
    // } else if (addressList.length == 3) {
    //   addressModel.locationType = "4";
    //   addressModel.locationTitle = "Other";
    // } else if (addressList.length >= 4) {
    //   addressModel.locationType = "4";
    //   addressModel.locationTitle = "Other";
    // }

    addressModel.locationDetails = pointAddress.value;
    addressModel.lat = pointLat.value.toString();
    addressModel.lng = pointLong.value.toString();
    if (addressModel.locationDetails.isNotEmpty) {
      addressList.add(addressModel);
    }

    GetStorage box = GetStorage();

    //print("from direct ${addressList.value}");
    await box.write("addressList", addressList);

    List a = box.read('addressList');

    //
    if (a != null) {
      // addressList.value = a.cast();
      print("from storage $a");
      addressList.value = a.map((data) => AddressModel.fromJson(jsonDecode(jsonEncode(data)))).toList();
    }
    // getlocationlist();

    //     .toList();
    //addressList.value = a ;

    // addressList = GetStorage().read<Rxlist>('addressList');
    // addressList.value = (json.decode(a.toString()) as RxList)
    //     .map((data) => AddressModel.fromJson(data))
    //     .toList();

    // print("running upto here");
    //print(addressList[1].lat);
    cheker.value = addressList.length;
    Get.back();
    //print("fron fn addlist lenth = $cheker");

    // print(pointAddress.value);
    // print(pointLat);
    // print(pointLat);
  }
}
