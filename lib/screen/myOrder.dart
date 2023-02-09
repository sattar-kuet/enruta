import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/orderController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/my_order_list_data.dart';
import 'package:enruta/view/my_order_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<MyorderListData> orderList = MyorderListData.orderList;
  final orderController = Get.put(OrderController());

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
          title: Text(text('my_orders'),
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
                            return orderController.isLoading.value &&
                                    orderController.allOrderList.isEmpty
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        top: 25,
                                        right: 5,
                                        bottom: 10),
                                    child: Text(
                                      text('past_orders'),
                                      style: TextStyle(
                                          fontFamily: "TTCommonsd",
                                          fontSize: 16,
                                          color: Color(
                                                  Helper.getHexToInt("#000000"))
                                              .withOpacity(0.8)),
                                    ),
                                  );
                          }),

                          Obx(() {
                            if (orderController.isLoading.value) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          2.5),
                                  child: Center(child: CircularProgressIndicator()));
                            } else if (orderController.allOrderList.length >
                                0) {
                              return ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: List.generate(
                                    orderController.allOrderList.length,
                                    (index) {
                                  return MyOrderListView(
                                    orderData:
                                        orderController.allOrderList[index],
                                  );
                                }),
                              );
                            } else {
                              return Container(
                                margin: EdgeInsets.all(50),
                                child: Center(
                                    child: EmptyWidget(
                                        title: text('no_order'),
                                        subTitle: text(
                                            'no_current_order_available_yet'),
                                        // image: 'assets/images/userIcon.png',
                                        image: null,
                                        packageImage: PackageImage.Image_2,
                                        // ignore: deprecated_member_use
                                        titleTextStyle: Theme.of(context)
                                            .typography
                                            .dense
                                            // ignore: deprecated_member_use
                                            .headline4!
                                            .copyWith(color: Color(0xff9da9c7)),
                                        // ignore: deprecated_member_use
                                        subtitleTextStyle: Theme.of(context)
                                            .typography
                                            .dense
                                            // ignore: deprecated_member_use
                                            .bodyText1!
                                            .copyWith(
                                                color: Color(0xffabb8d6)))),
                              );
                            }
                          }),

                          // Obx(
                          //   () => orderController.allOrderList.length > 0
                          //       ? ListView(
                          //           shrinkWrap: true,
                          //           physics: ClampingScrollPhysics(),
                          //           children: List.generate(
                          //               orderController.allOrderList.length,
                          //               (index) {
                          //             return MyOrderListView(
                          //               orderData:
                          //                   orderController.allOrderList[index],
                          //             );
                          //           }),
                          //         )
                          //       : SizedBox(
                          //           height: 0,
                          //         ),
                          // )
                          // Container(
                          //   height: 66,
                          //   width: MediaQuery.of(context).size.width,
                          //   margin: EdgeInsets.only(
                          //       top: 5, bottom: 5, left: 20, right: 20),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(8),
                          //       border: Border.all(
                          //           color:
                          //               Color(Helper.getHexToInt("#F0F0F0")))),
                          //   child: InkWell(
                          //     onTap: () {
                          //       print("add new address");
                          //     },
                          //     child: Stack(
                          //       children: [
                          //         Positioned(
                          //           top: 25,
                          //           left: 110,
                          //           child: Center(
                          //             child: Container(child: Icon(Icons.add)),
                          //           ),
                          //         ),
                          //         Positioned(
                          //             top: 25,
                          //             left: 147,
                          //             // right: 10,
                          //             child: Text(
                          //               "Add New Address",
                          //               style: TextStyle(
                          //                   fontFamily: "TTCommonsd",
                          //                   fontSize: 16,
                          //                   color: Color(
                          //                       Helper.getHexToInt("#11C4A1"))),
                          //             )),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ]))
            ])));
  }
}
