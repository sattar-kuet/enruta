import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingListView extends StatelessWidget {
  const RatingListView(
      {Key? key,
      this.ratingData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Review? ratingData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // _launchInWebViewOrVC("https://corona.gov.bd/");
        },
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 5,
              bottom: 5,
              child: Container(
                height: 75,
                width: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ratingData!.logo == null
                      ? Center(
                          child: Image.asset(
                            "assets/icons/image.png",
                            scale: 5,
                          ),
                          // Text("No image",
                          //   style: TextStyle(color: Colors.grey),
                          // ),
                        )
                      : Image.network(ratingData!.logo!, fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                          return Center(child: Text('😢'));
                        }),
                ),
              ),
              // child: Container(
              //   height: 75,
              //   width: 75,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     // image: DecorationImage(
              //     //     image: NetworkImage(ratingData.logo), fit: BoxFit.fill),
              //   ),
              //   child: Image.network(ratingData.logo, fit: BoxFit.fill),
              // ),
            ),
            Positioned(
              ///////
              top: 10,
              left: 91,
              child: Container(
                child: Text(
                  ratingData!.title == null ? "No Name" : ratingData!.title!,
                  style: TextStyle(
                      fontFamily: 'TTCommonsm',
                      fontSize: 15,
                      color: Color(Helper.getHexToInt("#000000"))
                          .withOpacity(0.8)),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Container(
                  // padding: EdgeInsets.only(right: 10),
                  child: Text(
                ' ${ratingData!.date}',
                style: TextStyle(
                  fontFamily: 'Poppinsr',
                  fontSize: 10,
                ),
                textAlign: TextAlign.end,
              )),
            ),
            Positioned(
              top: 30,
              left: 91,
              right: 5,
              child: Container(
                child: RatingBar.builder(
                  initialRating: ratingData!.rating!,
ignoreGestures: true,
                  // minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 12,
                  // itemPadding:
                  //     EdgeInsets.symmetric(horizontal: .5),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 1.0,
                    color: Colors.amber,
                  ),

                  onRatingUpdate: (rating) {
                    print(ratingData!.rating);
                  },
                ),
                // ),
              ),
            ),
            Positioned(
                top: 48,
                left: 91,
                right: 15,
                child: Container(
                  child: Container(
                    child: Text(
                      ratingData!.subtitle!,
                      textAlign: TextAlign.justify,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'TTCommonsm',
                        color: Color(Helper.getHexToInt("#6E6E6E"))
                            .withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );

    // Container(
    //   child: Container(
    //     margin: EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(9),
    //     ),
    //     child: InkWell(
    //       onTap: () {
    //         // _launchInWebViewOrVC("https://corona.gov.bd/");
    //       },
    //       child: Container(
    //         margin: EdgeInsets.all(5),
    //         child: Row(
    //           children: [
    //             Stack(
    //               children: [
    //                 Container(
    //                   padding: EdgeInsets.all(5),
    //                   height: 75,
    //                   width: 75,
    //                   decoration: BoxDecoration(
    //                     image: DecorationImage(
    //                         image: AssetImage(ratingData.imagePath),
    //                         fit: BoxFit.cover),
    //                   ),
    //                 ),

    //               ],
    //             ),
    //             SizedBox(
    //               width: 10,
    //             ),
    //             Flexible(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Expanded(
    //                         child: Text(
    //                           ratingData.titleTxt,
    //                           style: TextStyle(
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Expanded(
    //                         child: Container(
    //                             padding: EdgeInsets.only(right: 10),
    //                             child: Text(
    //                               ' ${ratingData.date}',
    //                               style: TextStyle(fontSize: 10),
    //                               textAlign: TextAlign.end,
    //                             )),
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                     // child: Center(
    //                     child: RatingBar(
    //                       initialRating: ratingData.rating,

    //                       // minRating: 1,
    //                       direction: Axis.horizontal,
    //                       allowHalfRating: true,
    //                       itemCount: 5,
    //                       itemSize: 12,
    //                       // itemPadding:
    //                       //     EdgeInsets.symmetric(horizontal: .5),
    //                       itemBuilder: (context, _) => Icon(
    //                         Icons.star,
    //                         size: 1.0,
    //                         color: Colors.amber,
    //                       ),

    //                       onRatingUpdate: (rating) {
    //                         print(ratingData.rating);
    //                       },
    //                     ),
    //                     // ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Text(
    //                     ratingData.subTxt,
    //                     textAlign: TextAlign.justify,
    //                     maxLines: 2,
    //                     style: TextStyle(
    //                       color: Color(Helper.getHexToInt("#6E6E6E")),
    //                       fontSize: 10,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(
    //               height: 10,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
