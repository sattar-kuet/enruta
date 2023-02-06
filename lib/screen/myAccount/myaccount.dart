import 'dart:convert';
import 'dart:io';

import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/loginController/loginController.dart';
import 'package:enruta/controllers/paymentController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/bottomnavigation/bottomNavigation.dart';
import 'package:enruta/screen/drawer/myDrawerPage.dart';
import 'package:enruta/screen/myAccount/web_view.dart';
import 'package:enruta/screen/paymentmethods.dart';
import 'package:enruta/screen/promotion/promotion.dart';

import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:enruta/screen/setLocation.dart';
import 'package:enruta/screen/voucher/myvoucher.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myaccountController.dart';

class MyAccount extends StatefulWidget {
  bool isFromBottom;
  MyAccount({this.isFromBottom = true});
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final dController = Get.put(
    ResetController(),
  );

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  File imageF;
  GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAccountController());

    return Scaffold(
        key: key,
        drawer: MyDrawerPage(),
        body: Stack(children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 8,
                  height: 180,

                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topLeft, colors: [
                        Color(Helper.getHexToInt("#11C7A1")),
                        // Colors.green[600],
                        Color(Helper.getHexToInt("#11E4A1"))
                      ]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Container(
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.isFromBottom
                            ? Container()
                            : SafeArea(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.arrow_back_ios,
                                          color: Colors.white),
                                    )),
                              ),
                        Positioned(
                          top: 56,
                          left: 20,
                          // right: 50,
                          child: Container(
                            width: 103,
                            height: 98,
                            // padding: EdgeInsets.only(left: 10),
                            child: profileImage(context, imageF),
                          ),
                        ),
                        Positioned(
                          top: 65,
                          left: 145,
                          child: Obx(() => Text(
                                controller.name.value,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    color: white),
                              )),
                        ),
                        Positioned(
                          top: 90,
                          left: 145,
                          child: Obx(() => Text(
                                controller?.email?.value ?? "",
                                style: TextStyle(
                                    fontFamily: "Poppinsr",
                                    fontSize: 14,
                                    color: white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // showMenue(),
                account(),
                SizedBox(height: 1),
                offer(),
                SizedBox(height: 1),
                settings(context),
                SizedBox(height: 1),
                helpandlegal(),
                SizedBox(height: 50),
              ],
            ),
          ),
          !widget.isFromBottom
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigation(key)),
        ]));
  }

  Widget account() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 30,
                width: Get.width,
                child: Text(
                  text('account'),
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(Helper.getHexToInt("#22242A"))),
                )),
            Container(
                height: 40,
                width: Get.width,
                child: InkWell(
                  onTap: () {
                    Get.to(Paymentmethods(
                      isPaymentMethod: false,
                    ));
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/pay.png',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            text('payment_method'),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(Helper.getHexToInt("#22242A"))),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(Helper.getHexToInt("#CDCDD7")),
                        ),
                      )
                    ],
                  ),
                )),
            Divider(),
            Container(
                height: 40,
                width: Get.width,
                child: InkWell(
                  onTap: () {
                    Get.to(SetLocation());
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/placec.png',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            text('saved_addresses'),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(Helper.getHexToInt("#22242A")),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(Helper.getHexToInt("#CDCDD7")),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget offer() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                  height: 40,
                  width: Get.width,
                  child: Text(
                    text('offers'),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(Helper.getHexToInt("#22242A"))),
                  )),
            ),
            Container(
                height: 30,
                width: Get.width,
                child: InkWell(
                  onTap: () {
                    Get.to(Promotion());
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/shout.png',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            text('promotions'),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(Helper.getHexToInt("#22242A")),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(Helper.getHexToInt("#CDCDD7")),
                        ),
                      )
                    ],
                  ),
                )),
            Divider(),
            Container(
                height: 30,
                width: Get.width,
                child: InkWell(
                  onTap: () {
                    Get.to(MyVoucher());
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/coupon.png',
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            text('get_discount'),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(Helper.getHexToInt("#22242A")),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(Helper.getHexToInt("#CDCDD7")),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(
    context,
  ) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            // ignore: deprecated_member_use
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(
                  ImageSource.camera,
                  context,
                );
              },
              label: Text(
                text('camera'),
              ),
            ),

            // ignore: deprecated_member_use
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, context);
              },
              label: Text(
                text('gallery'),
              ),
            )
          ])
        ],
      ),
    );
  }

  bool spin = false;
  var path;
  void takePhoto(ImageSource source, context) async {
    try {
      final dController = Get.find<MyAccountController>();
      // ignore: non_constant_identifier_names
      final Controller = Get.find<ResetController>();
      // ignore: deprecated_member_use
      path = await ImagePicker.pickImage(
              source: source, maxHeight: 400, maxWidth: 300)
          .then((value) async {
        Navigator.pop(context);
        if (value.path.isEmpty) {
          return;
        }
        print('VALUE = $value');
        setState(() {
          if (value != null) {
            imageF = value;
            print('IMAGE PATH =$imageF');
            profileImage(context, imageF);
          } else {
            print('No image selected.');
          }
        });
        setState(() {
          spin = true;
        });
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                "https://enruta.itscholarbd.com/api/v2/updateProfilePicture"));
        print('path = $imageF');
        request.files.add(await http.MultipartFile.fromPath(
            'avatar', imageF.path.toString()));
        request.fields['user_id'] = '${dController.id.value}';
        http.Response response =
            await http.Response.fromStream(await request.send());
        if (response.statusCode == 200) {
          final userResponse = await http.post(
              Uri.parse('https://enruta.itscholarbd.com/api/v2/getUser'),
              headers: {"Accept": "Application/json"},
              body: {'email': '${dController.email.value}'});
          if (userResponse.statusCode == 200) {
            print('RESPONSE === ${userResponse.body}');
            var avatar = jsonDecode(userResponse.body);
            if (avatar['user']['avatar'] != null) {
              var i = avatar['user']['avatar']['path'];
              // print('RESPONSE === ${avatar['user']['avatar']['path']}');
              // dController.reset();
              Controller?.pimage?.value = i;
              SharedPreferences pre = await SharedPreferences.getInstance();
              pre.setString('profileImage', i);
            }
          }
        }
        setState(() {
          spin = false;
        });
      });
    } catch (e) {
      setState(() {});
      spin = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget profileImage(context, imageF) {
    print('profile = ${dController.pimage.value}');
    return Center(
      child: ModalProgressHUD(
        inAsyncCall: spin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(
                      context,
                    )),
              );
              print("Container clicked");
            },

            // child:CircleAvatar(
            //   radius: 80.0,
            //   backgroundImage: _imageFile == null
            //       ? AssetImage("assets/images/group4320.png")
            //       : FileImage(File(_imageFile.path)),
            // )
            child: GetImage(imageF),
            // Obx(()=>
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container GetImage(imageF) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          image: DecorationImage(
            onError: (exception, stackTrace) {
              return AssetImage('assets/icons/profileimage.png');
            },
            fit: BoxFit.cover,
            image: imageF != null
                ? FileImage(
                    imageF,
                  )
                : (dController.pimage?.value?.isNotEmpty ?? false) &&
                        (dController.pimage?.value != 'null')
                    ? NetworkImage(
                        '${dController.pimage.value}',
                      )
                    : AssetImage(
                        'assets/icons/profileimage.png',
                      ),
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

  Widget settings(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 40,
                width: Get.width,
                child: Text(
                  text('language'),
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(Helper.getHexToInt("#22242A"))),
                )),

            Container(
              height: 30,
              width: Get.width,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return languageDialog();
                      });
                },
                child: Row(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icons/language.png',
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          text('language'),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(Helper.getHexToInt("#22242A"))),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        language.currentLanguage,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(Helper.getHexToInt("#22242A"))),
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.navigate_next,
                        color: Color(Helper.getHexToInt("#CDCDD7")),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //     height: 50,
            //     width: Get.width,
            //     child: Row(
            //       children: [
            //         Center(
            //           child: Image.asset(
            //             'assets/icons/security.png',
            //           ),
            //         ),
            //         Expanded(
            //           child: Container(
            //             padding: EdgeInsets.only(left: 20),
            //             child: Text(
            //               text('permissions'),
            //               style: TextStyle(
            //                 fontFamily: "Poppins",
            //                 fontSize: 14,
            //                 color: Color(Helper.getHexToInt("#22242A")),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Center(
            //           child: Icon(
            //             Icons.navigate_next,
            //             color: Color(Helper.getHexToInt("#CDCDD7")),
            //           ),
            //         )
            //       ],
            //     )),
          ],
        ),
      ),
    );
  }

  Widget helpandlegal() {
    final loginController = Get.put(LoginController());
    final LoginController lController = Get.put(LoginController());

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        margin: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 40,
                width: Get.width,
                child: Text(
                  text('Help & Legal'),
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Color(Helper.getHexToInt("#22242A"))),
                )),
            Container(
                height: 30,
                width: Get.width,
                child: Row(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icons/help.png',
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => WebViewScreen(
                                  text('privacy-policy'),
                                  'https://www.enrutard.com/privacy-policy/'),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            text('privacy-policy'),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(Helper.getHexToInt("#22242A"))),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.navigate_next,
                        color: Color(Helper.getHexToInt("#CDCDD7")),
                      ),
                    )
                  ],
                )),
            Divider(),
            Container(
              height: 40,
              width: Get.width,
              child: Row(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/polices.png',
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => WebViewScreen(
                                text('terms-and-conditions'),
                                'https://www.enrutard.com/terms-and-conditions/'),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          text('terms-and-conditions'),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(Helper.getHexToInt("#22242A")),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.navigate_next,
                      color: Color(Helper.getHexToInt("#CDCDD7")),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              height: 40,
              width: Get.width,
              child: Row(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/delete.png',
                      color: Color(Helper.getHexToInt("#FF0000")),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        try {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          debugPrint(
                              'Delete UserID -------------- ${sp.getInt("id").toString()}');
                          await lController.deleteUserAccount(
                              sp.getInt("id").toString(), context);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: e.toString(), textColor: Colors.red);
                        }
                        //Navigator.pop(context);
                        //loginController.logout();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Delete Account',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(Helper.getHexToInt("#FF0000")),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Icon(
                  //     Icons.navigate_next,
                  //     color: Color(Helper.getHexToInt("#FF0000")),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class languageDialog extends StatefulWidget {
  languageDialog();

  @override
  _languageDialog createState() => _languageDialog();
}

// ignore: camel_case_types
class _languageDialog extends State {
  _languageDialog();

  bool open = true;

  final language = Get.put(LanguageController());

  String dropdownValue;

  List<String> langs;

  int data = 0;

  @override
  Widget build(BuildContext context) {
    if (open) {
      open = false;
      data = language.currentLanguage == language.english ? 0 : 1;
      langs = [language.english, language.spanish];
    }

    return AlertDialog(
      contentPadding: EdgeInsets.all(5.0),
      backgroundColor: cardbackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height / 4,
        width: Get.width,
        child: Column(
          children: [
            Container(
              height: 35,
              width: Get.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "Choose language",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'TTCommonsm',
                          color: Color(Helper.getHexToInt("#B0B0B0")),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(
                            Helper.getHexToInt("#F2F2F2"),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: theamColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Column(
              children: [
                Center(
                  child: RadioListTile<int>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    title: Text("English"),
                    value: 0,
                    onChanged: (state) {
                      setState(() {
                        data = state;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.green,
                    groupValue: data,
                  ),
                ),
                Center(
                  child: RadioListTile<int>(
                    title: Text("Spanish"),
                    value: 1,
                    onChanged: (state) {
                      setState(() {
                        data = state;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.green,
                    groupValue: data,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 30,
              width: 100,
              margin: EdgeInsets.only(
                right: 25,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 100,
                  child: Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(Helper.getHexToInt("#11C7A1")),
                      //Colors.white,
                      fontFamily: 'TTCommonsm',
                    ),
                  )),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
              ),
              child: langs[data] == language.currentLanguage
                  ? Container()
                  : InkWell(
                      onTap: () {
                        if (langs[data] != language.currentLanguage) {
                          Navigator.pop(context);
                          language.setLanguage(langs[data]);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 150,
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              colors: [
                                Color(Helper.getHexToInt("#11C7A1")),
                                Color(Helper.getHexToInt("#11E4A1"))
                              ]),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            "Save & Restart",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'TTCommonsm',
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        )
      ],
    );
  }
}
