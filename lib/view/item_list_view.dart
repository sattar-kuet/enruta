import 'package:enruta/controllers/productController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/model/near_by_place_data.dart';
// ignore: unused_import
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/menuandreviewpage.dart';
// ignore: unused_import
import 'package:enruta/screen/myFavorite/myFavorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../helper/helper.dart';

class ItemListView extends StatefulWidget {
  const ItemListView(
      {Key key,
      this.itemData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Datum itemData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final tController = Get.put(TestController());
    // ignore: unused_local_variable
    final pcontroller = Get.put(ProductController());
    // ignore: unused_local_variable
    final controller = Get.find<TestController>();
    return Container(
      height: 255,
      width: 180,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Get.to(MenuAndReviewPage(widget.itemData.shopId, widget.itemData.vat,
              widget.itemData.deliveryCharge, widget.itemData.name));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MenuAndReviewPage()));
        },
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 30,
                child: Container(
                  // height: MediaQuery.of(context).size.height / 8,
                  // width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.center,
                      matchTextDirection: false,
                      image: NetworkImage(widget.itemData.logo),
                      fit: BoxFit.contain,
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                )),
            Positioned(
              child: Container(
                  height: 30,
                  // child: Padding(
                  //     padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          // child: Padding(
                          //     padding: const EdgeInsets.all(0.0),
                          child: Container(
                              margin: EdgeInsets.only(right: 50),
                              padding:
                                  EdgeInsets.only(left: 8, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // topRight: Radius.circular(10.0),
                                    // bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                color: Color(Helper.getHexToInt("#ECFBF8")),
                              ),
                              // child: Center(
                              child: Text(
                                widget.itemData.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppinsr',
                                    fontSize: 10,
                                    color: Color(Helper.getHexToInt("#11C4A1"))
                                        .withOpacity(1)),
                              )
                              // ),
                              )),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(right: 5, top: 5),
                          child: ClipOval(
                            child: GestureDetector(
                              child: Container(
                                  height: 25,
                                  width: 25,
                                  color: widget.itemData.favorite
                                      ? Color(Helper.getHexToInt("#FFEEEE"))
                                      : Color(Helper.getHexToInt("#F9F9F9")),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {},
                                    icon: widget.itemData.favorite
                                        ? Icon(Icons.favorite,
                                            color: Color(
                                                Helper.getHexToInt("#FF5A5A")),
                                            size: 15)
                                        : Icon(
                                            Icons.favorite,
                                            color: Color(
                                                Helper.getHexToInt("#C0C0C0")),
                                            size: 15,
                                          ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
              bottom: 45,
              left: 10,
              right: 10,
              child: Center(
                child: Container(
                  height: 20,

                  // width: 100,
                  // padding: EdgeInsets.only(left: 20),
                  // margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Color(Helper.getHexToInt("#F8F9FF")),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 7),
                            child: RatingBar.builder(
                              initialRating: widget.itemData.rating,
ignoreGestures: true,
                              // minRating: 1,
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
                                print(widget.itemData.rating);
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
                          child: Text(
                            // '8888522 Reviews',
                            ' ${widget.itemData.rating} Reviews',
                            style: TextStyle(
                                fontFamily: 'TTCommonsd',
                                fontSize: 11,
                                color: Color(Helper.getHexToInt("#000000"))
                                    .withOpacity(0.4)),
                            textAlign: TextAlign.end,
                          )),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(bottom: 28, left: 10, right: 10, child: Divider()),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                widget.itemData.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'TTCommonsr',
                    fontSize: 17,
                    color: Color(Helper.getHexToInt("#434343")).withOpacity(1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
