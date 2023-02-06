import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPassword createState() => _NewPassword();
}

class _NewPassword extends State<NewPassword> {
  bool _isHidden = true;
  bool _isHidden1 = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleVisibility1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  final passwordController = TextEditingController();
  final confiremPassword = TextEditingController();

  final pController = Get.put(ResetController());

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(text('new_password'),
            style: TextStyle(
                fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
          color: cardbackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: ListView(children: [
            Container(
              height: 250,
              width: 250,
              child: verificationimage(),
            ),
            SizedBox(
              height: 30,
            ),

            Container(
              height: 30,
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                text('new_password'),
                style: TextStyle(
                    fontFamily: "TTCommonsr", fontSize: 20, color: black),
              ),
            ),

            Container(
              height: 60,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                text('enter_a_new_password'),
                style: TextStyle(
                  fontFamily: "Poppinsr",
                  fontSize: 14,
                  color: Color(Helper.getHexToInt("#778191")),
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),
            Container(
              height: 82,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: buidTextfield3(text('new_password'), passwordController),
            ),
            Container(
              height: 82,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: buidTextfield4(text('conform_password'), confiremPassword),
            ),

            SizedBox(
              height: 10,
            ),
            sendButton(),
            // Positioned(
            //   bottom: 10,
            //   left: 20,
            //   right: 20,
            //   child: sendButton(),
            // )
          ])),
    );
  }

  Widget verificationimage() {
    return Container(
      width: 250,
      height: 300,
      padding: EdgeInsets.only(top: 20),
      // padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Image.asset(
        'assets/icons/verify.png',
        // fit: BoxFit.fill,
      ),
    );
  }

  Widget inputCode() {
    return Container(
        // alignment: Alignment.topLeft,
        // padding: EdgeInsets.only(top: 5, left: 5),
        width: 50,
        height: 80,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: white,
            // border: Border.all(
            //   width: 2,
            //   // color: Color(Helper.getHexToInt("#00E9A3"))
            // ),
            borderRadius: BorderRadius.circular(9)),
        child: Center(
            child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '',
          ),
        )));
  }

  Widget buildTextfield() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: text('new_password'),
                        hintStyle: TextStyle(
                            color: Color(Helper.getHexToInt("#6F6F6F"))),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibility,
                          icon: _isHidden
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )),
                    controller: passwordController,
                    // obscureText: hintText == "Password" ? _isHidden : false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextfield2() {
    String hintText = text('password');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: text('conform_password'),
                        hintStyle: TextStyle(
                            color: Color(Helper.getHexToInt("#6F6F6F"))),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Obx(() => IconButton(
                              onPressed: () {
                                pController.isHidden1.toggle();
                                print(pController.isHidden1.value);
                              },
                              icon: pController.isHidden1.value
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: theamColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: theamColor,
                                    ),
                            ))

                        // suffixIcon: Obx(() => IconButton(
                        //       onPressed: () {
                        //         pController.changeicon();
                        //       },
                        //       icon: pController.isHidden1.value
                        //           ? Icon(Icons.visibility_off)
                        //           : Icon(Icons.visibility),
                        //     )

                        ),
                    controller: confiremPassword,
                    obscureText:
                        hintText == text('password') ? _isHidden : false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buidTextfield3(String hintText, TextEditingController scontroller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: Color(Helper.getHexToInt("#6F6F6F"))),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibility,
                          icon: _isHidden
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )),
                    controller: scontroller,
                    obscureText:
                        hintText == text('new_password') ? _isHidden : false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buidTextfield4(String hintText, TextEditingController scontroller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: Color(Helper.getHexToInt("#6F6F6F"))),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibility1,
                          icon: _isHidden1
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )),
                    controller: scontroller,
                    obscureText: hintText == text('conform_password')
                        ? _isHidden1
                        : false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sendButton() {
    return Container(
      height: 100.0,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (passwordController.text.isEmpty ||
                    confiremPassword.text.isEmpty) {
                  Get.snackbar("", text('Please input the password.'),
                      colorText: Colors.red);
                  return;
                }
                var a = passwordController.text;
                var b = confiremPassword.text;
                if (a == b) {
                  print(a);
                  pController.setPassword(a);
                } else {
                  Get.snackbar("", text('your_password_doesnt_match'),
                      colorText: Colors.red);
                }
              },
              child: Container(
                height: 70,
                // margin: EdgeInsets.all(10),
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
                  text('set_password'),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'TTCommonsm',
                  ),
                )),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
