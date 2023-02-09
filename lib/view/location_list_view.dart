import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/myMap/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationListView extends StatelessWidget {
  const LocationListView(
      {Key? key,
      this.locationData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  // final LocationListData locationData;
  final AddressModel? locationData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print("object");

          var a = locationData!.locationTitle;

          var b = locationData!.lat;
          var c = locationData!.lng;
          controller.selectAddressType.value = locationData!.locationType!;
          controller.selectAddressTitle.value = locationData!.locationTitle!;
          print("a=$a b=$b c= $c ");
          controller.setdeleveryAddress(
              addressdetails: locationData!.locationDetails,
              lat: locationData!.lat,
              long: locationData!.lng);
          print("set address done");
        },
        child: ListTile(
          leading: Container(
            height: 35,
            width: 35,
            child: CircleAvatar(
              backgroundColor: Color(Helper.getHexToInt("#CDFFEF")),
              radius: 60.0,
              child: Container(
                child: locationData!.locationType == '1'
                    ? Icon(
                        Icons.location_on,
                        size: 18,
                        color: Color(Helper.getHexToInt("#11C4A1")),
                      )
                    : locationData!.locationType == '2'
                        ? Icon(
                            Icons.home,
                            size: 18,
                            color: Color(Helper.getHexToInt("#11C4A1")),
                          )
                        : locationData!.locationType == '3'
                            ? Icon(
                                Icons.location_city,
                                size: 18,
                                color: Color(Helper.getHexToInt("#11C4A1")),
                              )
                            : Icon(
                                Icons.location_on,
                                size: 18,
                                color: Color(Helper.getHexToInt("#11C4A1")),
                              ),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              locationData!.locationTitle!,
              style: TextStyle(
                  fontFamily: "TTCommonsd",
                  fontSize: 16,
                  color: Color(Helper.getHexToInt("#000000"))),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              locationData!.locationDetails!,
              style: TextStyle(
                  fontFamily: "TTCommonsd",
                  fontSize: 14,
                  color: Color(Helper.getHexToInt("#9F9F9F"))),
            ),
          ),
        ),
      ),
    );
  }
}
