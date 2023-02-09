import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/myMap/mapController.dart';
import 'package:enruta/screen/myMap/myMap.dart';
import 'package:enruta/view/location_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SetLocation extends StatelessWidget {
  // List<LocationListData> locationList = LocationListData.locationList;
  final addressController = Get.put(MyMapController());

  final language = Get.put(LanguageController());
  final test = Get.put(TestController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    addressController.getlocationlist();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            onPressed: () {
              Get.back();
              // Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                  Color(Helper.getHexToInt("#11C7A1")),
                  // Colors.green[600],
                  Color(Helper.getHexToInt("#11E4A1"))
                ]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(text('set_location'),
              style: TextStyle(
                  fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
            color: cardbackgroundColor,
            child: Stack(children: [
              Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                          Obx(() {
                            print(
                                "From widget addresslenght ${addressController.cheker}");
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 15,bottom: 15),
                              physics: ClampingScrollPhysics(),
                              itemCount:
                                  addressController.addressList.length,
                              itemBuilder: (context, index) => Dismissible(
                                child: LocationListView(
                                  locationData:
                                      addressController.addressList[index],
                                  // cartData: cartCont.cartList[index],
                                ),
                                key: UniqueKey(),
                                onDismissed: (_) {
                                  GetStorage box = GetStorage();
                                  var removed =
                                      addressController.addressList[index];

                                  addressController.addressList.removeAt(index);
                                  box.write("addressList",
                                      addressController.addressList);
                                  // cartCont.totalcalculate();
                                  Get.snackbar('',
                                      text('the_address_successfully_removed'),
                                      colorText: Colors.white,
                                      // ignore: deprecated_member_use
                                      mainButton: TextButton(
                                        child: Text('Undo'),
                                        onPressed: () {
                                          if (removed == null) {
                                            return;
                                          }
                                          addressController.addressList
                                              .insert(index, removed);
                                          removed = null;
                                          if (Get.isSnackbarOpen) {
                                            Get.back();
                                          }
                                        },
                                      ));
                                },
                              ),
                              // separatorBuilder: (_, __) => Divider(),
                              separatorBuilder: (context, index) {
                                return Text("");
                              },
                            );
                          }),
// /**/                          ListView(
//                               shrinkWrap: true,
//                               physics: ClampingScrollPhysics(),
//                               children: List.generate(
//                                       addressController.addressList.length,
//                                       (index) => LocationListView(
//                                             locationData: addressController
//                                                 .addressList[index],
//                                           ))),
                          Container(
                            height: 66,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 2,
                                    color:
                                        Color(Helper.getHexToInt("#F0F0F0")))),
                            child: InkWell(
                              onTap: () {
                                print("add new address");
                                Get.to(MyMap());
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Icon(
                                      Icons.add,
                                      color:
                                          Color(Helper.getHexToInt("#11C4A1")),
                                    )),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        text('add_new_address'),
                                        style: TextStyle(
                                            fontFamily: "TTCommonsd",
                                            fontSize: 16,
                                            color: Color(
                                                Helper.getHexToInt("#11C4A1"))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]))
            ])));
  }

  // Widget addresstype() {
  //   List<AddressTypeModel> addresstypeList = [
  //     AddressTypeModel(1, "First Value"),
  //     AddressTypeModel(2, "Second Item"),
  //     AddressTypeModel(3, "Third Item"),
  //     AddressTypeModel(4, "Fourth Item")
  //   ];
  //   List<DropdownMenuItem<AddressTypeModel>> _dropdownItems;

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10.0),
  //           color: Colors.cyan,
  //           border: Border.all()),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton(
  //             items: _dropdownItems,
  //             onChanged: (value) {
  //               addressController.selectedAddressType = value;
  //             }),
  //       ),
  //     ),
  //   );
  // }
}
