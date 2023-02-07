import 'dart:convert';

import 'package:enruta/main.dart';
// import 'package:enruta/screen/homePage.dart';
// import 'package:enruta/screen/myAccount/myaccount.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  String english = 'English';
  String spanish = 'Spanish';
  String currentLanguage;

  dynamic _data;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  loadLanguage({bool load = false}) async {
    if (!load && _data != null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs.getString('app_language');
    if (currentLanguage == null) {
      currentLanguage = english;
      await prefs.setString('app_language', currentLanguage);
    }

    try {
      String jsonContent = await rootBundle
          .loadString("assets/${currentLanguage.toLowerCase()}.json");
      _data = jsonDecode(jsonContent);
    } catch (e) {
      print("\n\n\nError:::" + e.toString() + "\n\n\n");
    }
    print("\n\n\n\n\nIts done.\n\n\n\n\n");
  }

  String text(var key) {
    if (_data == null) {
      loadLanguage();
      return key;
    }
    return _data[key] ?? key;
  }

  setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);
    loadLanguage(load: true);
    Get.offAll(SplashScreen());
  }
}
