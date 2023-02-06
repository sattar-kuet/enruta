import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/menuController.dart';
import 'package:enruta/controllers/suggestController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/rating_list_data.dart';
import 'package:enruta/model/review_list_data.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:enruta/view/review_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../cartPage.dart';

// ignore: must_be_immutable
class ViewMenuPage extends StatelessWidget {
  final mController = Get.put(MenuController());
  final CartController cartCont = Get.put(CartController());
  final SuggestController suggestCont = Get.put(SuggestController());
  String shopid = "";
  var sname = "";

  ViewMenuPage({this.shopid, this.sname});

  List<ReviewListData> reviewList;
  List<RatingListData> ratingList = RatingListData.ratingList;

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResetController());
    reviewList = ReviewListData.reviewList;
    print(shopid);
    // mController.getmenuItems(shopid);
    // mController.getreview(int.parse(shopid));

    return Scaffold(
      body: nested(),
    );
  }

  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext contexts, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                  Color(Helper.getHexToInt("#11C7A1")),
                  // Colors.green[600],
                  Color(Helper.getHexToInt("#11E4A1"))
                ]),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  '2060  LA Colendge, BLvd 2.1 Miles- Fast Food ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'TTCommonsd',
                    fontSize: 11,
                  ),
                ),
                background: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                  // child: Opacity(
                  //   opacity: 0.5,
                  child: Stack(
                    children: [
                      Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Opacity(
                            opacity: 1,
                            child: Image.network(
                              "https://1.bp.blogspot.com/-y3B9YFnh0S4/WTrWPeodnmI/AAAAAAAAAKI/I9EfnPICQscVMyrGWRUPd7cxPHn5gHp3QCLcB/s320/IMG_3672_11.jpg",
                              fit: BoxFit.fill,
                            ),
                          )),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          color: Color(Helper.getHexToInt("#000000"))
                              .withOpacity(.5),
                        ),
                      ),
                      Positioned(
                          top: 50,
                          left: 50,
                          right: 50,
                          bottom: 50,
                          child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  this.sname ?? text('restaurant'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'TTCommonsm',
                                  ),
                                ),
                              )
                              // child: Image.asset(
                              //     'assets/icons/shoplogo.png')),
                              )),
                    ],
                  ),
                  // ),
                ),
              ),
            ),
          )
        ];
      },
      body: Center(
        child: Container(
          color: cardbackgroundColor,
          child: Stack(
            children: [
              Obx(() {
                if (mController.isLoading.value)
                  return Center(child: CircularProgressIndicator());
                else
                  return StaggeredGridView.countBuilder(
                    itemCount: mController.menuItems.length,
                    crossAxisCount: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    itemBuilder: (context, index) {
                      return ReviewListView(
                        menuitemdata: mController.menuItems[index],
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  );
              }),
              // Obx(
              //   () => ListView.builder(
              //       itemCount: mController.menuItems.length,
              //       itemBuilder: (context, index) {
              //         return ReviewListView(
              //             reviewData: mController.menuItems[index]);
              //       }),
              // ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: buidbottomfield(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buidbottomfield() {
    return InkWell(
      onTap: () async {
        // if (cartCont.cartList.length < 0) {
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   // prefs.setString('shopid', shop_id.toString());
        //   // prefs.setInt('vat', vat);
        //   // prefs.setInt("deliveryCharge", deliveryCharge);
        // }

        suggestCont.getsuggetItems();
        // // Get.find<SuggestController>().getsuggetItems();
        // // Get.find<CartController>().vat.value = vat;
        // // Get.find<CartController>().deliveryCharge.value = deliveryCharge;
        // // print('$vat $deliveryCharge');
        Get.to(CartPage());
      },
      child: Stack(
        children: [
          Container(
            height: 60,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
                child: Text(
              text('VIEW_CART_&_CHECKOUT'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'TTCommons Medium',
              ),
            )),
          ),
          Positioned(
            left: 20,
            top: 15,
            child: InkWell(
              child: Container(
                alignment: Alignment.topLeft,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Color(Helper.getHexToInt("#41E9C3")),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Obx(
                  () => cartCont.cartList.length != null
                      ? Text(
                          cartCont.cartList.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TTCommons',
                          ),
                        )
                      : Text("0"),
                )),
              ),
            ),
          ),
          Positioned(
              right: 20,
              top: 10,
              bottom: 10,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: white,
                  ),
                  onPressed: null)
              // )
              )
        ],
      ),
    );
  }
}
