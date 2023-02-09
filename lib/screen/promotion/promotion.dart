import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/menuandreviewpage.dart';

import 'package:enruta/screen/promotion/offerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'offerModel.dart';

class Promotion extends StatelessWidget {
  final offerController = Get.put(OfferController());

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
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
          title: Text(text('promotion'),
              style: TextStyle(
                  fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
            color: cardbackgroundColor,
            width: MediaQuery.of(context).size.width,
            child: ListView(children: [
              Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 10),
                  padding:
                      EdgeInsets.only(top: 25, left: 20, right: 10, bottom: 0),
                  child: Text(
                    text('restaurant_offer'),
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Color(Helper.getHexToInt("#22242A"))),
                  )),

              // Obx(() {
              //   if (voucherController.isLoading.value)
              //     return Center(child: CircularProgressIndicator());
              //   else
              //     return getVoucher(
              //         context, voucherController.voucher.value);
              // }

              Obx(() {
                if (offerController.allOffertems.length == 0)
                  return Center(child: CircularProgressIndicator());
                else
                  return offerController.allOffertems.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: offerController.allOffertems.length,
                          itemBuilder: (context, index) => promotionsimage(
                              offerController.allOffertems[index]),
                        )
                      : Container(
                          margin: EdgeInsets.all(50),
                          child: Center(
                              child: EmptyWidget(
                                  title: text('no_offer'),
                                  subTitle:
                                      text('no_current_offer_available_yet'),
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
                                      .copyWith(color: Color(0xffabb8d6)))),
                        );
              }),

              // Wrap(
              //   children: [
              //     Container(
              //         height: 400,
              //         child:
              //   ],
              // ),
              // // promotionsimage(),
              // promotionsimage2(),
              // promotionsimage3(),
              // restaurant(),
              // restaurant(),
              // restaurant(),
              // restaurant(),
              // Container(
              //     margin: EdgeInsets.only(top: 5),
              //     child: Column(children: [
              //       Text("Restaurant"),
              //     ]))
            ])));
  }

  Widget promotionsimage(Offer model) {
    return Container(
        width: Get.width,
        height: 220,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        // child: Image.asset(
        //   'assets/icons/offer2.png',
        //   fit: BoxFit.fill,
        // ),
        child: InkWell(
          onTap: () {
            offerController.setoffercode(model.discount, model.minimumSpent);

            Get.to(MenuAndReviewPage(
                model.shopId,
                model.shop!.vat,
                model.shop!.deliveryCharge,
                model.shop!.name,
                model.shop!.address));
          },
          child: Image.network(
            model.image??"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget promotionsimage2() {
    return Container(
      width: Get.width,
      height: 220,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Image.asset(
        'assets/icons/offer3.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget promotionsimage3() {
    return Container(
      width: Get.width,
      height: 220,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Image.asset(
        'assets/icons/offer1.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
