import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/paymentController.dart';
import 'package:enruta/controllers/suggestController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:enruta/screen/voucher/myvoucher.dart';
import 'package:enruta/view/cart_list_view.dart';
import 'package:enruta/view/cart_slid_view.dart';
import 'package:enruta/widgetview/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'paymentmethods.dart';
import 'setLocation.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  final CartController cartCont = Get.put(CartController());
  final cCont = Get.find<CartController>();
  final suggestController = Get.put(SuggestController());
  final pmController = Get.put(PaymentController());

  // final mController = Get.put(MenuController());

  // final CartController controller = Get.find();
  final voucherController = TextEditingController();

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    // cCont.ordertypetapped(false);
    cCont.selectaddresstapped(false);
    cCont.subTprice.value = (cCont.totalPrice != null ? cCont.totalPrice : 0.0);
    cCont.tvatprice.value = (cCont.vatPrice != null ? cCont.vatPrice : 0.0);
    cCont.grandTotalprice.value = (cCont.gTotal != null ? cCont.gTotal : 0.0);
    cartCont.checkOffer.value = 0;
    cartCont.cuponerrortxt.value = "";

    // print(cartCont.totalPrice);
    // print(cartCont.vat.value);
    // print(cartCont.gTotal);

    // cCont.subTprice.value = 0.0;
    // cCont.tvatprice.value = 0.0;
    // cCont.grandTotalprice.value = 0.0;
    // if (cCont.shopid.value != null) {
    //   mController.getmenuItems(cCont.shopid.value);
    // } else {
    //   mController.getmenuItems(1);
    // }
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            iconSize: 18,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                  Color(Helper.getHexToInt("#11C7A1")),
                  // Colors.green[600],
                  Color(Helper.getHexToInt("#11E4A1"))
                ]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(text('my_cart'), style: TextStyle(fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              Positioned(
                bottom: -100,
                left: -30,
                child: new Container(
                    width: 150.0,
                    height: 220.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: AssetImage('assets/icons/unnamed (1).png'), fit: BoxFit.cover),
                    )),
              ),
              Positioned(
                bottom: -90,
                right: -50,
                child: new Container(
                    width: 150.0,
                    height: 150.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: AssetImage('assets/icons/unnamed.png'), fit: BoxFit.cover),
                    )),
              ),
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Container(
                          child: profile(context),
                        ),

                        // Text(cartCont.cartList.length.toString()),

                        Obx(() {
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: cartCont.cartList.length ?? 0,
                            itemBuilder: (context, index) => Dismissible(
                              child: CartListView(
                                cartData: cartCont.cartList[index],
                              ),
                              key: UniqueKey(),
                              onDismissed: (_) {
                                cartCont.suggetItems.add(cartCont.cartList[index]);
                                var removed = cartCont.cartList[index];

                                cartCont.cartList.removeAt(index);
                                cartCont.totalCalculate();

                                Get.snackbar('', text('item_successfully_removed'),
                                    colorText: Colors.white,

                                    // ignore: deprecated_member_use
                                    mainButton: TextButton(
                                      child: Text(text('undo')),
                                      onPressed: () {
                                        if (removed == null) {
                                          return;
                                        }
                                        cartCont.cartList.insert(index, removed);
                                        removed = null;
                                        if (Get.isSnackbarOpen) {
                                          Get.back();
                                        }
                                      },
                                    ));
                              },
                            ),
                            // separatorBuilder: (_, __) => Divider(),
                            separatorBuilder: (context, index) {
                              return Text("");
                            },
                          );
                        }),

                        // ListView(
                        //   shrinkWrap: true,
                        //   physics: ClampingScrollPhysics(),
                        //   children: List.generate(cartList.length, (index) {
                        //     return CartListView(
                        //       cartData: cartList[index],
                        //     );
                        //   }),
                        // ),
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(text('suggested_items')),
                          ),
                        ),

                        Container(
                          height: 110,
                          decoration: BoxDecoration(),
                          child: Obx(() {
                            if (cartCont.suggetItems.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: cartCont.suggetItems.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return CartSlidView(
                                      cartData: cartCont.suggetItems[index],
                                    );
                                  });
                            } else {
                              return Center(
                                  child: Text(
                                text('no_suggested_available_yet'),
                              ));
                            }
                          }),
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //       horizontal: 15, vertical: 30),
                        //   // height: 71,
                        //   child: Text(
                        //     "We will deliver to your door”, all deliveries " +
                        //         "comes in a big box over USPS or Fedex Or UPS, doesn’t matter, " +
                        //         "Just keep it Simple: We will deliver to your door",
                        //     textAlign: TextAlign.justify,
                        //     style: TextStyle(
                        //         fontSize: 14,
                        //         fontFamily: 'TTCommonsm',
                        //         color: Color(Helper.getHexToInt("#959599"))),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                text('apply_coupon_code'),
                                style: TextStyle(fontSize: 15, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#636573")).withOpacity(0.6)),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(MyVoucher())!.then((value) {
                                    voucherController.text = cCont.voucherName.value;
                                  });
                                },
                                child: Text(
                                  text('check_voucher'),
                                  style: TextStyle(fontSize: 15, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#11C7A1")).withOpacity(0.6)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 200,
                                margin: EdgeInsets.only(left: 20),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "BARBIQ20",
                                    hintStyle: TextStyle(
                                      color: Color(Helper.getHexToInt("#636573")).withOpacity(.2),
                                      fontSize: 16.0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {
                                    cartCont.checkOffer.value;
                                    print(cartCont.checkOffer.value);

                                    // print(text);
                                  },
                                  controller: voucherController,
                                ),
                                // child: TextField(

                                //   decoration: InputDecoration(
                                //       border: InputBorder.none,
                                //       hintText:
                                //           'Enter a search term'),
                                // ),
                              ),
                              Container(
                                width: 100,
                                height: 41,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11C7A1")), Color(Helper.getHexToInt("#11E4A1"))]),
                                    borderRadius: BorderRadius.circular(6)),
                                child: InkWell(
                                  onTap: () async {
                                    if (voucherController.text.isEmpty) return;

                                    final currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                                    try {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          });
                                      await cartCont.applyVoucher(voucherController.text).then((hasApplied) {
                                        if (hasApplied)
                                          cartCont.totalCalculate();
                                        else
                                          throw ('Coupon code not applied');
                                      });
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: e.toString());
                                    } finally {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Center(
                                      child: Text(
                                    text('apply_now'),
                                    style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.white),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Obx(() => cartCont.checkOffer.value == 1
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  cartCont.cuponerrortxt.value,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                text('payment_details'),
                                style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 14),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        text('subtotal'),
                                        style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                      ),
                                      Obx(() => cartCont.subTprice.value != null
                                          ? Text(
                                              "\$" + cartCont.subTprice.value.toString(),
                                              // cCont.totalPrice
                                              //     .toString(),
                                              style: TextStyle(
                                                  fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                            )
                                          : Text("0")),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        text('Vat'),
                                        style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                      ),
                                      Obx(
                                        () => cartCont.tvatprice.value != null
                                            ? Text(
                                                "\$" + cartCont.tvatprice.value.toString(),
                                                style: TextStyle(
                                                    fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                              )
                                            : Text("0"),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        text('delivery'),
                                        style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                      ),
                                      Obx(
                                        () => cartCont.deliveryCharge.value != null
                                            ? Text(
                                                "\$" + cartCont.deliveryCharge.value.toString(),
                                                style: TextStyle(
                                                    fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                              )
                                            : Text("\$0"),
                                      )
                                    ],
                                  ),
                                ),
                                Obx(() => cartCont.cuppon.value > 0
                                    ? Container(
                                        padding: EdgeInsets.only(top: 3, bottom: 5, left: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              text('coupon'),
                                              style: TextStyle(
                                                  fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                            ),
                                            Obx(
                                              () => cartCont.cuppon.value != null
                                                  ? Text(
                                                      "- \$" + cartCont.cuppon.value.toString(),
                                                      style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4)),
                                                    )
                                                  : Text(
                                                      "\$" + "0",
                                                      style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4)),
                                                    ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      )),
                                Obx(() => cartCont.voucher.value > 0
                                    ? Container(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(text('voucher'), style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4))),
                                            Obx(
                                              () => cartCont.voucher.value != null
                                                  ? Text("- \$" + cartCont.voucher.value.toString(),
                                                      style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4)))
                                                  : Text("\$" + "0"),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      )),
                                Obx(() => cartCont.discount.value > 0
                                    ? Container(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              text('offer'),
                                              style: TextStyle(
                                                  fontSize: 14, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#000000")).withOpacity(0.4)),
                                            ),
                                            Obx(
                                              () => cartCont.discount.value != null
                                                  ? Text("- \$" + cartCont.discount.value.toString(),
                                                      style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4)))
                                                  : Text(
                                                      "\$" + "0",
                                                      style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.red.withOpacity(0.4)),
                                                    ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      )),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        text('total'),
                                        style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.black),
                                      ),
                                      Obx(
                                        () => Text("\$" + cartCont.grandTotalprice.value.toString(),
                                            style: TextStyle(fontSize: 14, fontFamily: 'TTCommonsd', color: Colors.black)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        buidbottomfield(context),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget profile(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,

      margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: [
            Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    onError: (exception, stackTrace) => AssetImage('assets/icons/image.png'),
                    image: ((Get.find<ResetController>().pimage.value.isNotEmpty ?? false)
                        ? NetworkImage('${Get.find<ResetController>().pimage.value}')
                        : AssetImage('assets/icons/image.png')) as ImageProvider<Object>,
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 10,
              bottom: 10,
              left: 66,
              child: Center(
                child: Container(
                  child: Text(
                    text('your_order'),
                    style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#959595"))),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                top: 10,
                right: 10,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      // Get.to();
                      Navigator.of(context).pop();
                      print("view all ");
                    },
                    child: Text(
                      text('view_menu'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 14, color: Color(Helper.getHexToInt("#3AD8B4"))),
                    ),
                  ),
                )),
          ],
        ),
      ),
      // ),
    );
  }

  Widget buidbottomfield(BuildContext context) {
    return CustomButton(
      flatbtn: true,
      onclick: () {
        pmController.totalPayment.value = cartCont.gTotal;
        if (cartCont.cartList.length > 0) {
          Get.bottomSheet(showBottompopup(context) ?? error());
        } else {
          Get.snackbar(
            "No Item in Cart",
            "Add item in cart ",
            colorText: Colors.white,
          );
        }
      },
      child: Stack(
        children: [
          Container(
            height: 60,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              // color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
                child: Text(
              text('CONTINUE'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'TTCommonsm',
              ),
            )),
          ),
          Positioned(
            left: 15,
            top: 15,
            child: InkWell(
              child: Container(
                alignment: Alignment.topLeft,
                // padding: EdgeInsets.only(top: 5, left: 5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: Color(Helper.getHexToInt("#41E9C3")), borderRadius: BorderRadius.circular(9)),
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              right: 20,
              top: 10,
              bottom: 10,
              // child: InkWell(
              // onTap: () {
              //   showBottompopup(context);
              // },
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: white,
                  ),
                  onPressed: null))
          // )
        ],
      ),
    );
  }

  Widget showBottompopup(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: cardbackgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Center(
          child: Container(
            // height: 200,
            child: Stack(
              children: [
                Positioned(
                    top: 18,
                    left: 19,
                    child: Text(
                      text('review_order'),
                      style: TextStyle(fontSize: 16, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#C4C4C4"))),
                    )),
                Positioned(
                    top: 42,
                    left: 0,
                    right: 0,
                    child: Divider(
                      thickness: 1,
                      color: Color(Helper.getHexToInt("#707070")).withOpacity(0.1),
                    )),

                Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 0),
                            child: showOrdercart(context),
                          ),
                          Obx(
                            () => cartCont.isPickUpMethod.value
                                ? SizedBox(height: 10)
                                : Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 8),
                                    child: showcart(context),
                                  ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 0),
                            child: showPaymentcart(context),
                          )
                        ],
                      ),
                    )),
                // Positioned(
                //     top: 60,
                //     left: 10,
                //     right: 10,
                //     child: showOrdercart(context)),
                // Positioned(
                //     top: 139, left: 10, right: 10, child: showcart(context)),
                // Positioned(
                //     top: 219,
                //     left: 10,
                //     right: 10,
                //     child: showPaymentcart(context)),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: orderbottomfield(context),
                )
              ],
            ),
          ),
        ));
  }

  Widget showcart(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(Helper.getHexToInt("#F0F0F0")))),
      child: InkWell(
        onTap: () {
          // Get.to(SetLocation());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SetLocation()),
            (Route<dynamic> route) => true,
            // showCupertinoDialog(context);
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Center(
                child: Container(
                  child: Text(
                    text('deliver_to'),
                    style: TextStyle(fontFamily: "TTCommonsm", fontSize: 16, color: Color(Helper.getHexToInt("#C4C4C4"))),
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              left: 10,
              // right: 10,
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    size: 15,
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              left: 30,
              right: 10,
              child: Container(
                height: 25,
                margin: EdgeInsets.only(left: 0, right: 10),
                padding: EdgeInsets.only(left: 0, right: 20),
                child: Obx(
                  () => cartCont.selectAddress.value != null
                      ?
                      //  Flexible(
                      //     child: RichText(
                      //     textAlign: TextAlign.left,
                      //     maxLines: 1,
                      //     text: TextSpan(
                      //         style: TextStyle(
                      //             fontFamily: "TTCommonsm",
                      //             fontSize: 16,
                      //             color: Color(Helper.getHexToInt("#000000"))),
                      //         text: cartCont.selectAddress.value),
                      //   ))
                      Text(
                          cartCont.selectAddress.value,
                          maxLines: 1,
                          style: TextStyle(fontFamily: "TTCommonsm", fontSize: 16, color: Color(Helper.getHexToInt("#000000"))),
                        )
                      : Text(""),
                ),
              ),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              right: 10,
              // right: 10,
              child: InkWell(
                onTap: () {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SetLocation()),
                  //   (Route<dynamic> route) => true,
                  // );
                },
                child: Container(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Color(Helper.getHexToInt("#000000")).withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Widget showpaymentoption(){
// return CustomAlertDialog(

// )
//   }

  Widget showOrdercart(BuildContext context) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(Helper.getHexToInt("#F0F0F0")))),
      child: InkWell(
        onTap: () {
          // cartCont.ordertypetapped(true);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0.0),
                  backgroundColor: cardbackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  content: Container(
                    height: Get.height / 4,
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(top: 10, left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text('order_method'),
                            style: TextStyle(fontSize: 15, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#C4C4C4"))),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(padding: EdgeInsets.only(left: 20, right: 20), child: addresstype(context)),
                      ],
                    ),
                  ),
                  actions: [],
                );
              });
        },
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Center(
                child: Container(
                  child: Text(
                    text('order_method'),
                    style: TextStyle(fontFamily: "TTCommonsm", fontSize: 16, color: Color(Helper.getHexToInt("#C4C4C4"))),
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              left: 10,
              // right: 10,
              child: Obx(
                () => Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          // ignore: unrelated_type_equality_checks
                          image: cartCont.isPickUpMethod.value ? AssetImage('assets/icons/pickup_select.png') : AssetImage('assets/icons/pathao.png'),
                          fit: BoxFit.cover),
                    )
                    // ),
                    ),
              ),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              left: 40,
              // right: 10,
/*              child: Obx(
                () => cartCont.ordertypetapped.value
                    ? Text(
                        cartCont.deliveryType.value == 0 ? text('pick_up') : "Delivery in " + Get.put(TestController()).sendtime.value,
                        style: TextStyle(fontFamily: "TTCommonsm", fontSize: 16, color: Color(Helper.getHexToInt("#000000"))),
                      )
                    : Text("Select"),*/
              child: Obx(
                () => Text(
                  cartCont.isPickUpMethod.value ? text('pick_up') : "Delivery in " + Get.put(TestController()).sendtime.value,
                  style: TextStyle(fontFamily: "TTCommonsm", fontSize: 16, color: Color(Helper.getHexToInt("#000000"))),
                ),
              ),

              // Text(
              //   "Delivery in 35-50 Min",
              //   style: TextStyle(
              //       fontSize: 16,
              //       fontFamily: 'TTCommonsm',
              //       color: Color(Helper.getHexToInt("#000000"))
              //           .withOpacity(0.8)),
              // )
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              right: 10,
              // right: 10,
              child: Container(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(Helper.getHexToInt("#000000")).withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showPaymentcart(BuildContext context) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(Helper.getHexToInt("#F0F0F0")))),
      child: InkWell(
        onTap: () {
          // Get.to(Paymentmethods());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Paymentmethods(isPaymentMethod: true),
            ),
            (Route<dynamic> route) => true,
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Center(
                child: Container(
                  child: Text(
                    text('payment_method'),
                    style: TextStyle(fontFamily: "TTCommonsm", fontSize: 15, color: Color(Helper.getHexToInt("#C4C4C4"))),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 37,
              left: 10,
              child: Obx(() => pmController.paymentType.value != 0
                  ? Row(
                      children: [
                        Container(
                          height: 25,
                          width: 49,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: pmController.paymentType.value == 1 ? AssetImage('assets/icons/cashpa.png') : AssetImage('assets/icons/cIcon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(!cartCont.isPickUpMethod.value
                            ? "Cash on delivery"
                            : pmController.paymentType.value == 2
                                ? "Card Payment"
                                : cartCont.isPickUpMethod.value
                                    ? ""
                                    : ''),
                      ],
                    )
                  : Container(
                      height: 15,
                      width: 49,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: AssetImage('assets/icons/visaIcon.png'), fit: BoxFit.cover),
                      ),
                    )),
            ),
            Positioned(
              // bottom: 1,
              top: 37,
              right: 10,
              // right: 10,
              child: Container(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(Helper.getHexToInt("#000000")).withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderbottomfield(BuildContext context) {
    return CustomButton(
        loadingenabled: true,
        child: Container(
          height: 50,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, colors: [
              Color(Helper.getHexToInt("#11C7A1")),
              // Colors.green[600],
              Color(Helper.getHexToInt("#11E4A1"))
            ]),
            // color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
              child: Text(
            text('ORDER_DELIVERY'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'TTCommonsm',
            ),
          )),
        ),
        onclick: () async {
          try {
            final isPickUpMethod = cartCont.isPickUpMethod.value;
            final paymentMethod = pmController.paymentType.value;

            if (paymentMethod != 0) {
              final selectedAddress = cartCont.selectAddress.value;
              if (!isPickUpMethod && selectedAddress.isEmpty)
                Get.snackbar("", "Provide address");
              else {
                await cartCont.sendOrder(context);
                showSuccessfullyBottompopup(context);
              }
            } else
              Get.snackbar("", "Provide all details");
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
          }
        });
  }

  // ignore: missing_return
  void showSuccessfullyBottompopup(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage("assets/icons/delevery.png"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text('your_order_placed'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 23, color: Color(Helper.getHexToInt("#959595"))),
                      ),
                      SizedBox(width: 10),
                      Text(
                        text('successfully'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 23, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      text('you_will_receive_a_conformation_mail') + ".",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#959595"))),
                    ),
                  ),
                  // ),
                  const SizedBox(height: 10),
                  goHomebottomfield(context),
                  // Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: <Widget>[
                  //       const Text('Modal BottomSheet'),
                  //       ElevatedButton(
                  //         child: const Text('Close BottomSheet'),
                  //         onPressed: () => Navigator.pop(context),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  Widget error() {
    return SizedBox(
      height: 0,
    );
  }

  Widget goHomebottomfield(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            // cartCont.gobackhomePage();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              // color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
                child: Text(
              text('go_home_page'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'TTCommonsm',
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget addresstype(BuildContext context) {
    return Container(
        // height: 140,
        width: Get.width,
        child: Column(
          children: [
            Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        // cartCont.deliverOption.value = text('pick_up');
                        cartCont.isPickUpMethod.value = true;

                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 100,
                        width: Get.width / 5,
                        padding: EdgeInsets.only(top: 20),
                        margin: EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              //  child: Image.asset("assets/icons/shout.png"),
                              child: Image.asset(
                                "assets/icons/take-away@2x.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SafeArea(
                              child: Container(
                                height: 20,
                                child: Text(text('pick_up'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'TTCommonsm',
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        // cartCont.deliverOption.value = text('delivery');
                        cartCont.isPickUpMethod.value = false;
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation()));
                        // Navigator.of(context).pop();
                        // Get.to(SetLocation());
                      },
                      child: Container(
                        height: 100,
                        width: Get.width / 5,
                        padding: EdgeInsets.only(top: 20),
                        margin: EdgeInsets.only(right: 20, left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              //  child: Image.asset("assets/icons/directions_bikes-24px"),
                              child: Image.asset(
                                "assets/icons/directions_bike-24px.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 20,
                              child: Text(text('delivery'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'TTCommonsm',
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
