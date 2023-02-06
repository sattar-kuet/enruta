import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/menuController.dart' as mc;
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homePage.dart';

class GetReviewPage extends StatefulWidget {
  final List<int> shopid;
  final int orderId;
  final int review;

  GetReviewPage(this.shopid, this.orderId, this.review);

  @override
  _GetReviewPageState createState() => _GetReviewPageState();
}

class _GetReviewPageState extends State<GetReviewPage> {
  final tController = Get.put(TestController());
  final menuCtn = Get.put(mc.MenuController());
  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  @override
  void initState() {
    super.initState();
    menuCtn.getreview(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewcont = new TextEditingController(text: "");

    double r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0;
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
      // color: cardbackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: CircleAvatar(
                  backgroundColor: Color(Helper.getHexToInt("#F2F2F2")),
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: theamColor,
                      size: 20,
                    ),
                    onPressed: () async {
                      SharedPreferences spreferences = await SharedPreferences.getInstance();
                      spreferences.setInt("OrderCompletedShop", null);
                      Navigator.of(context).pop();
                    },
                  )),

              // Align(
              //     alignment: Alignment.centerRight,
              //     child: Icon(Icons.close))
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: Text(
                text('thanks_for_your_rating'),
                style: TextStyle(fontSize: 25, fontFamily: 'TTCommonsd', color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ),
          // Flexible(
          //   child: Column(
          //     children: [
          //       Container(
          //         height: 20,
          //         child: Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text(
          //             text('food'),
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontFamily: 'TTCommonsd',
          //               color: Color(Helper.getHexToInt("#3B3A3A"))
          //                   .withOpacity(.8),
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Align(
          //         alignment: Alignment.centerLeft,
          //         child: Container(
          //           child: RatingBar.builder(
          //             initialRating: 0,

          //             // minRating: 1,
          //             direction: Axis.horizontal,
          //             allowHalfRating: true,
          //             itemCount: 5,
          //             itemSize: 25,

          //             itemBuilder: (context, _) => Icon(
          //               Icons.star,
          //               size: 1.0,
          //               color: Colors.amber,
          //             ),

          //             onRatingUpdate: (rating) {
          //               r1 = rating;
          //               print(rating);
          //             },
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Flexible(
            child: SizedBox(
              height: 20,
            ),
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 20,
                    child: Text(
                      text('food'),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#3B3A3A")).withOpacity(.8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RatingBar.builder(
                    initialRating: r2,

                    // minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,

                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 1.0,
                      color: Colors.amber,
                    ),

                    onRatingUpdate: (rating) {
                      r2 = rating;
                      print("rating" + rating.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Flexible(
            child: Container(
              height: 30,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                text('how_was_everything_else'),
                style: TextStyle(fontSize: 25, fontFamily: 'TTCommonsd', color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 20,
                    child: Text(
                      text('packaging'),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#3B3A3A")).withOpacity(.8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RatingBar.builder(
                    initialRating: r3,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 1.0,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      r3 = rating ?? 1.0;
                      print(rating);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 20,
                    child: Text(
                      text('rider'),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#3B3A3A")).withOpacity(.8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RatingBar.builder(
                    initialRating: r4,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 1.0,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      r4 = rating ?? 1.0;
                      print(rating);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text('timeliness'),
                    style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#3B3A3A")).withOpacity(.8)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RatingBar.builder(
                    initialRating: r5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 1.0,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      r5 = rating;
                      print(rating);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                      text('everything_else_to_add'),
                      style: TextStyle(fontSize: 20, fontFamily: 'TTCommonsd', color: Colors.black.withOpacity(0.8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.only(right: 5),
                  child: TextField(
                    controller: reviewcont,
                    minLines: 5,
                    maxLines: 7,
                    onChanged: (v) {
                      return;
                    },
                    decoration: InputDecoration(
                      hintText: text('help_others_to_find_good_food'),
                      hintStyle: TextStyle(fontSize: 12),
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Color(Helper.getHexToInt("#11C7A1")),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      double rating = ((r1 + r2 + r3 + r4 + r5) / 5);
                      print(rating.toString());
                      await tController.addrivew(widget.shopid, rating, reviewcont.text, widget.orderId);
                      SharedPreferences spreferences = await SharedPreferences.getInstance();
                      spreferences.setInt("OrderCompletedShop", null);
                      Navigator.of(context).pop();
                      setState(() {});
                    } catch (e) {
                      Get.snackbar("Review", e.toString());
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11C7A1")), Color(Helper.getHexToInt("#11E4A1"))]),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                        child: Text(
                      text('done'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
