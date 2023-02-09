import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/Product_model.dart';
import 'package:enruta/screen/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewListView extends StatelessWidget {
  const ReviewListView(
      {Key? key,
      this.menuitemdata,
      this.animationController,
      this.animation,
      this.callback,
      this.shopid,
      this.vat,
      this.deliveryCharge})
      : super(key: key);

  final VoidCallback? callback;
  final Product? menuitemdata;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;
  final String? shopid;
  final double? vat;
  final double? deliveryCharge;

  @override
  Widget build(BuildContext context) {
    // final MenuController cartController = Get.put(MenuController());
    final CartController cartController = Get.put(CartController());
    print(cartController.cartItems.length);

    return Container(
      //height:Get.height*.25 ,
     // width: Get.width * .3,
      margin: EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print(" Size :${menuitemdata!.sizes}");
          if (menuitemdata!.sizes!.length > 0 ||
              menuitemdata!.colors!.length > 0) {
            print(shopid);
            Get.to(ProductDetails(
              menuitemdata: menuitemdata,
              shopid: shopid,
              vat: vat,
              deliveryCharge: deliveryCharge,
            ));
          }

          // Get.to(HomePage());
          // _launchInWebViewOrVC("https://corona.gov.bd/");
        },
        child: Row(
          children: [
            InkWell(
              onTap: () {
                //print("Size length ${menuitemdata.sizes.length}");
                if (menuitemdata!.sizes!.length > 0 ||
                    menuitemdata!.colors!.length > 0) {
                  Get.to(ProductDetails(
                    menuitemdata: menuitemdata,
                    shopid: shopid,
                    vat: vat,
                    deliveryCharge: deliveryCharge,
                  ));
                }
                // Get.to(ProductDetails());
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Stack(
                  children: [
                    Container(
                      height: 92,
                      width: 92,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: menuitemdata!.logo!.isEmpty
                            ? Center(
                                child: Image.asset(
                                  "assets/icons/image.png",
                                  scale: 5,
                                ),
                              )
                            : Image.network(
                                menuitemdata!.logo![0]!,
                                fit: BoxFit.fill,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Center(
                                      child: Image.asset(
                                    "assets/icons/image.png",
                                    scale: 5,
                                  ));
                                },
                                loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : Center(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                },
                              ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      height: 24,
                      decoration: BoxDecoration(
                          color: Color(Helper.getHexToInt("#FFF7E4")),
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        "\$" + menuitemdata!.price.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(Helper.getHexToInt("#FFBB19")),
                          fontFamily: 'TTCommonsd',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Text(
                    menuitemdata!.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(Helper.getHexToInt("#000000"))),
                  ),
                  Container(
                    child: Text(
                      menuitemdata!.subTxt!,
                      // textAlign: TextAlign.,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: Color(Helper.getHexToInt("#6E6E6E"))
                            .withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (menuitemdata!.pqty > 1) {
                                menuitemdata!.pqty.value--;
                                print("remove");
                                cartController.isInChart(shopid!, menuitemdata!);
                              }
                              // Get.find<MenuController>().decrement(menuitemdata.id);
                              // cartController.decrement();
                            },
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                size: 20,
                                color: Color(Helper.getHexToInt("#6E6E6E")),
                              ),
                            ),
                          ),
                        ),
                        // menuitemdata.qty = cartController.qty;
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color(Helper.getHexToInt("#3AD8B4")),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Obx(() {
                              menuitemdata!.qty = cartController.qty.value;

                              return Text(
                                // cartController.qty.value.toString(),
                                menuitemdata!.pqty.toString(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              );
                            })),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: InkWell(
                            onTap: () {
                              // Get.find<MenuController>().increment(menuitemdata.id);
                              menuitemdata!.pqty.value++;
                              // cartController.increment(menuitemdata.id);
                              print("add");
                              cartController.isInChart(shopid!, menuitemdata!);
                            },
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 20,
                              color: Color(Helper.getHexToInt("#6E6E6E")),
                            )),
                          ),
                        )),
                        Expanded(child: Container()),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                if (menuitemdata!.sizes!.length > 0 ||
                                    menuitemdata!.colors!.length > 0) {
                                  Get.to(ProductDetails(
                                    menuitemdata: menuitemdata,
                                    shopid: shopid,
                                    vat: vat,
                                    deliveryCharge: deliveryCharge,
                                  ));
                                } else {
                                  menuitemdata!.qty = menuitemdata!.pqty.toInt();
                                  cartController.additemtocarts(menuitemdata,
                                      shopid, vat, deliveryCharge);

                                  // GetStorage box = GetStorage();
                                  // box.write("cartList", Get.find<CartController>().cartList);
                                  // box.write("shopid", shopid);
                                  // box.write("vat", vat);
                                  // box.write("deliveryCharge", deliveryCharge);
                                  // print(vat);
                                  // box.write("shopid", shopid);
                                  // print("object");
                                  cartController.isInChart(
                                      shopid!, menuitemdata!);
                                }
                              },
                              child: Container(
                                height: 25,
                                width: 28,
                                decoration: BoxDecoration(
                                    color: Color(Helper.getHexToInt("#3AD8B4")),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.shopping_basket,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}
