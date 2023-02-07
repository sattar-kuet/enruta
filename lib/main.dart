// ignore: unused_import
import 'dart:async';
import 'dart:io';

import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/loginController/loginBinding.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: unused_import
import 'api/httpcert.dart';
import 'helper/helper.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    await GetStorage.init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    HttpOverrides.global = MyHttpOverrides();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      // navigation bar color
      statusBarColor: Color(Helper.getHexToInt("#11C7A1")),
      // status bar color
      statusBarBrightness: Brightness.dark,
      //status bar brigtness
      statusBarIconBrightness: Brightness.dark,
      //status barIcon Brightness
      systemNavigationBarDividerColor: Colors.white,
      //Navigation bar divider color
      systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
    ));

    runApp(GetMaterialApp(
      key: navigatorKey,
      color: Color(Helper.getHexToInt("#11C7A1")),
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        focusColor: Color(Helper.getHexToInt("#11C7A1")),
        primaryColor: Color(Helper.getHexToInt("#11C7A1")),
        primaryColorDark: Color(Helper.getHexToInt("#11C7A1")),
        unselectedWidgetColor: Color(Helper.getHexToInt("#6F6F6F")),
        iconTheme: IconThemeData(color: Color(Helper.getHexToInt("#11C7A1"))),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(Helper.getHexToInt("#11C7A1")),
          selectionColor: Color(Helper.getHexToInt("#11C7A1")),
          selectionHandleColor: Color(Helper.getHexToInt("#11C7A1")),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(Helper.getHexToInt("#11C7A1"))),
      ),
      initialBinding: LoginBinding(),
      // defaultTransition: Transition.fade,
      home: SplashScreen(),
    ));
  } catch (e) {
    runApp(GetMaterialApp(
      home: Scaffold(
          body: Center(
        child: Text(e.toString()),
      )),
    ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleSignInAccount currentUser;

  @override
  void initState() {
    super.initState();
    Get.put(LanguageController());
    Future.delayed(Duration(seconds: 3), () async {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      // googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      //   setState(() {
      //     currentUser = account;
      //   });
      // });
      // if (currentUser != null) {
      //   googleSignIn.signInSilently();
      // }

      checkloginstutas();
    });
  }

  void checkloginstutas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    var email = prefs.getString('email');
    // var email = prefs.getString('email');
    int islogin = prefs.getInt('islogin');
    var checkLogin = prefs.getString("checkLogin");
    var orderComplete = prefs.getInt("OrderCompletedShop");
    print("islogin");
    print(islogin);
    if (islogin == null) {
      islogin = 0;
    }
    print(islogin);
    // islogin ==1?Get.offAll(HomePage()):Get.offAll(LoginPage());
    if (checkLogin == "a") {
      // Get.put(TestController());
      // Get.put(CartController());
      //await Geolocator().getCurrentPosition();
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always && permission == LocationPermission.whileInUse) {
        if (orderComplete != null) {
          // Get.to(GetReviewPage(orderComplete));
        } else {
          Get.offAll(HomePage());
        }
      } else {
        Get.offAll(HomePage());
      }
    } else {
      Get.offAll(LoginPage());
    }

    // if (islogin == 1) {
    //   Get.offAll(HomePage());
    // } else {
    //   Get.offAll(LoginPage());
    // }

    // if (email == null) {
    //   print(email);
    //   Get.offAll(LoginPage());
    //   // Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => LoginPage()),
    //   //   (Route<dynamic> route) => false,
    //   // );
    // } else {
    //   Get.offAll(HomePage());
    //   // Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => HomePage()),
    //   //   (Route<dynamic> route) => false,
    //   // );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 300.0,
                  child: Image.asset(
                    "assets/images/Enruta-Logo.png",
                    height: 100,
                    width: 150,
                    // fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
