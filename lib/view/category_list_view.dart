import 'dart:ui';

import 'package:enruta/controllers/productController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/model/popular_shop.dart';
import 'package:enruta/model/search_item.dart';
import 'package:enruta/screen/getReview/getReview.dart';
import 'package:enruta/screen/menuandreviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({Key? key, this.itemData, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final SearchData? itemData;

  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.put(ProductController());
    final controller = Get.find<TestController>();
    itemData!.favorite = itemData!.favorite! ? itemData!.favorite : false;
    return Container(
      height: 255,
      width: 200,
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
                      itemData!.shopId, itemData!.vat!.toDouble(), itemData!.deliveryCharge!.toDouble(), itemData!.name, itemData!.address, itemData!.time)));
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      image: DecorationImage(
                        alignment: Alignment.center,
                        matchTextDirection: false,
                        image: NetworkImage(itemData!.logo!), //AssetImage(itemData.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                // height: MediaQuery.of(context).size.height / 20,
                // child: Padding(
                //     padding: const EdgeInsets.only(top: 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 8,
                          top: 10,
                          right: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(3.0)),
                          color: Colors.black54,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.2),
                          child: Text(
                            // itemData.catId.toString(),
                            itemData!.time!,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontFamily: 'Poppinsr', fontSize: 10, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            right: 5,
                          ),
                          child: CircleAvatar(
                              radius: 15,
                              // backgroundColor: itemData.isFavorite.value
                              //     ? Color(Helper.getHexToInt("#FFEEEE"))
                              //     : Color(Helper.getHexToInt("#F9F9F9")),
                              backgroundColor: Colors.black38,
                              child: Obx(
                                () => IconButton(
                                  icon: itemData!.favorite!
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
                                    var status = itemData!.favorite! ? 0 : 1;
                                    print(' STATUS ==$status');
                                    print(' STATUS ==${itemData!.shopId}');
                                    pcontroller.sendfavorit(itemData!.shopId, status);

                                    if (itemData!.favorite!) {
                                      // controller.nearFavList.add(itemData);
                                    } else {
                                      controller.nearFavList.removeWhere((element) => element!.catId == itemData!.catId);
                                    }
                                    itemData!.favorite = !itemData!.favorite!;

                                    // SharedPreferences pref = await SharedPreferences.getInstance();
                                    // if(itemData.isFavorite.value == true){
                                    //   fav.add(itemData);
                                    // }else{
                                    //   fav.remove(itemData);
                                    // }
                                    // pref.setStringList('FAV_List', fav);
                                    // controller.getnearByPlace();
                                    itemData!.favorite!
                                        ? Get.snackbar('Added in Favourites', '', colorText: Colors.white)
                                        : Get.snackbar('Removed from Favourites', '', colorText: Colors.white);
                                  },
                                ),
                              ))),

                      // Expanded(
                      //     // child: Padding(
                      //     //     padding: const EdgeInsets.all(0.0),
                      //     child: Container(
                      //         margin: EdgeInsets.only(right: 40),
                      //         padding:
                      //             EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(10.0),
                      //               bottomRight: Radius.circular(10.0)),
                      //           color: Color(Helper.getHexToInt("#ECFBF8")),
                      //         ),
                      //         // child: Center(
                      //         child: Expanded(
                      //           flex: 3,
                      //           child: Text(
                      //             itemData.time,
                      //             textAlign: TextAlign.left,
                      //             style: TextStyle(
                      //                 fontFamily: 'Poppinsr',
                      //                 fontSize: 10,
                      //                 color:
                      //                     Color(Helper.getHexToInt("#11C4A1"))
                      //                         .withOpacity(1)),
                      //           ),
                      //         )
                      //         // ),
                      //         )),
                      // Center(
                      //   child: Container(
                      //       margin: EdgeInsets.only(right: 5, top: 1),
                      //       child: Obx(
                      //         () => CircleAvatar(
                      //             backgroundColor: itemData.isFavorite.value
                      //                 ? Color(Helper.getHexToInt("#FFEEEE"))
                      //                 : Color(Helper.getHexToInt("#F9F9F9")),
                      //             child: Obx(
                      //               () => IconButton(
                      //                 icon: itemData.isFavorite.value
                      //                     ? Icon(Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#FF5A5A")),
                      //                         size: 15)
                      //                     : Icon(
                      //                         Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#C0C0C0")),
                      //                         size: 15,
                      //                       ),
                      //                 onPressed: () {
                      //                   var status =
                      //                       itemData.isFavorite.value ? 1 : 0;
                      //                   print(status);

                      //                   pcontroller.sendfavorit(itemData.shopId,
                      //                       itemData.isFavorite.value);
                      //                   itemData.isFavorite.toggle();
                      //                 },
                      //               ),
                      //             )),
                      //       )
                      // child: ClipOval(
                      //   child: GestureDetector(
                      //     // onTap: () {
                      //     //   _toggleVisibility();
                      //     //   // print("Container clicked");
                      //     // },
                      //     child: Container(
                      //         height: 25,
                      //         width: 25,
                      //         color: itemData.favorite
                      //             ? Color(Helper.getHexToInt("#FFEEEE"))
                      //             : Color(Helper.getHexToInt("#F9F9F9")),
                      //         // color: Color(Helper.getHexToInt("#FFEEEE")),
                      //         child: IconButton(
                      //           padding: EdgeInsets.all(0),
                      //           onPressed: () {
                      //             // loveicon = _loveVisibility(loveicon);
                      //             // print(loveicon);
                      //             // Navigate to second route when tapped.
                      //           },
                      //           icon: itemData.favorite
                      //               ? Icon(Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#FF5A5A")),
                      //                   size: 15)
                      //               : Icon(
                      //                   Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#C0C0C0")),
                      //                   size: 15,
                      //                 ),
                      //         )),
                      //   ),
                      // ),
                      //       ),
                      // ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50),
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
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 7),
                                child: RatingBar.builder(
                                  initialRating: double.parse(itemData!.rating!),
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 11,

                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 1.0,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(itemData!.rating);
                                  },
                                  // onRatingUpdate: (rating) {
                                  //   print(itemData.rating);
                                  // },
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
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => GetReviewPage([itemData!.shopId], itemData!.shopId, itemData!.totalReview)));
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

class CategoryListView2 extends StatelessWidget {
  const CategoryListView2({Key? key, this.itemData, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final Datums? itemData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.put(ProductController());
    final controller = Get.find<TestController>();
    itemData!.isFavorite.value = itemData!.favorite! ? itemData!.favorite! : false;
    return Container(
      height: 255,
      width: 200,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print(itemData!.shopId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAndReviewPage(itemData!.shopId, itemData!.vat, itemData!.deliveryCharge, itemData!.name, itemData!.address)));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MenuAndReviewPage()));
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      image: DecorationImage(
                        alignment: Alignment.center,
                        matchTextDirection: false,
                        image: NetworkImage(itemData!.logo!), //AssetImage(itemData.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                // height: MediaQuery.of(context).size.height / 20,
                // child: Padding(
                //     padding: const EdgeInsets.only(top: 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 8,
                          top: 10,
                          right: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(3.0)),
                          color: Colors.black54,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.2),
                          child: Text(
                            // itemData.catId.toString(),
                            itemData!.time!,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontFamily: 'Poppinsr', fontSize: 10, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            right: 5,
                          ),
                          child: CircleAvatar(
                              radius: 15,
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
                                    if (itemData!.isFavorite.value) {
                                      // controller.nearFavList.add(itemData);
                                    } else {
                                      controller.nearFavList.removeWhere((element) => element!.catId == itemData!.catId);
                                    }
                                    itemData!.favorite = !itemData!.favorite!;

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
                              ))),

                      // Expanded(
                      //     // child: Padding(
                      //     //     padding: const EdgeInsets.all(0.0),
                      //     child: Container(
                      //         margin: EdgeInsets.only(right: 40),
                      //         padding:
                      //             EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(10.0),
                      //               bottomRight: Radius.circular(10.0)),
                      //           color: Color(Helper.getHexToInt("#ECFBF8")),
                      //         ),
                      //         // child: Center(
                      //         child: Expanded(
                      //           flex: 3,
                      //           child: Text(
                      //             itemData.time,
                      //             textAlign: TextAlign.left,
                      //             style: TextStyle(
                      //                 fontFamily: 'Poppinsr',
                      //                 fontSize: 10,
                      //                 color:
                      //                     Color(Helper.getHexToInt("#11C4A1"))
                      //                         .withOpacity(1)),
                      //           ),
                      //         )
                      //         // ),
                      //         )),
                      // Center(
                      //   child: Container(
                      //       margin: EdgeInsets.only(right: 5, top: 1),
                      //       child: Obx(
                      //         () => CircleAvatar(
                      //             backgroundColor: itemData.isFavorite.value
                      //                 ? Color(Helper.getHexToInt("#FFEEEE"))
                      //                 : Color(Helper.getHexToInt("#F9F9F9")),
                      //             child: Obx(
                      //               () => IconButton(
                      //                 icon: itemData.isFavorite.value
                      //                     ? Icon(Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#FF5A5A")),
                      //                         size: 15)
                      //                     : Icon(
                      //                         Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#C0C0C0")),
                      //                         size: 15,
                      //                       ),
                      //                 onPressed: () {
                      //                   var status =
                      //                       itemData.isFavorite.value ? 1 : 0;
                      //                   print(status);

                      //                   pcontroller.sendfavorit(itemData.shopId,
                      //                       itemData.isFavorite.value);
                      //                   itemData.isFavorite.toggle();
                      //                 },
                      //               ),
                      //             )),
                      //       )
                      // child: ClipOval(
                      //   child: GestureDetector(
                      //     // onTap: () {
                      //     //   _toggleVisibility();
                      //     //   // print("Container clicked");
                      //     // },
                      //     child: Container(
                      //         height: 25,
                      //         width: 25,
                      //         color: itemData.favorite
                      //             ? Color(Helper.getHexToInt("#FFEEEE"))
                      //             : Color(Helper.getHexToInt("#F9F9F9")),
                      //         // color: Color(Helper.getHexToInt("#FFEEEE")),
                      //         child: IconButton(
                      //           padding: EdgeInsets.all(0),
                      //           onPressed: () {
                      //             // loveicon = _loveVisibility(loveicon);
                      //             // print(loveicon);
                      //             // Navigate to second route when tapped.
                      //           },
                      //           icon: itemData.favorite
                      //               ? Icon(Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#FF5A5A")),
                      //                   size: 15)
                      //               : Icon(
                      //                   Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#C0C0C0")),
                      //                   size: 15,
                      //                 ),
                      //         )),
                      //   ),
                      // ),
                      //       ),
                      // ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50),
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
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 7),
                                child: RatingBar.builder(
                                  initialRating: itemData!.rating!,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 11,

                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 1.0,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(itemData!.rating);
                                  },
                                  // onRatingUpdate: (rating) {
                                  //   print(itemData.rating);
                                  // },
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

class CategoryListView3 extends StatelessWidget {
  const CategoryListView3({Key? key, this.itemData, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final Datum? itemData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.put(ProductController());
    final controller = Get.find<TestController>();
    itemData!.isFavorite.value = itemData!.favorite! ? itemData!.favorite! : false;
    return Container(
      height: 255,
      width: 200,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print(itemData!.shopId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAndReviewPage(itemData!.shopId, itemData!.vat, itemData!.deliveryCharge, itemData!.name, itemData!.address)));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MenuAndReviewPage()));
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      image: DecorationImage(
                        alignment: Alignment.center,
                        matchTextDirection: false,
                        image: NetworkImage(itemData!.logo!), //AssetImage(itemData.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                // height: MediaQuery.of(context).size.height / 20,
                // child: Padding(
                //     padding: const EdgeInsets.only(top: 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 8,
                          top: 10,
                          right: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(3.0)),
                          color: Colors.black54,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.2),
                          child: Text(
                            // itemData.catId.toString(),
                            itemData!.time!,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontFamily: 'Poppinsr', fontSize: 10, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            right: 5,
                          ),
                          child: CircleAvatar(
                              radius: 15,
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
                                    if (itemData!.isFavorite.value) {
                                      controller.nearFavList.add(itemData);
                                    } else {
                                      controller.nearFavList.removeWhere((element) => element!.catId == itemData!.catId);
                                    }
                                    itemData!.favorite = !itemData!.favorite!;

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
                              ))),

                      // Expanded(
                      //     // child: Padding(
                      //     //     padding: const EdgeInsets.all(0.0),
                      //     child: Container(
                      //         margin: EdgeInsets.only(right: 40),
                      //         padding:
                      //             EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(10.0),
                      //               bottomRight: Radius.circular(10.0)),
                      //           color: Color(Helper.getHexToInt("#ECFBF8")),
                      //         ),
                      //         // child: Center(
                      //         child: Expanded(
                      //           flex: 3,
                      //           child: Text(
                      //             itemData.time,
                      //             textAlign: TextAlign.left,
                      //             style: TextStyle(
                      //                 fontFamily: 'Poppinsr',
                      //                 fontSize: 10,
                      //                 color:
                      //                     Color(Helper.getHexToInt("#11C4A1"))
                      //                         .withOpacity(1)),
                      //           ),
                      //         )
                      //         // ),
                      //         )),
                      // Center(
                      //   child: Container(
                      //       margin: EdgeInsets.only(right: 5, top: 1),
                      //       child: Obx(
                      //         () => CircleAvatar(
                      //             backgroundColor: itemData.isFavorite.value
                      //                 ? Color(Helper.getHexToInt("#FFEEEE"))
                      //                 : Color(Helper.getHexToInt("#F9F9F9")),
                      //             child: Obx(
                      //               () => IconButton(
                      //                 icon: itemData.isFavorite.value
                      //                     ? Icon(Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#FF5A5A")),
                      //                         size: 15)
                      //                     : Icon(
                      //                         Icons.favorite,
                      //                         color: Color(Helper.getHexToInt(
                      //                             "#C0C0C0")),
                      //                         size: 15,
                      //                       ),
                      //                 onPressed: () {
                      //                   var status =
                      //                       itemData.isFavorite.value ? 1 : 0;
                      //                   print(status);

                      //                   pcontroller.sendfavorit(itemData.shopId,
                      //                       itemData.isFavorite.value);
                      //                   itemData.isFavorite.toggle();
                      //                 },
                      //               ),
                      //             )),
                      //       )
                      // child: ClipOval(
                      //   child: GestureDetector(
                      //     // onTap: () {
                      //     //   _toggleVisibility();
                      //     //   // print("Container clicked");
                      //     // },
                      //     child: Container(
                      //         height: 25,
                      //         width: 25,
                      //         color: itemData.favorite
                      //             ? Color(Helper.getHexToInt("#FFEEEE"))
                      //             : Color(Helper.getHexToInt("#F9F9F9")),
                      //         // color: Color(Helper.getHexToInt("#FFEEEE")),
                      //         child: IconButton(
                      //           padding: EdgeInsets.all(0),
                      //           onPressed: () {
                      //             // loveicon = _loveVisibility(loveicon);
                      //             // print(loveicon);
                      //             // Navigate to second route when tapped.
                      //           },
                      //           icon: itemData.favorite
                      //               ? Icon(Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#FF5A5A")),
                      //                   size: 15)
                      //               : Icon(
                      //                   Icons.favorite,
                      //                   color: Color(
                      //                       Helper.getHexToInt("#C0C0C0")),
                      //                   size: 15,
                      //                 ),
                      //         )),
                      //   ),
                      // ),
                      //       ),
                      // ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50),
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
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 7),
                                child: RatingBar.builder(
                                  initialRating: itemData!.rating!,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 11,

                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 1.0,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(itemData!.rating);
                                  },
                                  // onRatingUpdate: (rating) {
                                  //   print(itemData.rating);
                                  // },
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
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => GetReviewPage([itemData!.shopId], itemData!.shopId, itemData!.totalReview)));
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
