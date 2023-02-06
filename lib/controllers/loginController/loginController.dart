import 'dart:convert';

import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/login.dart';
import 'package:enruta/screen/permissionCheck.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
  GoogleSignInAccount currentUser;
  // final cartController = Get.put(CartController());
  var loginStatus = 0.obs;
  var email = ''.obs;
  @override
  void onInit() {
    super.onInit();
    checklogin();
    // curentgoogleUser();

    getuserInfo();
  }

  void curentgoogleUser() async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    shp.clear();
    checklogin();
    int uid = int.parse(currentUser.id);
    shp.setInt("id", uid);
    shp.setString("name", currentUser.displayName);
    shp.setString("email", currentUser.email);
    shp.setString("profileImage", currentUser.photoUrl);
    // pimage.value = currentUser.photoUrl;
    print(currentUser.photoUrl);
    // var permission = await Geolocator().checkGeolocationPermissionStatus();
    // if (permission != GeolocationStatus.denied) {
    //   Get.offAll(HomePage());
    // } else {
    //   Get.offAll(PermissionCheckScreen());
    // }
    Get.offAll(HomePage());
  }

  void checklogin() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      currentUser = account;
      if (currentUser != null) {
        print(currentUser);
      }
    });
  }

  // bool ischeck = false.obs as bool;
  RxBool flag = false.obs;
  RxBool pflag = true.obs;
  var emailid = '';

  void getuserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("isremember") == "yes") {
      if (pref.getString("email") != null) {
        emailid = pref.getString("email");
      }
    }
  }

  Future<void> login(String email, [String password]) async {
    var convertedDatatojson;
    try {
      String url = 'https://enruta.itscholarbd.com/api/v2' + '/login';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"},
          body: {'login': email, 'password': password});
      convertedDatatojson = jsonDecode(response.body);
      var result = await convertedDatatojson['status'];

      if (result == 0) {
        Get.snackbar(
            convertedDatatojson['status_text'] ??
                "Please Input Valid Email & password",
            "",
            colorText: Colors.red,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Map<String, dynamic> user = convertedDatatojson['user_arr'];

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email);
        emailid = email;
        sharedPreferences.setString('password', password);

        sharedPreferences.setString('isremember', "yes");
        sharedPreferences.setInt('islogin', 1);
        sharedPreferences.setString("checkLogin", "a");
        int id = user["id"];
        String name = user["name"].toString();

        String username = user["username"].toString();
        String phone = user["phone"].toString();
        String avatar = user["avatar"].toString();

        sharedPreferences.setInt("id", id);
        sharedPreferences.setString("name", name);
        sharedPreferences.setString("email", email);
        sharedPreferences.setString("username", username);
        sharedPreferences.setString("phone", phone);
        sharedPreferences.setString("profileImage", avatar);
        //await Geolocator().getCurrentPosition();
        // var permission = await Geolocator().checkGeolocationPermissionStatus();
        // if (permission == GeolocationStatus.granted) {
        //   Get.offAll(HomePage());
        // } else {
        //   Get.offAll(PermissionCheckScreen());
        // }
        Get.offAll(HomePage());
      }

      // UserArr user = await convertedDatatojson['user_arr'];
    } catch (e) {
      Get.snackbar("error to login ", e.message,
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
    // return convertedDatatojson;
  }

  Future<void> deleteUserAccount(String userid, BuildContext context) async {
    final loginController = Get.put(LoginController());
    var convertedDatatojson;
    try {
      String url = 'https://enruta.itscholarbd.com/api/v2' + '/deleteUser';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"}, body: {'user_id': userid});
      convertedDatatojson = jsonDecode(response.body);
      var result = await convertedDatatojson['status'];

      if (result == 0) {
        Get.snackbar(
            convertedDatatojson['status_text'] ?? "Please try again latter...",
            "",
            colorText: Colors.red,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar(
            convertedDatatojson['status_text'] ?? "Deleted successfully.", "",
            colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
        //Get.offAll(HomePage());
        Navigator.pop(context);
        loginController.logout();
      }

      // UserArr user = await convertedDatatojson['user_arr'];
    } catch (e) {
      Get.snackbar("error to login ", e.message,
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
    // return convertedDatatojson;
  }

  void logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    email.value = sp.get("email");
    sp.clear();
    // cartController.cartList = List<Product>().obs;
    GetStorage().remove('cartList');
    sp.setString("email", email.value);
    sp.setString("checkLogin", "b");
    if (currentUser != null) {
      handleSignOut();
    } else {
      sp.setInt("islogin", 0);
    }
    // sp.clear();
    Get.offAll(LoginPage());
  }

  Future<void> handleSignIn() async {
    try {
      var p = await googleSignIn.signIn();
      print(p);
    } catch (error) {
      print(error);
    }
  }

  Future<void> googleuser(var email, var name, String id) async {
    // gid:kamal@gmail.com, name: kamal
    var convertedDatatojson;
    try {
      String url =
          'https://enruta.itscholarbd.com/api/v2' + '/signupWithGoogle';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"},
          body: {'email': email, 'name': name, 'gid': id});
      if (response.statusCode == 200) {
        convertedDatatojson = jsonDecode(response.body);

        dynamic result = await convertedDatatojson["status"];

        // print("\n\n\n\n\n MAP: " + result.toString()+"\n\n\n\n\n\n");

        if (result == 0) {
          Get.snackbar("Please Input Valid Email & password", "",
              colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        } else {
          // Map<String, dynamic> user = await convertedDatatojson["user"];

          // print("\n\n\n\n\n User:" + user.toString()+"\n\n\n\n\n\n");

          var id = await convertedDatatojson["user"]["id"];

          print("\n\n\n\n\nID:" + id.toString() + "\n\n\n\n\n\n");

          // String name = await convertedDatatojson["user"]["name"].toString();

          var roleId = await convertedDatatojson["user"]["role_id"];

          print("\n\n\n\n\nRoleID:" + id.toString() + "\n\n\n\n\n\n");

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          // ignore: non_constant_identifier_names
          int Xid = int.parse(id.toString());
          await sharedPreferences.setInt("id", Xid);

          await sharedPreferences.setString("roleId", roleId.toString());
          // var permission =
          //     await Geolocator().checkGeolocationPermissionStatus();
          // if (permission != GeolocationStatus.denied) {

          // } else {
          //   Get.offAll(PermissionCheckScreen());
          // }
        }
      }
    } catch (e) {
      print("\n\n\n\n\nErr: " + e.toString() + "\n\n\n\n\n\n");

      Get.snackbar("warning", e.toString(),
          colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> appleuser(var email, var name, String id) async {
    // gid:kamal@gmail.com, name: kamal
    var convertedDatatojson;
    try {
      String url = 'https://enruta.itscholarbd.com/api/v2' + '/signupWithApple';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"},
          body: {'email': email, 'name': name ?? '', 'apple_id': id});
      if (response.statusCode == 200) {
        convertedDatatojson = jsonDecode(response.body);

        dynamic result = await convertedDatatojson["status"];

        // print("\n\n\n\n\n MAP: " + result.toString()+"\n\n\n\n\n\n");

        if (result == 0) {
          Get.snackbar("Please Input Valid Email & password", "",
              colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        } else {
          // Map<String, dynamic> user = await convertedDatatojson["user"];

          // print("\n\n\n\n\n User:" + user.toString()+"\n\n\n\n\n\n");

          var id = await convertedDatatojson["user"]["id"];

          print("\n\n\n\n\nID:" + id.toString() + "\n\n\n\n\n\n");

          // String name = await convertedDatatojson["user"]["name"].toString();

          var roleId = await convertedDatatojson["user"]["role_id"];

          print("\n\n\n\n\nRoleID:" + id.toString() + "\n\n\n\n\n\n");

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          // ignore: non_constant_identifier_names
          int Xid = int.parse(id.toString());
          await sharedPreferences.setInt("id", Xid);

          await sharedPreferences.setString("roleId", roleId.toString());
          // var permission =
          //     await Geolocator().checkGeolocationPermissionStatus();
          // if (permission != GeolocationStatus.denied) {

          // } else {
          //   Get.offAll(PermissionCheckScreen());
          // }
        }
      }
    } catch (e) {
      print("\n\n\n\n\nErr: " + e.toString() + "\n\n\n\n\n\n");

      Get.snackbar("warning", e.toString(),
          colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> facebookUser(var email, var name, String id) async {
    // gid:kamal@gmail.com, name: kamal
    var convertedDatatojson;
    try {
      String url =
          'https://enruta.itscholarbd.com/api/v2' + '/signupWithFacebook';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"},
          body: {'email': email, 'name': name, "fid": id});

      convertedDatatojson = jsonDecode(response.body);
      var result = await convertedDatatojson['status'];
      if (result == 0) {
        Get.snackbar("Please Input Valid Email & password", "",
            colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      } else if (convertedDatatojson != null) {
        Map<String, dynamic> user = convertedDatatojson['user'];

        // int id = user["id"];
        // String name = user["name"].toString();

        var userId = int.parse(user["id"].toString());
        var roleId = user['role_id'].toString();
        // var name = await convertedDatatojson['name'];
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setInt("id", userId);
        sharedPreferences.setString("email", email);
        sharedPreferences.setString("roleId", roleId);
        // var permission = await Geolocator().checkGeolocationPermissionStatus();
        // if (permission != GeolocationStatus.denied) {
        //   Get.offAll(HomePage());
        // } else {
        //   Get.offAll(PermissionCheckScreen());
        // }
        Get.offAll(HomePage());
        //Get.offAll(HomePage());
      }
    } catch (e) {
      Get.snackbar("warning", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> handleSignOut() async {
    await googleSignIn.disconnect();
  }

  // ignore: unused_element
  Future<void> _handleSignOut() async => await googleSignIn.disconnect();
}
