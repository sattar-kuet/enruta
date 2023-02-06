import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';

import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

// ignore: must_be_immutable
class Verification extends StatelessWidget {
  final String email;
  Verification(this.email);
  final resetController = Get.put(ResetController());
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> textFieldControllers = [];

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  OtpFieldController otpController;
  String otp = '';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final node = FocusScope.of(context);

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
        title: Text(text('verification_code'),
            style: TextStyle(
                fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
          color: cardbackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: ListView(children: [
            Container(
              height: 200,
              width: 200,
              child: verificationimage(),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: FittedBox(
                child: OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 55,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                        focusBorderColor: Color(Helper.getHexToInt("#11C7A1")),
                        borderColor: Color(Helper.getHexToInt("#11C7A1"))),
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      resetController.getotp(pin);
                      print("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      resetController.checkverificationCode(pin);
                      otp = pin;
                      print("Completed: " + pin);
                    }),
              ),
              //     StaggeredGridView.countBuilder(
              //  itemCount: 6,
              //  itemBuilder: (context, index) {

              //  },
            ),

            // Form(
            //   key: _formKey,
            //   child: StaggeredGridView.countBuilder(
            //     crossAxisCount: 6,
            //     itemCount: 6,
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     itemBuilder: (context, index) {
            //       return inputCode(context,index);
            //     },
            //     staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            //   ),
            //   onChanged: () {
            //     if (_formKey.currentState.validate()) {
            //       print(_formKey.toString());
            //     }
            //   },
            // )
            // ),

            InkWell(
              onTap: () async {
                try {
                  await resetController.resetPassword(email);
                  Get.snackbar(
                    "We send a code to your email, please check",
                    "",
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Color(Helper.getHexToInt("#11E4A1")),
                  );
                } catch (e) {
                  Get.snackbar(
                    e,
                    '',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.red,
                  );
                }
              },
              child: Container(
                width: 100,
                height: 20,
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  text('resend_code'),
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(Helper.getHexToInt("#778191"))),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                text('verification_code'),
                style: GoogleFonts.poppins(fontSize: 20, color: black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                text('check_your_mail'),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(Helper.getHexToInt("#778191")),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            sendButton(),
            SizedBox(
              height: 50,
            ),
          ])),
    );
  }

  Widget verificationimage() {
    return Container(
      width: 200,
      height: 280,
      padding: EdgeInsets.only(top: 20),
      // padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Image.asset(
        'assets/icons/verification.png',
        // fit: BoxFit.fill,
      ),
    );
  }

  Widget inputCode(
      BuildContext contextss, int index, TextEditingController cont) {
    // textFieldControllers[index] = new TextEditingController() ;
    final node = FocusScope.of(contextss);
    return Container(
        width: 45,
        height: 60,
        margin: EdgeInsets.only(left: 5, right: 5),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration:
            BoxDecoration(color: white, borderRadius: BorderRadius.circular(9)),
        child: Center(
            child: TextFormField(
          keyboardType: TextInputType.phone,
          // ignore: deprecated_member_use
          // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          // inputFormatters: [
          //   new LengthLimitingTextInputFormatter(1),
          // ],
          autofocus: true,
          controller: cont,
          // maxLength: 1,
          style: TextStyle(fontSize: 25.0, height: 1.5, color: Colors.black),
          textAlign: TextAlign.center,
          onChanged: (text) {
            print("text is" + text.toString());
            resetController.getotp(text);
            if (text.length > 0) {
              node.nextFocus();
            }
          },
          //
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '',
          ),
        )));
  }

  Widget sendButton() {
    return Container(
      height: 100.0,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          // print(object)
          // print(textFieldControllers[1].text);

          resetController.checkverificationCode(otp);
          // Get.to(NewPassword());
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
            text('confirm'),
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
            ),
          )),
        ),
      ),
    );
  }
}
