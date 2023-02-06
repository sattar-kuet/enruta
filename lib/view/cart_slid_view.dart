import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/suggestController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/Product_model.dart';
import 'package:enruta/screen/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartSlidView extends StatelessWidget {
  const CartSlidView(
      {Key key,
      this.cartData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  // final CartListData cartData;
  final Product cartData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    final cartCont = Get.put(CartController());
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width / 1.3,

      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // image: DecorationImage(
                  //     image: AssetImage(cartData.logo), fit: BoxFit.cover),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: cartData.logo.isEmpty
                      ? Center(
                          child: Image.asset(
                            "assets/icons/image.png",
                            scale: 5,
                          ),
                        )
                      : Image.network(
                          cartData.logo[0],
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Center(
                                child: Image.asset(
                              "assets/icons/image.png",
                              scale: 5,
                            ));
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 100,
              child: Container(
                child: Text(
                  cartData.title,
                  style: TextStyle(
                      fontFamily: "TTCommonsd",
                      fontSize: 16,
                      color: Color(Helper.getHexToInt("#000000"))),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 100,
              right: 10,
              child: Container(
                child: Text(
                  cartData.subTxt,
                  textAlign: TextAlign.justify,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'TTCommonsm',
                    color: Color(Helper.getHexToInt("#6E6E6E")),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 100,
              height: 25,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 27,
                decoration: BoxDecoration(
                    color: Color(Helper.getHexToInt("#FFF7E4")),
                    borderRadius: BorderRadius.circular(3)),
                child: Text(
                  "\$" + cartData.price.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(Helper.getHexToInt("#FFBB19")),
                    fontFamily: 'TTCommonsd',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              height: 25,
              width: 25,
              child: InkWell(
                onTap: () {
                  cartData.qty = 1;
                  if (cartData.sizes.length != 0 ||
                      cartData.colors.length != 0) {
                    Get.to(ProductDetails(
                      menuitemdata: cartData,
                      shopid: cartCont.shopid.value,
                      vat: cartCont.vat.value,
                      deliveryCharge: cartCont.deliveryCharge.value,
                    ));
                  } else {
                    cartData.qty = cartData.pqty.toInt();
                    cartCont.additemtocarts(cartData, cartCont.shopid.value,
                        cartCont.vat.value, cartCont.deliveryCharge.value);

                    // GetStorage box = GetStorage();
                    // box.write("cartList", Get.find<CartController>().cartList);
                    // box.write("shopid", shopid);
                    // box.write("vat", vat);
                    // box.write("deliveryCharge", deliveryCharge);
                    // print(vat);
                    // box.write("shopid", shopid);
                    // print("object");
                    cartCont.isInChart(cartCont.shopid.value, cartData);

                    cartCont.suggetItems
                        .removeWhere((item) => item.id == cartData.id);
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Color(Helper.getHexToInt("#3AD8B4")),
                        borderRadius: BorderRadius.circular(3)),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
