import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/my_order_list_data.dart';
import 'package:enruta/screen/orerder/curentOrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurentOrderView extends StatefulWidget {
  const CurentOrderView({Key? key, this.orderData, this.orderModel, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final MyorderListData? orderData;
  final OrderModel? orderModel;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  _CurentOrderViewState createState() => _CurentOrderViewState();
}

class _CurentOrderViewState extends State<CurentOrderView> {
  String text(String key) {
    final language = Get.put(LanguageController());
    return language.text(key);
  }

  late CurrentOrderController detailsController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailsController = Get.put(CurrentOrderController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() =>
          // this.orderModel !=null? Text("YOU HAVE NOT ANY CURRENT ORDER "):
          // ignore: invalid_use_of_protected_member
          detailsController.allCurrentOrderList.value.length == 0
              ? Center(child: Text(text('YOU_HAVE_NOT_ANY_CURRENT_ORDER')))
              : GestureDetector(
                  onTap: () async {
                    print("*********${widget.orderModel!.id}");

                    await detailsController.getorderStatusforindivisual(widget.orderModel!.id);
                  },
                  child: Row(
                    children: [
                      widget.orderModel!.imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              // backgroundColor: theamColor,
                              child: Image.network(
                                widget.orderModel!.imagePath!,
                                fit: BoxFit.cover,
                                width: 60,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.error_outline);
                                },
                                loadingBuilder: (context, child, progress) {
                                  return progress == null ? child : Center(child: CircularProgressIndicator());
                                },
                              ),
                            )
                          : Image.asset('assets/icons/persono.png'),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.orderModel!.titleTxt!,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#000000"))),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.orderModel!.shopName!,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'TTCommonsm',
                                color: Color(Helper.getHexToInt("#6E6E6E")).withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.orderModel!.date!,
                              textAlign: TextAlign.justify,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'TTCommonsr',
                                color: Color(Helper.getHexToInt("#B6B6B6")).withOpacity(1),
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 7),
                        height: 24,
                        decoration: BoxDecoration(
                            color: Color(Helper.getHexToInt("#FFF7E4")),
                            // color: Colors.green,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          widget.orderModel!.price!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(Helper.getHexToInt("#FFBB19")),
                            fontFamily: 'TTCommonsd',
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
    // return Container(
    //     height: 80,
    //     margin: EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Obx(
    //       () =>
    //           // this.orderModel !=null? Text("YOU HAVE NOT ANY CURRENT ORDER "):
    //           // ignore: invalid_use_of_protected_member
    //           detailsController.allCurentOrderList.value.length == 0
    //               ? Center(child: Text(text('YOU_HAVE_NOT_ANY_CURRENT_ORDER')))
    //               : InkWell(
    //                   onTap: () async {
    //                     OrderDetailsPageModel orderDetailsModel;
    //                     print(widget.orderModel.id);
    //                     // detailsController.isLoading(true);

    //                     await detailsController
    //                         .getorderStatusforindivisual(widget.orderModel.id);
    //                     // detailsController.isLoading(false);
    //                     //Get.to(OrderStatus(a));

    //                     // _launchInWebViewOrVC("https://corona.gov.bd/");
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Positioned(
    //                         top: 5,
    //                         left: 5,
    //                         bottom: 10,
    //                         child: Container(
    //                             height: 92,
    //                             width: 80,
    //                             // decoration: BoxDecoration(
    //                             //   borderRadius: BorderRadius.circular(8),
    //                             //   image: DecorationImage(
    //                             //       image:
    //                             //       AssetImage(orderData.imagePath),
    //                             //       fit: BoxFit.cover),
    //                             // ),
    //                             child: widget.orderModel.imagePath != null
    //                                 ? ClipRRect(
    //                                     borderRadius:
    //                                         BorderRadius.circular(10.0),
    //                                     // backgroundColor: theamColor,
    //                                     child: Image.network(
    //                                       widget.orderModel.imagePath,
    //                                       fit: BoxFit.fill,
    //                                       errorBuilder: (BuildContext context,
    //                                           Object exception,
    //                                           StackTrace stackTrace) {
    //                                         return Icon(Icons.error_outline);
    //                                       },
    //                                       loadingBuilder:
    //                                           (context, child, progress) {
    //                                         return progress == null
    //                                             ? child
    //                                             : Center(
    //                                                 child: Center(
    //                                                     child:
    //                                                         CircularProgressIndicator()));
    //                                       },
    //                                     ),
    //                                   )
    //                                 : Image.asset('assets/icons/persono.png')),
    //                       ),

    //                       Positioned(
    //                         top: 10,
    //                         right: 10,
    //                         child: Container(
    //                           alignment: Alignment.center,
    //                           // padding: EdgeInsets.only(top: 10, left: 10),
    //                           padding: EdgeInsets.symmetric(horizontal: 5),
    //                           height: 24,
    //                           decoration: BoxDecoration(
    //                               color: Color(Helper.getHexToInt("#FFF7E4")),
    //                               // color: Colors.green,
    //                               borderRadius: BorderRadius.circular(3)),
    //                           child: Text(
    //                             widget.orderModel.price,
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                               color: Color(Helper.getHexToInt("#FFBB19")),
    //                               fontFamily: 'TTCommonsd',
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Positioned(
    //                         top: 20,
    //                         left: 113,
    //                         width: 180,
    //                         child: Container(
    //                           child: Text(
    //                             widget.orderModel.titleTxt,
    //                             maxLines: 2,
    //                             overflow: TextOverflow.fade,
    //                             style: TextStyle(
    //                                 fontFamily: "TTCommonsd",
    //                                 fontSize: 16,
    //                                 color:
    //                                     Color(Helper.getHexToInt("#000000"))),
    //                           ),
    //                         ),
    //                       ),
    //                       Padding(padding: EdgeInsets.all(10)),
    //                       Positioned(
    //                         top: 40,
    //                         left: 113,
    //                         right: 90,
    //                         child: Container(
    //                           child: Text(
    //                             widget.orderModel.shopName,
    //                             overflow: TextOverflow.fade,
    //                             textAlign: TextAlign.left,
    //                             maxLines: 2,
    //                             style: TextStyle(
    //                               fontFamily: 'TTCommonsm',
    //                               color: Color(Helper.getHexToInt("#6E6E6E"))
    //                                   .withOpacity(0.5),
    //                               fontSize: 13,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Positioned(
    //                         top: 60,
    //                         left: 113,
    //                         right: 120,
    //                         bottom: 10,
    //                         child: Text(
    //                           widget.orderModel.date,
    //                           textAlign: TextAlign.justify,
    //                           maxLines: 2,
    //                           style: TextStyle(
    //                             fontFamily: 'TTCommonsr',
    //                             color: Color(Helper.getHexToInt("#B6B6B6"))
    //                                 .withOpacity(1),
    //                             fontSize: 12,
    //                           ),
    //                         ),
    //                       ),
    //                       // Positioned(
    //                       //     top: 67,
    //                       //     left: 185,
    //                       //     child: Container(
    //                       //       width: 11,

    //                       //       height: double.maxFinite,
    //                       //       color: Colors.black,
    //                       //     )),
    //                       // Positioned(
    //                       //   top: 67,
    //                       //   left: 196,
    //                       //   child: Text(
    //                       //     orderData.time,
    //                       //     textAlign: TextAlign.justify,
    //                       //     maxLines: 2,
    //                       //     style: TextStyle(
    //                       //       fontFamily: 'TTCommonsm',
    //                       //       color: Color(Helper.getHexToInt("#6E6E6E")).withOpacity(0.5),
    //                       //       fontSize: 10,
    //                       //     ),
    //                       //   ),
    //                       // ),
    //                       // Positioned(
    //                       //   bottom: 10,
    //                       //   right: 10,
    //                       //   child: Container(
    //                       //     child: Container(
    //                       //       height: 25,
    //                       //       width: 55,
    //                       //       decoration: BoxDecoration(
    //                       //           color: Color(Helper.getHexToInt("#3AD8B4")),
    //                       //           borderRadius: BorderRadius.circular(5)),
    //                       //       child: Center(
    //                       //         child: Text(
    //                       //           "Reorder",
    //                       //           style: TextStyle(
    //                       //               color: Colors.white,
    //                       //               fontFamily: 'TTCommonsm',
    //                       //               fontSize: 12),
    //                       //         ),
    //                       //       ),
    //                       //     ),
    //                       //   ),
    //                       // )
    //                     ],
    //                   ),
    //                 ),
    //     )

    //     // ),
    //     );
  }
}
