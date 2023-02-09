import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/voucher/voucherController.dart';
import 'package:enruta/screen/voucher/voucher_model.dart';
import 'package:enruta/widgetview/textwidget.dart';
import 'package:enruta/widgetview/voucherpanel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyVoucher extends StatelessWidget {
  final bool isFromSlider;
  MyVoucher({this.isFromSlider = false});
  // List<VoucherListData> voucherList = VoucherListData.voucherList;
  final voucherController = Get.put(VoucherController());

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    voucherController.getvoucher();
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
          title: Text(text('my_voucher'),
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
                    Container(
                      child: Obx(() {
                        if (voucherController.isLoading.value)
                          return Container(
                              height: 500,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        else
                          return voucherController.vdata.value != 0
                              ? getVoucher(
                                  context, voucherController.voucher.value!)
                              : Container(
                                  margin: EdgeInsets.all(50),
                                  child: Center(
                                      child: EmptyWidget(
                                          title: text('no_voucher'),
                                          subTitle:
                                              text('no_voucher_available_yet'),
                                          // image: 'assets/images/userIcon.png',
                                          image: null,
                                          packageImage: PackageImage.Image_2,
                                          titleTextStyle: Theme.of(context)
                                              .typography
                                              .dense
                                              // ignore: deprecated_member_use
                                              .headline4!
                                              .copyWith(
                                                  color: Color(0xff9da9c7)),
                                          subtitleTextStyle: Theme.of(context)
                                              .typography
                                              .dense
                                              // ignore: deprecated_member_use
                                              .bodyText1!
                                              .copyWith(
                                                  color: Color(0xffabb8d6)))),
                                );
                      }

                          //  { getVoucher(context, voucherController.voucher.value);}

                          ),
                    ),

                    // Container(
                    //     height: 120,
                    //     child: Obx(() => voucherController.voucher.value != null
                    //         ? VoucherView(
                    //             voucherData: voucherController.voucher.value)
                    //         : SizedBox(
                    //             height: 0,
                    //           ))
                    // )
                    // ListView(
                    //   shrinkWrap: true,
                    //   physics: ClampingScrollPhysics(),
                    //   children: [
                    //     ListView(
                    //       shrinkWrap: true,
                    //       physics: ClampingScrollPhysics(),
                    //       children:
                    //           List.generate(voucherList.length, (index) {
                    //         return VoucherView(
                    //           voucherData: voucherList[index],
                    //         );
                    //       }),
                    //     ),
                    //     // ListView(
                    //     //   shrinkWrap: true,
                    //     //   physics: ClampingScrollPhysics(),
                    //     //   children:
                    //     //       List.generate(locationList.length, (index) {
                    //     //     return VoucherView(
                    //     //       locationData: locationList[index],
                    //     //     );
                    //     //   }),
                    //     // ),
                    //   ],
                    // ),
                    // ),
                  ]))
            ])));
  }

  Widget getVoucher(BuildContext context, Voucher model) {
    return model.title != null
        ? Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Stack(
                children: [
                  VoucherPanelWidget(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    isCornerRounded: true,
                    color: Color(Helper.getHexToInt("#6EFFD1")),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      // padding: EdgeInsets.all(1.2),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(1),
                    child: TextWidget(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      isCornerRounded: true,
                      color: Color(Helper.getHexToInt("#EFFFFA")),
                      child: InkWell(
                        onTap: () {
                          print("add voucher");
                          voucherController.advoucher(isFromSlider);
                        },
                        child: Stack(
                          // ignore: deprecated_member_use
                          //overflow: Overflow.visible,
                          children: [
                            Positioned(
                              top: 13,
                              left: 16,
                              child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: Text(
                                    model.title ?? "",
                                    style: TextStyle(
                                      fontFamily: "TTCommonsd",
                                      fontSize: 16,
                                      color: black,
                                    ),
                                  )),
                            ),
                            Positioned(
                                top: 38,
                                left: 16,
                                child: Center(
                                  child: Text(
                                    model.code ?? "",
                                    style: TextStyle(
                                        fontFamily: "TTCommonsd",
                                        fontSize: 14,
                                        color: Color(
                                            Helper.getHexToInt("#9F9F9F"))),
                                  ),
                                )),
                            Positioned(
                              bottom: 21,
                              left: 16,
                              child: Center(
                                  child: Text(
                                "minimum \$" +
                                    (model.minOrder.toString() ?? ""),
                                style: TextStyle(
                                    fontFamily: "TTCommonsd",
                                    fontSize: 11,
                                    color:
                                        Color(Helper.getHexToInt("#9F9F9F"))),
                              )),
                            ),
                            Positioned(
                                bottom: 21,
                                right: 16,
                                child: Center(
                                  child: Text(
                                    DateFormat("yyyy-MM-dd")
                                        .format(model.validity!),
                                    style: TextStyle(
                                        fontFamily: "TTCommonsd",
                                        fontSize: 14,
                                        color: Color(
                                            Helper.getHexToInt("#9F9F9F"))),
                                  ),
                                )),
                            Positioned(
                                top: 13,
                                right: 16,
                                child: Container(
                                  height: 25,
                                  // width: 25,
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Color(
                                      Helper.getHexToInt("#C5FFEC"),
                                    ).withOpacity(0.67),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "\$" + model.discount.toString() ?? "",
                                      style: TextStyle(
                                          fontFamily: "TTCommonsd",
                                          fontSize: 14,
                                          color: Color(
                                              Helper.getHexToInt("#9F9F9F"))),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            height: 0,
          );
  }
}
