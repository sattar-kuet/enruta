import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/suggestController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/Product_model.dart' as pro;
import 'package:enruta/screen/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MyOrderListView extends StatelessWidget {
  const MyOrderListView({Key? key, this.orderData, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final OrderModel? orderData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () async {
            // print(widget.orderModel.id);
            // // detailsController.isLoading(true);

            // await detailsController
            //     .getorderStatusforindivisual(widget.orderModel.id);
            // detailsController.isLoading(false);
            //Get.to(OrderStatus(a));

            // _launchInWebViewOrVC("https://corona.gov.bd/");
          },
          leading: orderData!.imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // backgroundColor: theamColor,
                  child: Image.network(
                    orderData!.imagePath!,
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
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              orderData!.titleTxt!,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#000000"))),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderData!.subTxt!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'TTCommonsm',
                    color: Color(Helper.getHexToInt("#6E6E6E")).withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  orderData!.date!,
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
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // padding: EdgeInsets.only(top: 10, left: 10),
                // margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 7,
                ),
                height: 24,
                decoration: BoxDecoration(
                    color: Color(Helper.getHexToInt("#FFF7E4")),
                    // color: Colors.green,
                    borderRadius: BorderRadius.circular(3)),
                child: Text(
                  orderData!.price!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(Helper.getHexToInt("#FFBB19")),
                    fontFamily: 'TTCommonsd',
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    CartController cartController = Get.put(CartController());
                    final productsList = orderData?.products;
                    if (productsList == null || productsList.isEmpty) throw ('Products are empty');

                    for (final element in productsList) {
                      for (final product in element) {
                        pro.Product p = pro.Product(
                            colors: element.first.colors ?? [],
                            id: element.first.id,
                            shopId: element.first.shopId,
                            logo: element.first.logo!.map((e) => e.path).toList(),
                            price: element.first.price!.toDouble(),
                            qty: element.length,
                            sizes: element.first.sizes ?? [],
                            title: element.first.name,
                            subTxt: element.first.description);

                        await cartController.addItemToCarts(
                          p,
                          '${product.shopId}',
                          element.first.shop?.vat,
                          element.first.shop?.deliveryCharge,
                        );
                        cartController.isInChart(element.first.shopId.toString(), p);
                      }
                    }

                    cartController.suggestUpdate();

                    Get.to(CartPage());
                    /*orderData!.products!.forEach((element) async {
                      if (element.isNotEmpty) {
                        pro.Product product = pro.Product(
                            colors: element.first.colors ?? [],
                            id: element.first.id,
                            shopId: element.first.shopId,
                            logo: element.first.logo!.map((e) => e.path).toList(),
                            price: element.first.price!.toDouble(),
                            qty: element.length,
                            sizes: element.first.sizes ?? [],
                            title: element.first.name,
                            subTxt: element.first.description);

                        cartController.addItemToCarts(
                          product,
                          '${product.shopId}',
                          element.first.shop!.vat,
                          element.first.shop!.deliveryCharge,
                        );
                        cartController.isInChart(element.first.shopId.toString(), product);
                        final SuggestController suggestCont = Get.put(SuggestController());

                        // cartController.deleverytime.value = this.time;
                        suggestCont.getsuggetItems();
                        cartController.suggestUpdate();

                        Get.to(CartPage());
                      }
                    });*/
                    // GetStorage box = GetStorage();
                    // box.write("cartList", Get.find<CartController>().cartList);
                    // box.write("shopid", shopid);
                    // box.write("vat", vat);
                    // box.write("deliveryCharge", deliveryCharge);
                    // print(vat);
                    // box.write("shopid", shopid);
                    // print("object");
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                child: Container(
                  height: 25,
                  width: 55,
                  decoration: BoxDecoration(color: Color(Helper.getHexToInt("#3AD8B4")), borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      "Reorder",
                      style: TextStyle(color: Colors.white, fontFamily: 'TTCommonsm', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
