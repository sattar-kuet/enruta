import 'dart:ui';

import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/screen/menuandreviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFavoriteView extends StatefulWidget {
  MyFavoriteView(
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
  _MyFavoriteViewState createState() => _MyFavoriteViewState();
}

class _MyFavoriteViewState extends State<MyFavoriteView> {
  @override
  Widget build(BuildContext context) {
    widget.itemData.isFavorite.value =
        widget.itemData.favorite ? widget.itemData.favorite : false;
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
          print(widget.itemData.shopId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAndReviewPage(
                      widget.itemData.shopId,
                      widget.itemData.vat,
                      widget.itemData.deliveryCharge,
                      widget.itemData.name,
                      widget.itemData.address)));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MenuAndReviewPage()));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  alignment: Alignment.center,
                  matchTextDirection: false,
                  image: NetworkImage(widget.itemData.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.itemData.name,
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Color(Helper.getHexToInt("#434343"))),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          color: Colors.white.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: RatingBar.builder(
                                    initialRating: widget.itemData.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 10,
                                    ignoreGestures: true,
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

                                child: Text(
                              // '8888522 Reviews',
                              ' ${widget.itemData.totalReview} Reviews',
                              style: TextStyle(
                                  fontFamily: 'TTCommonsd',
                                  fontSize: 15,
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
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.only(top: 8.0, right: 5, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(3.0)),
                      color: Colors.black38,
                    ),
                    child: Text(
                      // itemData.catId.toString(),
                      widget.itemData.time,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: 'Poppinsr',
                          fontSize: 12,
                          color: Color(Helper.getHexToInt("#11C4A1"))
                              .withOpacity(1)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          // color: itemData.isFavorite.value
                          //     ? Color(Helper.getHexToInt("#FFEEEE"))
                          //     : Color(Helper.getHexToInt("#F9F9F9")),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Obx(
                            () => InkWell(
                              child: widget.itemData.isFavorite.value
                                  ? Icon(Icons.favorite,
                                      color:
                                          Color(Helper.getHexToInt("#FF5A5A")),
                                      size: 15)
                                  : Icon(
                                      Icons.favorite,
                                      color:
                                          Color(Helper.getHexToInt("#C0C0C0")),
                                      size: 15,
                                    ),
                              onTap: () async {
                                if (widget.callback != null) widget.callback();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
