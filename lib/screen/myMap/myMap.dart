import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'address_model.dart';
import 'mapController.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late final GoogleMapController mapController;
  late final TextEditingController _searchTextController;
  late final TextEditingController locationNameController;

  final myMapController = Get.put(MyMapController(), tag: 'MyMap');
  TestController mapcontroll = Get.find();

  LatLng _center = const LatLng(45.521563, -122.677433);

  // LatLng get initialPos => _center;
  bool buscando = false;

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  @override
  void initState() {
    super.initState();
    _center = LatLng(mapcontroll.userlat.value, mapcontroll.userlong.value);
    _searchTextController = TextEditingController();
    locationNameController = TextEditingController();
  }

  void getMoveCamera() async {
    final lat = _center.latitude;
    final lng = _center.longitude;

    final address = await Helper().getNearbyPlaces(lat, lng);

    myMapController
      ..pointerlat.value = lat
      ..pointLong.value = lng
      ..pointAddress.value = address;
  }

  void onCameraMove(CameraPosition position) async {
    setState(() {});
    buscando = false;
    _center = position.target;
  }

  final locationData = AddressModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: FloatingActionButton(
          onPressed: () async {
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            await mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 17,
                ),
              ),
            );
          },
          child: Image.asset(
            "assets/icons/target.png",
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(target: _center, zoom: 17.7),
            minMaxZoomPreference: MinMaxZoomPreference(10.5, 16.8),
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onCameraMove: onCameraMove,
            onCameraIdle: () async {
              buscando = true;
              setState(() {});
              getMoveCamera();
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 20,
                    width: 20,
                    color: Colors.white,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.arrow_back_ios, size: 15),
                    ))),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: showbottom(),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 150,
              width: 150,
              padding: EdgeInsets.only(bottom: 50),
              child: Image.asset(
                "assets/icons/pointer.png",
                height: 110,
              ),
            ),
          ),
        ],
      ),
    );
  }

  searchAndNavigate() async {
    /*if (searchAddr != null) {
      await locationFromAddress(searchAddr!).then((result) {
        double startLatitude = result[0].latitude ?? 00;
        double startLongitude = result[0].longitude ?? 00;
        double destinationLatitude = result[0].latitude ?? 00;
        double destinationLongitude = result[0].longitude ?? 00;
        double miny = (startLatitude <= destinationLatitude) ? startLatitude : destinationLatitude;
        double minx = (startLongitude <= destinationLongitude) ? startLongitude : destinationLongitude;
        double maxy = (startLatitude <= destinationLatitude) ? destinationLatitude : startLatitude;
        double maxx = (startLongitude <= destinationLongitude) ? destinationLongitude : startLongitude;

        double southWestLatitude = miny;
        double southWestLongitude = minx;

        double northEastLatitude = maxy;
        double northEastLongitude = maxx;

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            50.0,
          ),
        );
      });
    }*/

    final searchText = _searchTextController.text;
    if (searchText.isNotEmpty) {
      final placeResult = await Helper().getPlaceByText(searchText);

      if (placeResult == null) {
        Fluttertoast.showToast(msg: 'No place found!');
        return;
      }

      final address = placeResult.formattedAddress ?? placeResult.vicinity ?? placeResult.name;
      myMapController.pointAddress.value = address;
      _searchTextController.text = address;

      final lat = placeResult.geometry?.location.lat ?? myMapController.pointerlat.value;
      final lng = placeResult.geometry?.location.lng ?? myMapController.pointerlong.value;

      mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    }
  }

  Widget showbottom() {
    return Container(
      // width: 200,
      height: 150,

      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Stack(
        children: [
          Positioned(
            bottom: 80.0,
            right: 0.0,
            left: 0.0,

            // child: showPaymentcart(),
            child: Container(
                height: 50.0,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Color(Helper.getHexToInt("#F0F0F0"))), color: Colors.white),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  contentPadding: EdgeInsets.all(5.0),
                                  backgroundColor: cardbackgroundColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: Get.width,

                                        // alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                padding: EdgeInsets.only(left: 15, top: 15),
                                                child: Text(
                                                  text('save_favorite_location'),
                                                  style: TextStyle(fontSize: 15, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#C4C4C4"))),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 0,
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                alignment: Alignment.topRight,
                                                // color: Colors.black,
                                                child: InkWell(
                                                  // onTap: Get.back(),

                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: Color(Helper.getHexToInt("#F2F2F2")),
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      color: theamColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      addresstype(context),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final controller = Get.put(CartController());
                                          var addrestype = locationNameController.text;

                                          await myMapController.savelocation(addrestype);
                                          controller.setDeliveryAddress(
                                            addressDetail: locationData.locationDetails,
                                            lat: locationData.lat,
                                            long: locationData.lng,
                                          );
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: Get.width,
                                          margin: EdgeInsets.only(bottom: 5, left: 15, right: 15),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11C7A1")), Color(Helper.getHexToInt("#11E4A1"))]),
                                            borderRadius: BorderRadius.circular(9),
                                          ),
                                          child: Center(
                                              child: Text(
                                            text('save'),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily: 'TTCommonsm',
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: []);
                            });
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Color(Helper.getHexToInt("#E8E8E8"))),
                        child: Image.asset("assets/icons/star.png"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: Obx(
                          () => TextField(
                            controller: _searchTextController,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                                hintText: myMapController.pointAddress.value,
                                helperStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.search, color: Color(Helper.getHexToInt("#11C7A1"))), onPressed: searchAndNavigate, iconSize: 30.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Positioned(
              bottom: 10.0,
              right: 10.0,
              left: 10.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final controller = Get.put(CartController());
                          var addrestype = locationNameController.text;

                          await myMapController.savelocation(addrestype).then((value) {
                            locationData.locationDetails = myMapController.addressList[myMapController.addressList.length - 1]?.locationDetails;
                            locationData.lat = myMapController.addressList[myMapController.addressList.length - 1]?.lat;
                            locationData.lng = myMapController.addressList[myMapController.addressList.length - 1]?.lng;
                            print("location: " + locationData.locationDetails!);
                            controller.setDeliveryAddress(
                              addressDetail: locationData.locationDetails,
                              lat: locationData.lat,
                              long: locationData.lng,
                            );
                            print("set address done");
                          });

                          // // mymapcont.pointAddress.value,
                          // var a = mymapcont.pointAddress.value;
                          // var b = mymapcont.pointLat.value.toString();
                          // var c = mymapcont.pointLong.value.toString();

                          // print("Btn pressed");
                          // var addrestype = textController.text;
                          // //Get.put(CartController()).setAddress(a, b, c);
                          // //Get.put(MyMapController()).savelocation(addrestype);
                          // Get.back();
                        },
                        child: Container(
                          height: 50,
                          // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                              Color(Helper.getHexToInt("#11C7A1")),
                              // Colors.green[600],
                              Color(Helper.getHexToInt("#11E4A1"))
                            ]),
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                              child: Text(
                            text('set_location'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'TTCommonsm',
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                            Color(Helper.getHexToInt("#11C7A1")),
                            Color(Helper.getHexToInt("#11E4A1")),
                          ]),
                        ),
                        child: Center(child: Image.asset("assets/icons/starw.png")),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // _showCupertinoDialog(BuildContext context) {
  //   Get.defaultDialog(
  //       title: "Save favorite location",
  //       titleStyle: TextStyle(color: Color(Helper.getHexToInt("#C4C4C4"))),
  //       content: addresstype(context),
  //       actions: [
  //         FlatButton(
  //             onPressed: () {
  //               var addrestype = textController.text;
  //               mymapcont.savelocation(addrestype);
  //             },
  //             child: saveAddress(context))
  //       ]);
  // }

  Widget addresstype(BuildContext context) {
    return Container(
        // height: 170,
        width: Get.width,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Container(
              height: 60,
              child: TextField(
                controller: locationNameController,
                decoration: InputDecoration(
                  hintText: text('Location name'),
                  hintStyle: TextStyle(color: Color(Helper.getHexToInt("#6F6F6F")).withOpacity(.8)),
                  border: OutlineInputBorder(
                    gapPadding: 2,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 2,
                    borderSide: BorderSide(color: theamColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              width: Get.width,
              // color: Color(Helper.getHexToInt("#F8F8F8")),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(Helper.getHexToInt("#DCDCDC")).withOpacity(.74),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Icon(
                      Icons.location_on,
                      color: theamColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      myMapController.pointAddress.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(Helper.getHexToInt("#6F6F6F")).withOpacity(.8),
                        fontFamily: 'TTCommonsm',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  // Widget goHomebottomfield(BuildContext context) {
  //   return InkWell(
  //     onTap: () {},
  //     child: Container(
  //       height: 50,
  //       // margin: EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(begin: Alignment.topLeft, colors: [
  //           Color(Helper.getHexToInt("#11C7A1")),
  //           // Colors.green[600],
  //           Color(Helper.getHexToInt("#11E4A1"))
  //         ]),
  //         // color: Colors.white,
  //         borderRadius: BorderRadius.circular(9),
  //       ),
  //       child: Center(
  //           child: Text(
  //         "Set Location",
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Colors.white,
  //           fontFamily: 'TTCommonsm',
  //         ),
  //       )),
  //     ),
  //   );
  // }

  Widget saveAddress(BuildContext context) {
    return InkWell(
      child: Container(
        // height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11C7A1")), Color(Helper.getHexToInt("#11E4A1"))]),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
            child: Text(
          text('save'),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'TTCommonsm',
          ),
        )),
      ),
    );
  }
}
