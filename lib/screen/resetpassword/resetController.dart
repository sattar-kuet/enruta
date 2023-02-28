import 'dart:convert';

import 'package:enruta/screen/login.dart';
import 'package:enruta/screen/resetpassword/newpassword.dart';
import 'package:enruta/screen/resetpassword/verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetController extends GetxController {
  var userName = ''.obs;
  var email = ''.obs;

  // final Rx<TextEditingController> cod1 = TextEditingController().obs;
  // final Rx<TextEditingController> cod2 = TextEditingController().obs;
  // final Rx<TextEditingController> cod3 = TextEditingController().obs;
  // final Rx<TextEditingController> cod4 = TextEditingController().obs;
  // final Rx<TextEditingController> cod5 = TextEditingController().obs;
  // final Rx<TextEditingController> cod6 = TextEditingController().obs;
  var pimage = ''.obs;
  var signupimage = ''.obs;
  var same = false.obs;
  var code = ''.obs;

  RxBool isHidden1 = true.obs;
  var a1 = ''.obs;

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  Future<void> reset() async {
    SharedPreferences spreferences = await SharedPreferences.getInstance();
    spreferences.remove("profileImage");
    spreferences.reload();
  }

  void changeicon() {
    isHidden1.value = !isHidden1.value;
  }

  void checkEmail(var val) {
    print(val);
    print(email.value);
    if (val == email.value) {
      same.value = true;
    } else {
      same.value = false;
    }
  }

  void getUserInfo() async {
    SharedPreferences spreferences = await SharedPreferences.getInstance();

    userName.value = spreferences.getString("name") ?? '';
    email.value = spreferences.getString("email") ?? '';
    pimage.value = spreferences.getString("profileImage") ?? '';
    signupimage.value = spreferences.getString("image") ?? '';
  }

  Future<void> resetPassword(String email) async {
    try {
      String url = 'https://app.enrutard.com/api/v2' + '/passwordResetRequest';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Accept": "Application/json"},
        body: {'email': email},
      );
      final responseBody = jsonDecode(response.body);
      final int status = responseBody['status'] ?? 0;
      if (status == 0) throw ('${responseBody['response']}');

      code.value = '${responseBody['code']}';
      Get.to(Verification(email));
    } catch (e) {
      rethrow;
    }
  }

  void checkverificationCode(String otpCode) {
    // var p =
    //     "${cod1.value.text}${cod2.value.text}${cod3.value.text}${cod4.value.text}${cod5.value.text}${cod6.value.text}";
    // print(p);
    // print(code.value.toString());
    if (otpCode == code.value) {
      Get.to(NewPassword());
    } else {
      Get.snackbar(
        "",
        "This code is already used OR invalid",
        colorText: Colors.red,
      );
    }
  }

  List<TextEditingController>? textFieldControllers;

  void getotp(var t) {
    // Get.snackbar("$t", "ttttt");
  }

  void setPassword(var pass) async {
    // https://app.enrutard.com/api/v2/

    var convertedDatatojson;
    try {
      String url = 'https://app.enrutard.com/api/v2' + '/resetPassword';
      final response = await http.post(Uri.parse(url), headers: {"Accept": "Application/json"}, body: {'code': code.value, 'password': pass});
      convertedDatatojson = jsonDecode(response.body);
      var result = await convertedDatatojson['status'];
      // var codes = await convertedDatatojson['code'];

      // code.value = codes;
      if (result == 1 && result != null) {
        // Get.to(Verification());
        Get.offAll(LoginPage());
      } else {
        Get.snackbar(
          convertedDatatojson['status_text'],
          "",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "input valid email ",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }
}
