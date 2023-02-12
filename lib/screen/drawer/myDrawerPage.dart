import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/loginController/loginController.dart';
import 'package:enruta/controllers/paymentController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/bottomnavigation/bottomController.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/myAccount/myaccount.dart';
import 'package:enruta/screen/myAccount/web_view.dart';
import 'package:enruta/screen/myFavorite/myFavorite.dart';
import 'package:enruta/screen/myOrder.dart';
import 'package:enruta/screen/paymentmethods.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:enruta/screen/setLocation.dart';
import 'package:enruta/screen/voucher/myvoucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class MyDrawerPage extends StatelessWidget {
  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  // ignore: non_constant_identifier_names
  Container GetImage() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          image: DecorationImage(
            onError: (exception, stackTrace) {
              // return AssetImage('assets/icons/profileimage.png');
            },
            fit: BoxFit.cover,
            image: ((dController.pimage.value.isNotEmpty) && (dController.pimage.value != 'null')
                ? NetworkImage('${dController.pimage.value}')
                : AssetImage(
                    'assets/icons/profileimage.png',
                  )) as ImageProvider<Object>,
          )),
      // Image.asset(
      //   "assets/images/group4320.png",
      //   width: 120.0,
      //   height: 120.0,
      //   fit: BoxFit.contain,
      // ),
      //
      // imageF == null
      //     ? AssetImage("assets/images/group4320.png")
      //     : FileImage(File(imageF.path)),
    );
  }

  final dController = Get.put(ResetController());

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    final pmController = Get.put(PaymentController());
    final tController = Get.put(TestController());
    final bottomCont = Get.put(BottomController());
    Get.put(CartController());
    dController.getUserInfo();
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              // margin: EdgeInsets.only(left: 20),

              accountName: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Obx(
                    () => Text(dController.userName.value.toString(), style: TextStyle(fontFamily: 'Poppins', fontSize: 14.0, color: Colors.white)),
                  )),
              accountEmail: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child:
                    // Obx(
                    //   () =>
                    Text(tController.address.value, maxLines: 2, style: TextStyle(fontFamily: 'Poppins', fontSize: 13.0, color: Colors.white)),
                // )
              ),
              decoration: BoxDecoration(
                color: theamColor,
              ),
              currentAccountPicture: Container(
                // backgroundColor: theamColor,
                child:
                    // Image.network("https://lh4.googleusercontent.com/-MZPdSamrBIc/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuclYi0TEz4rOxdXFBufUHhpleBeL2Q/s96-c/photo.jpg",
                    // fit: BoxFit.fill,)
                    Obx(() => GetImage()),
                // Container(
                //     // width: 52.0,
                //     // height: 52.0,
                //     decoration: new BoxDecoration(
                //         shape: BoxShape.circle,
                //         image: new DecorationImage(
                //             fit: BoxFit.fill,
                //             image: NetworkImage(dController.pimage.value)
                //         )
                //     )):Image.asset('assets/icons/persono.png')),

                // Image.network(dController.pimage.value, fit: BoxFit.fill,
                //     errorBuilder: (BuildContext context, Object exception,
                //         StackTrace stackTrace) {
                //       return Center(child: Image.asset('assets/icons/persono.png'),);
                //     }
                //
                //
                // ):Image.asset('assets/icons/persono.png'),)
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                bottomCont..curentPage(0);
                // Navigator.of(context).pop();
                Get.to(HomePage());
              },
              hoverColor: Color(Helper.getHexToInt("#11C4A1")).withOpacity(.15),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: Image.asset("assets/images/home.png", color: Color(Helper.getHexToInt("#CDCDD7"))),
                    ),
                    Text(
                      text('main'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                Get.to(SetLocation());
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: Image.asset(
                        "assets/images/place.png",
                        color: Color(Helper.getHexToInt("#CDCDD7")),
                      ),
                    ),
                    Text(
                      text('my_address'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                Get.to(MyOrder());
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/list2.svg"),
                    ),
                    Text(
                      text('my_orders'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                Get.to(MyFavorite());
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/heartq.svg"),
                    ),
                    Text(
                      text('favorite'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                Get.to(MyVoucher(
                  isFromSlider: true,
                ));
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 15,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/coupon.svg"),
                    ),
                    Text(
                      text('coupons'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                pmController.totalPayment.value = 0;
                Get.to(Paymentmethods(
                  isPaymentMethod: false,
                ));
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/wallet.svg"),
                    ),
                    Text(
                      text('wallet'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(MyAccount(
                  isFromBottom: false,
                ));
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/user1.svg"),
                    ),
                    Text(
                      text('my_account'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     padding: EdgeInsets.only(left: 20),
            //     height: 50,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         // Icon(SvgPicture.asset("assets/icons/home.svg"))
            //         Container(
            //           height: 20,
            //           width: 40,
            //           margin: EdgeInsets.only(right: 30),
            //           child: SvgPicture.asset("assets/icons/support.svg"),
            //         ),
            //         Text(
            //           text('costumers_support'),
            //           style: TextStyle(
            //               fontFamily: "TTCommonsd",
            //               fontSize: 16,
            //               color: Color(Helper.getHexToInt("#8D92A3"))),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => WebViewScreen(text('register_a_business'), 'https://enruta.itscholarbd.com/en/signup'),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/shop.svg"),
                    ),
                    Text(
                      text('register_a_business'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              splashColor: Color(Helper.getHexToInt("#11E4A1")).withOpacity(.4),
              onTap: () {
                Navigator.pop(context);
                loginController.logout();
                // handleSignOut();
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(SvgPicture.asset("assets/icons/home.svg"))
                    Container(
                      height: 20,
                      width: 40,
                      margin: EdgeInsets.only(right: 30),
                      child: SvgPicture.asset("assets/icons/group.svg"),
                    ),
                    Text(
                      text('sign_out'),
                      style: TextStyle(fontFamily: "TTCommonsd", fontSize: 16, color: Color(Helper.getHexToInt("#8D92A3"))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleSignOut() async {
    googleSignIn.disconnect();
  }
}
