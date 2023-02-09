import 'dart:convert';
import 'dart:io';

import 'package:enruta/Animation/FadeAnimation.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/loginController/loginController.dart';

import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/resetpassword/resetPassword.dart';
import 'package:enruta/screen/signup.dart';
import 'package:enruta/widgetview/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// ignore: unused_import
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../helper/helper.dart';

// class LoginPage extends GetWidget<LoginController> {
// class LoginPage extends StatelessWidget {

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );
// GoogleSignIn googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  GetStorage box = GetStorage();

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  final LoginController lController = Get.put(LoginController());
  final heroTag = "assets/images/homeimage.png";
  bool _isHidden = true;
  GoogleSignInAccount currentUser;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool _isLoading = false;

  String name = '', image;

  // ignore: unused_field
  String _message = 'Log in/out by pressing the buttons below.';

  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = '';

  void checkloginstutas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    // ignore: unused_local_variable
    int islogin = prefs.getInt('islogin');

    if (email == null) {
      print(email);
    } else {
      // await Geolocator().getCurrentPosition();
      // var permission = await Geolocator.checkPermission();
      // if (permission != GeolocationStatus.denied) {
      //   Get.offAll(HomePage());
      // } else {
      //   Get.offAll(PermissionCheckScreen());
      // }
      Get.offAll(HomePage());
      //Get.offAll(HomePage());
    }
  }

  // ignore: unused_field
  GoogleSignInAccount _currentUser;

  // ignore: unused_field
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      // applesignin.AppleSignIn.onCredentialRevoked.listen((_) {
      //   print("Credentials revoked");
      // });
    }
    var userName = box?.read('rememberMePrefUserName') ?? '';
    var pass = box?.read('rememberMePrefPassword') ?? '';
    print("username : $userName");
    if ((userName?.toString()?.trim()?.isNotEmpty ?? false) && (pass?.toString()?.trim()?.isNotEmpty ?? false)) {
      emailController.text = userName;
      passwordController.text = pass;
      lController.flag.value = true;
    }
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     _handleGetContact(_currentUser);
    //   }
    // });
    // _googleSignIn.signInSilently();

    //
    // googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     currentUser = account;
    //     if (currentUser != null) {

    //       print(currentUser.photoUrl);
    //     }
    //   });
    // });
    // googleSignIn.signInSilently();
  }

  // ignore: unused_element
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> setcurentgoogleUser() async {
    SharedPreferences shp = await SharedPreferences.getInstance();

    // int uid = int.parse(currentUser.id) ;
    // shp.setInt("id", uid);
    shp.setString("name", currentUser.displayName);
    shp.setString("email", currentUser.email);
    shp.setString("profileImage", currentUser.photoUrl);
    shp.setString("checkLogin", "a");
    // lController.pimage.value = currentUser.photoUrl;
    await lController.googleuser(currentUser.email, currentUser.displayName, currentUser.id);
    print(currentUser.photoUrl);
    print(currentUser.id);
    print(currentUser);
  }

  Future<void> setcurentAppleUser() async {
    SharedPreferences shp = await SharedPreferences.getInstance();

    // int uid = int.parse(currentUser.id) ;
    // shp.setInt("id", uid);
    shp.setString("name", FirebaseAuth.instance.currentUser?.displayName ?? '');
    shp.setString("email", FirebaseAuth.instance.currentUser.email);
    shp.setString("profileImage", FirebaseAuth.instance.currentUser.photoURL);
    shp.setString("checkLogin", "a");
    // lController.pimage.value = FirebaseAuth.instance.currentUser.photoUrl;

    await lController.appleuser(FirebaseAuth.instance.currentUser.email, FirebaseAuth.instance.currentUser.displayName, FirebaseAuth.instance.currentUser.uid);
    print(FirebaseAuth.instance.currentUser.photoURL);

    print(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            reverse: false,
            shrinkWrap: false,
            physics: NeverScrollableScrollPhysics(),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            children: [
          Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height - 2.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  matchTextDirection: false,
                  image: AssetImage("assets/images/homeimage.png"),
                  fit: BoxFit.none,
                ),
              ),
            ),
            Positioned(
                top: 230.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          text('welcome'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 36),
                        ),
                        Text(
                          text('please_log_into_your_account'),
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 250.0,
              left: 20.0,
              right: 20.0,
              bottom: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(1.3, buidTextfield3(text('email'), emailController, context)),
                            SizedBox(
                              height: 15,
                            ),
                            FadeAnimation(1.3, buidTextfield3(text('password'), passwordController, context)),
                          ],
                        )),
                    FadeAnimation(
                      1.3,
                      Container(
                        height: 50,
                        alignment: Alignment.topLeft,
                        child: Center(
                          child: Stack(
                            children: [
                              Positioned(
                                left: -9,
                                child: Obx(() => IconButton(
                                      icon: lController.flag.value
                                          ? Icon(
                                              Icons.check_box_rounded,
                                              color: theamColor,
                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank_outlined,
                                              color: theamColor,
                                            ),
                                      onPressed: () {
                                        lController.flag.toggle();
                                      },
                                    )),
                                //  Checkbox(
                                //   activeColor: Color(Helper.getHexToInt("#11CBA1")),
                                //   onChanged: (bool rest) {
                                //     setState(() {
                                //       rememberme = rest;
                                //     });
                                //   },
                                //   value: rememberme,
                                // ),
                              ),
                              Positioned(
                                left: 35,
                                top: 15,
                                child: Text(
                                  text('remember_me'),
                                  style: GoogleFonts.poppins(fontSize: 14, color: Color(Helper.getHexToInt("#6F6F6F"))),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 15,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(ResetPassword());
                                  },
                                  child: Text(
                                    text('forgot_password'),
                                    style: GoogleFonts.poppins(fontSize: 14, color: Color(Helper.getHexToInt("#6F6F6F"))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                        1.6,
                        CustomButton(
                          loadingenabled: true,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11CAA1")), Color(Helper.getHexToInt("#11E3A1"))]),
                            ),
                            child: Center(
                              child: Text(
                                text('Log In'),
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          onclick: () async {
                            print("Container clicked");
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => HomePage()));

                            FocusScope.of(context).requestFocus(new FocusNode());
                            if (_formkey.currentState.validate()) {
                              var email = emailController.text;
                              var password = passwordController.text;
                              if (email.isEmpty) {
                                Get.snackbar(text('please_enter_valid_email'), "", snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
                                return;
                              }
                              if (password.isEmpty) {
                                Get.snackbar(text('please_enter_valid_password'), "",
                                    snackPosition: SnackPosition.BOTTOM, colorText: Colors.red, backgroundColor: Colors.green.shade200);
                                return;
                              }

                              print(email + "" + password);

                              try {
                                if (lController.flag.value ?? false) {
                                  print("set: Login");
                                  await box.write('rememberMePrefUserName', email);
                                  await box.write('rememberMePrefPassword', password);
                                } else {
                                  await box.remove('rememberMePrefUserName');
                                  await box.remove('rememberMePrefPassword');
                                }
                                await lController.login(email, password);
                              } catch (e) {
                                Fluttertoast.showToast(msg: e.toString(), textColor: Colors.red);
                              }

                              // }
                            }

                            print("Container was tapped");
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      1.7,
                      Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: <Widget>[
                              Text(
                                text('don_t_have_an_account_yet'),
                                style: GoogleFonts.poppins(fontSize: 16, color: Color(Helper.getHexToInt("#6F6F6F"))),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    print("Container clicked");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp(
                                                  heroTag: "assets/group4320.png",
                                                )));
                                  },
                                  child: new Container(
                                    child: Text(
                                      text('register'),
                                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(Helper.getHexToInt("#11C4A1"))),
                                    ),
                                  )),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      1.7,
                      GestureDetector(
                          onTap: () {
                            // print("Container clicked");
                            // Get.to(TestPage());
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) => HomePaget()));
                          },
                          child: new Container(
                            child: Text(
                              text('or_signup_with'),
                              style: TextStyle(fontSize: 16, color: Color(Helper.getHexToInt("#6F6F6F"))),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FadeAnimation(
                              1.9,
                              CustomButton(
                                loadingenabled: _isLoading,
                                btncolor: Colors.blue,
                                onclick: () {
                                  print("facebook");

                                  _loginWithFacebook();
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Helper.getHexToInt("#4267B2"))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/facebook.png",
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        // Icon(Icons.facebook,color: Color(Helper.getHexToInt("#4267B2"))),
                                        Text(
                                          "Facebook",
                                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: FadeAnimation(
                              2,
                              CustomButton(
                                loadingenabled: true,
                                btncolor: Colors.red,
                                onclick: () {
                                  print("google");
                                  _handleSignIn();
                                  // lController.handleSignIn();
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Helper.getHexToInt("#EB4132"))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/google.png",
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Google",
                                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Platform.isIOS
                        ? FadeAnimation(
                            1.9,
                            CustomButton(
                              loadingenabled: true,
                              btncolor: Colors.red,
                              onclick: () async {
                                if (await SignInWithApple.isAvailable()) {
                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  print(credential.email);
                                  final oauthCredential = OAuthProvider("apple.com").credential(
                                    idToken: credential.identityToken,
                                  );

                                  await FirebaseAuth.instance.signInWithCredential(oauthCredential);
                                  await FirebaseAuth.instance.currentUser.updateDisplayName(
                                    (credential.givenName ?? '') + ' ' + (credential.familyName ?? ''),
                                  );
                                  await setcurentAppleUser();
                                  Get.offAll(HomePage());
                                  print(credential);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Helper.getHexToInt("#000000"))),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/apple.png",
                                        color: Colors.white,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Sign in with Apple",
                                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // SignInWithAppleButton(
                            //   height: 50,
                            //   onPressed: () async {
                            //     if (await SignInWithApple.isAvailable()) {
                            //       final credential = await SignInWithApple
                            //           .getAppleIDCredential(
                            //         scopes: [
                            //           AppleIDAuthorizationScopes.email,
                            //           AppleIDAuthorizationScopes.fullName,
                            //         ],
                            //       );
                            //       print(credential.email);
                            //       final oauthCredential =
                            //           OAuthProvider("apple.com").credential(
                            //         idToken: credential.identityToken,
                            //       );

                            //       await FirebaseAuth.instance
                            //           .signInWithCredential(oauthCredential);
                            //       await FirebaseAuth.instance.currentUser
                            //           .updateProfile(
                            //               displayName: ((credential.givenName ??
                            //                       '') +
                            //                   ' ' +
                            //                   (credential.familyName ?? '')));
                            //       await setcurentAppleUser();
                            //       Get.offAll(HomePage());
                            //       print(credential);
                            //     }

                            //     // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                            //     // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                            //   },
                            // ),
                          )
                        : Container(),
                    SizedBox(
                      height: Platform.isIOS ? 20 : 0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 80,
            ),
          ])
        ]));
  }

  Widget buidTextfield3(String hintText, TextEditingController scontroller, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Container(
            // height: MediaQuery.of(context).size.height,

            child: TextField(
              // style: scontroller == text('password')
              //     ? GoogleFonts.poppins(
              //         color: Colors.grey,
              //         fontSize: 15,
              //         letterSpacing: 0,
              //       )
              //     : GoogleFonts.poppins(
              //         color: Colors.grey,
              //         fontSize: 15,
              //         letterSpacing: 15,
              //       ),
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 15,
                letterSpacing: 0,
              ),
              onChanged: (_) {
                setState(() {});
              },
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(
                    Helper.getHexToInt("#6F6F6F"),
                  ),
                  letterSpacing: 0,
                ),

                focusedBorder: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: theamColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // border: InputBorder.none,
                disabledBorder: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: theamColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  gapPadding: 5,
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: theamColor),
                ),

                prefixIcon: hintText == text('email')
                    ? Icon(
                        Icons.email,
                        color: Color(Helper.getHexToInt("#BDBDBD")),
                      )
                    : hintText == text('password')
                        ? Icon(
                            Icons.lock,
                            color: Color(Helper.getHexToInt("#BDBDBD")),
                          )
                        : null,

                suffixIcon: hintText == text('password')
                    ? IconButton(
                        // onPressed: () {
                        //   // lController.pflag.toggle();

                        // },
                        onPressed: _toggleVisibility,
                        icon: _isHidden
                            ? Icon(
                                Icons.visibility_off,
                                color: theamColor,
                              )
                            : Icon(
                                Icons.visibility,
                                color: theamColor,
                              ),
                      )
                    : hintText == text('email')
                        ? RegExp(emailRegx).hasMatch(scontroller.text.trim())
                            ? Icon(
                                Icons.check_circle,
                                // Icons.radio_button_unchecked,
                                color: Color(Helper.getHexToInt("#00E9A3")),
                              )
                            : null
                        : null,
              ),
              controller: scontroller,
              obscureText: hintText == text('password') ? _isHidden : false,
            ),
          )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      print("login");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      // handleSignOut();
      currentUser = await googleSignIn.signIn();

      if (currentUser != null) {
        handleSignOut();
      }
      if (lController.currentUser != null) {
        handleSignOut();
      }
      if (currentUser != null) {
        final GoogleSignInAuthentication googleAuth = await currentUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential);
        await setcurentgoogleUser();
        Get.offAll(HomePage());
      } else {
        Navigator.of(context).pop();
      }
      //await Geolocator().getCurrentPosition();
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: error.message);
      print(error);
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: error.toString());
    } finally {}
  }

  // LoginManager.getInstance().logInWithReadPermissions(this, Arrays.asList("public_profile"));
  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void _loginWithFacebook() async {
    setState(() {
      _isLoading = true;
    });
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    switch (result.status) {
      case LoginStatus.success:
        _onFacebookSuccess(result);
        break;
      case LoginStatus.cancelled:
        Get.snackbar(result.message, "");
        print('Login cancelled by the user.');
        break;
      case LoginStatus.failed:
        Get.snackbar(result.message, "");
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.message}');

        break;

      case LoginStatus.operationInProgress:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        break;
    }
  }

  void _onFacebookSuccess(LoginResult result) async {
    final accessToken = result.accessToken;
    print(accessToken.token);
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=first_name,email,picture&access_token=${accessToken.token}'));
    if (graphResponse.statusCode == 200 && graphResponse.body.isNotEmpty) {
      final profile = jsonDecode(graphResponse.body);
      print(profile);
      setState(() {
        name = profile['first_name'];
        image = profile['picture']['data']['url'];
      });

      SharedPreferences shp = await SharedPreferences.getInstance();
      var id = profile['id'];

      await lController.facebookUser(profile['email'], name, id);
      // int uid = int.parse(currentUser.id) ;
      // shp.setInt("id", int.parse(id));
      shp.setString("name", name);
      shp.setString("email", profile['email']);
      shp.setString("profileImage", image);
      shp.setInt("islogin", 1);
      shp.setString("checkLogin", "a");
      setState(() {
        _isLoading = false;
      });
    }
    // lController.pimage.value = currentUser.photoUrl;
    print(name);

    print(image);

    print('''
       Logged in!

       Token: ${accessToken.token}
       User id: ${accessToken.userId}
       Expires: ${accessToken.expires}
       Permissions: ${accessToken.grantedPermissions}
       Declined permissions: ${accessToken.declinedPermissions}
       ''');
  }

  // ignore: unused_element
  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> handleSignOut() async {
    googleSignIn.disconnect();
  }

// Future<Null> appleLogIn() async {
//   if (await applesignin.AppleSignIn.isAvailable()) {
//     final applesignin.AuthorizationResult result =
//         await applesignin.AppleSignIn.performRequests([
//       applesignin.AppleIdRequest(requestedScopes: [
//         applesignin.Scope.email,
//         applesignin.Scope.fullName
//       ])
//     ]);
//     switch (result.status) {
//       case applesignin.AuthorizationStatus.authorized:
//         print(
//           String.fromCharCodes(result.credential.identityToken),
//         );
//         break; //All the required credentials
//       case applesignin.AuthorizationStatus.error:
//         print("Sign in failed: ${result.error.localizedDescription}");
//         break;
//       case applesignin.AuthorizationStatus.cancelled:
//         print('User cancelled');
//         break;
//     }
//   } else {
//     print('Apple SignIn is not available for your device');
//   }
// }
}

// e7:61:78:2b:d5:fb:90:90:03:8a:43:61:35:3d:e8:88:59:8e:ef:54
// E7:61:78:2B:D5:FB:90:90:03:8A:43:61:35:3D:E8:88:59:8E:EF:54

// FA:A5:74:2E:92:DD:FB:D4:97:75:C1:F7:D1:DD:44:14:4E:09:36:82

// SHA-256: 1F:B0:AD:25:A9:82:51:BF:B8:78:D1:9D:D7:82:4A:EB:75:B5:DC:C7:BA:FF:A1:64:1E:BD:32:89:76:F2:06:C7
