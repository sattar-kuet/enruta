import 'dart:ui';

import 'package:enruta/controllers/productController.dart';
import 'package:enruta/controllers/textController.dart';

// ignore: unused_import
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/model/popular_shop.dart';
import 'package:enruta/screen/menuandreviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/helper.dart';

class PopularShopListView extends StatelessWidget {
  PopularShopListView({Key? key, this.itemData, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final Datums? itemData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

//  Widget _bgCard(String titels, String imageicon, String info, String unit,
//       bool loveicon) {

//   }
  final pcontroller = Get.put(ProductController());
  final controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    itemData!.isFavorite.value = itemData!.favorite! ? itemData!.favorite! : false;
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAndReviewPage(
                        itemData?.shopId,
                        itemData?.vat,
                        itemData?.deliveryCharge,
                        itemData?.name,
                        itemData?.address,
                      )));
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  itemData!.name!,
                  style: GoogleFonts.poppins(fontSize: 17, color: Color(Helper.getHexToInt("#434343"))),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 35,
                child: Container(
                  // height: MediaQuery.of(context).size.height / 8,
                  // width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    image: DecorationImage(
                      alignment: Alignment.center,
                      matchTextDirection: false,
                      image: NetworkImage(itemData!.logo!), //AssetImage(itemData.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                )),
            Container(
                height: 35,
                // child: Padding(
                //     padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Container(
                          // height: 30,

                          padding: EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  // topRight: Radius.circular(10.0),
                                  // bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(3.0)),
                              color: Colors.black54),
                          // child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.5),
                            child: Text(
                              itemData!.time!,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontFamily: 'Poppinsr', fontSize: 10, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                            ),
                          )
                          // ),
                          ),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 5),
                          child: Container(
                            child: CircleAvatar(
                                // backgroundColor: itemData.isFavorite.value
                                //     ? Color(Helper.getHexToInt("#FFEEEE"))
                                //     : Color(Helper.getHexToInt("#F9F9F9")),
                                backgroundColor: Colors.black38,
                                child: Obx(
                                  () => IconButton(
                                    icon: itemData!.isFavorite.value
                                        ? Icon(Icons.favorite, color: Color(Helper.getHexToInt("#FF5A5A")), size: 15)
                                        : Icon(
                                            Icons.favorite,
                                            color: Color(Helper.getHexToInt("#C0C0C0")),
                                            size: 15,
                                          ),
                                    onPressed: () async {
                                      print(itemData!.shopId);
                                      // ignore: unused_local_variable
                                      List fav = [];
                                      var status = itemData!.isFavorite.value ? 0 : 1;
                                      print(' STATUS ==$status');
                                      print(' STATUS ==${itemData!.shopId}');
                                      pcontroller.sendfavorit(itemData!.shopId, status);

                                      itemData!.isFavorite.toggle();
                                      itemData!.favorite = !itemData!.favorite!;
                                      if (itemData!.isFavorite.value) {
                                        Datum data = Datum(
                                            address: itemData!.address,
                                            catId: itemData!.catId,
                                            deliveryCharge: itemData!.deliveryCharge,
                                            name: itemData!.name,
                                            favorite: itemData!.favorite,
                                            lat: itemData!.lat,
                                            lng: itemData!.lng,
                                            logo: itemData!.logo,
                                            shopId: itemData!.shopId,
                                            rating: itemData!.rating,
                                            shopStatus: itemData!.shopStatus,
                                            time: itemData!.time,
                                            totalReview: itemData!.totalReview,
                                            userId: itemData!.userId,
                                            vat: itemData!.vat);
                                        data.isFavorite.value = itemData!.favorite!;
                                        controller.nearFavList.add(data);
                                      } else {
                                        controller.nearFavList.removeWhere((element) => element!.catId == itemData!.catId);
                                      }

                                      // SharedPreferences pref = await SharedPreferences.getInstance();
                                      // if(itemData.isFavorite.value == true){
                                      //   fav.add(itemData);
                                      // }else{
                                      //   fav.remove(itemData);
                                      // }
                                      // pref.setStringList('FAV_List', fav);
                                      // controller.getnearByPlace();
                                      itemData!.isFavorite.value
                                          ? Get.snackbar('Added in Favourites', '', colorText: Colors.white)
                                          : Get.snackbar('Removed from Favourites', '', colorText: Colors.white);
                                    },
                                  ),
                                )),
                          )),
                    ),
                  ],
                )),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 45),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        height: 30,

                        // width: 100,
                        // padding: EdgeInsets.only(left: 20),
                        // margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: Colors.white.withOpacity(0.5)),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 7),
                                  child: RatingBar.builder(
                                    initialRating: itemData!.rating!,

                                    // minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 11,
                                    ignoreGestures: true,

                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      size: 1.0,
                                      color: Colors.amber,
                                    ),

                                    onRatingUpdate: (rating) {
                                      print(itemData!.rating);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child:
                            Container(
                                // width: 50,
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    print(itemData!.shopId);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => GetReviewPage(
                                    //             [itemData.shopId],
                                    //             itemData.shopId,itemData.totalReview)));
                                  },
                                  child: Text(
                                    // '8888522 Reviews',
                                    ' ${itemData!.totalReview} Reviews',
                                    style: TextStyle(fontFamily: 'TTCommonsd', fontSize: 11, color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                    textAlign: TextAlign.end,
                                  ),
                                )),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(bottom: 28, left: 10, right: 10, child: Divider()),
            // Positioned(
            //   bottom: 10,
            //   left: 10,
            //   right: 10,
            //   child: Text(
            //     itemData.name,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontFamily: 'TTCommonsr',
            //         fontSize: 17,
            //         color: Color(Helper.getHexToInt("#434343")).withOpacity(1)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
