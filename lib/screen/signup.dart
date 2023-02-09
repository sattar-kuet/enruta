import 'dart:convert';
import 'dart:io';

import 'package:enruta/Animation/FadeAnimation.dart';
import 'package:enruta/api/api.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/loginController/loginController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/login.dart';
import 'package:enruta/widgetview/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUp extends StatefulWidget {
  final heroTag;

  // final foodName;
  // final foodPrice;

  SignUp({this.heroTag});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  // var selectedCard = 'WEIGHT';

  String name = '', image;

  // ignore: unused_field
  String _message = 'Log in/out by pressing the buttons below.';
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  final LoginController lController = Get.put(LoginController());
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  GoogleSignInAccount currentUser;

  // ignore: unused_field
  PickedFile _imageFile;
  var imageF;
  bool imagepassed = false;

  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();

  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // margin: EdgeInsets.only(bottom: 20),
          // padding: EdgeInsets.only(bottom: 20),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 0.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, colors: [Color(Helper.getHexToInt("#11C7A1")), Color(Helper.getHexToInt("#11E4A1"))])),
                  ),
                  Positioned(
                      top: 150.0,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                              color: Colors.white),
                          height: MediaQuery.of(context).size.height - 100.0,
                          width: MediaQuery.of(context).size.width)),

                  // profileImage(),
                  Positioned(
                    top: 90.0,
                    left: (MediaQuery.of(context).size.width / 2) - 60.0,
                    child: Container(
                      decoration: BoxDecoration(),
                      child: profileImage(),
                    ),
                  ),
                  Positioned(
                    top: 220.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 20,
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
                                FadeAnimation(
                                  1.3,
                                  buildTextfield3(text('name'), nameController),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeAnimation(1.3, buildTextfield3(text('address'), addressController)),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeAnimation(1.3, buildTextfield3(text('email'), emailController)),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeAnimation(1.3, buildTextfield3(text('password'), passwordController)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            1.6,
                            CustomButton(
                              loadingenabled: true,
                              onclick: () async {
                                print("Container clicked");
                                FocusScope.of(context).requestFocus(new FocusNode());
                                if (_formkey.currentState.validate()) {
                                  var name = nameController.text;
                                  var address = addressController.text;
                                  var email = emailController.text;
                                  var password = passwordController.text;

                                  if (name.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: text('please_input_your_name'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        // backgroundColor: Colors.red,
                                        textColor: Colors.red,
                                        fontSize: 12.0);
                                    return;
                                  }
                                  if (email.isEmpty || !(email.contains('@') && email.contains('.'))) {
                                    Fluttertoast.showToast(
                                        msg: text('please_input_valid_email'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        // backgroundColor: Colors.red,
                                        textColor: Colors.red,
                                        fontSize: 12.0);
                                    return;
                                  }
                                  if (password.isEmpty || password.length < 6) {
                                    Fluttertoast.showToast(
                                        msg: text('please_input_valid_password'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        // backgroundColor: Colors.red,
                                        textColor: Colors.red,
                                        fontSize: 12.0);
                                    return;
                                  }

                                  setState(() {
                                    message = 'please wait....';
                                  });
                                  print(email + "" + password);
                                  // var rsps = await sendForm("url",
                                  //     {
                                  //       'name': name,
                                  //       'email': email,
                                  //       'password': password,
                                  //       'address': address,
                                  //
                                  //     }, {'avatar': imageF});

                                  // var r = rsps ;
                                  // print("res-1 "+ r);

                                  var rsp = await registration(name, address, email, password, !imagepassed ? null : imageF.path);
                                  // var rsps=  await signUpWithImage(name, address, email, password,imageF);
                                  // print("\n\nstatus:"+rsp['status'].toString());
                                  if (rsp["status"] == 0) {
                                    // print("\n\n"+rsp["status_text"]);

                                    Get.snackbar(rsp["status_text"], "", colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
                                  } else if (rsp["status"] == 1) {
                                    Get.snackbar(rsp["status_text"], "", snackPosition: SnackPosition.BOTTOM);
                                    lController.login(email, password);
                                  }

                                  // if (rsp["status"] == 1) {
                                  //   Fluttertoast.showToast(
                                  //       msg: "Registration  success",
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.BOTTOM,
                                  //       timeInSecForIosWeb: 1,
                                  //       textColor: Colors.black,
                                  //       fontSize: 12.0);
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => LoginPage()));
                                  // } else {
                                  //   Fluttertoast.showToast(
                                  //       msg: "Something wrong ",
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.BOTTOM,
                                  //       timeInSecForIosWeb: 1,
                                  //       // backgroundColor: Colors.red,
                                  //       textColor: Colors.red,
                                  //       fontSize: 16.0);
                                  // }
                                  //
                                  // print(r);
                                }
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter, colors: [Color(Helper.getHexToInt("#11CAA1")), Color(Helper.getHexToInt("#11E3A1"))]),
                                ),
                                child: Center(
                                  child: Text(
                                    text('signup'),
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.7,
                            Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      text('have_an_account_already'),
                                      style: GoogleFonts.poppins(color: Color(Helper.getHexToInt("#6F6F6F"))),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          print("Container clicked");
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                        },
                                        child: new Container(
                                          child: Text(
                                            text('login'),
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
                            Text(
                              text('or_signup_with'),
                              style: GoogleFonts.poppins(fontSize: 16, color: Color(Helper.getHexToInt("#6F6F6F"))),
                            ),
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
                                    btncolor: Colors.blue,
                                    loadingenabled: true,
                                    onclick: () {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      // Get.to(ProductDetails());
                                      print("facebook");
                                      _signupWithFacebook();
                                    },
                                    child: Container(
                                      height: 50,
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
                                            Text(
                                              "Facebook",
                                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Platform.isIOS
                              ? FadeAnimation(
                                  1.9,
                                  SignInWithAppleButton(
                                    onPressed: () async {
                                      if (await SignInWithApple.isAvailable()) {
                                        final credential = await SignInWithApple.getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                        );
                                        final oauthCredential = OAuthProvider("apple.com").credential(
                                          idToken: credential.identityToken,
                                        );
                                        print(credential);
                                        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
                                        await FirebaseAuth.instance.currentUser
                                            .updateDisplayName((credential.givenName ?? '') + ' ' + (credential.familyName ?? ''));
                                        await setcurentAppleUser();
                                        Get.offAll(HomePage());
                                      }

                                      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                    },
                                  ),
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
                    height: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget buildTextField(String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Container(
              height: 60,
              padding: EdgeInsets.all(2),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: hintText == text('email')
                      ? Icon(Icons.email)
                      : hintText == text('password')
                          ? Icon(Icons.lock)
                          : null,
                  suffixIcon: hintText == text('password')
                      ? IconButton(
                          onPressed: _toggleVisibility,
                          icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                        )
                      : null,
                ),
                obscureText: hintText == text('password') ? _isHidden : false,
              )),
        ],
      ),
    );
  }

  // Widget profileImage() {
  //   return Center(
  //     child: Stack(children: <Widget>[
  //       CircleAvatar(
  //         radius: 80.0,
  //         backgroundImage: _imageFile == null
  //             ? AssetImage("assets/images/group4320.png")
  //             : FileImage(File(_imageFile.path)),
  //       ),
  //       Positioned(
  //         bottom: 0.0,
  //         right: 0.0,
  //         child: InkWell(
  //           onTap: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: ((builder) => bottomSheet()),
  //             );
  //           },
  //
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  Widget profileImage() {
    return Center(
        child: ClipOval(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheet()),
          );
          print("Container clicked");
        },

        // child:CircleAvatar(
        //   radius: 80.0,
        //   backgroundImage: _imageFile == null
        //       ? AssetImage("assets/images/group4320.png")
        //       : FileImage(File(_imageFile.path)),
        // )
        child: Container(
          height: 120,
          width: 120,
          color: Colors.grey.shade200,
          child: CircleAvatar(
            radius: 80.0,
            backgroundImage: !imagepassed ? AssetImage("assets/images/group4320.png") : FileImage(File(imageF.path)),
          ),

          // Image.asset(
          //   "assets/images/group4320.png",
          //   width: 120.0,
          //   height: 120.0,
          //   fit: BoxFit.contain,
          // ),
        ),
      ),
    ));
  }

  Widget buildTextfield3(String hintText, TextEditingController scontroller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Color(Helper.getHexToInt("#11CAA1")),
                      // ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 15,
                      letterSpacing: 0,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(color: Color(Helper.getHexToInt("#6F6F6F"))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                              : hintText == text('name')
                                  ? Icon(
                                      Icons.person,
                                      color: Color(Helper.getHexToInt("#BDBDBD")),
                                    )
                                  : hintText == text('address')
                                      ? Icon(Icons.location_on)
                                      : null,
                      suffixIcon: hintText == text('password')
                          ? IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                            )
                          : hintText == text('email')
                              ? Icon(
                                  RegExp(emailRegx).hasMatch(scontroller.text.trim()) ? Icons.check_circle : Icons.radio_button_unchecked,
                                  // Icons.radio_button_unchecked,
                                  color: Color(Helper.getHexToInt("#00E9A3")),
                                )
                              : null,
                    ),
                    controller: scontroller,
                    obscureText: hintText == text('password') ? _isHidden : false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Widget imageProfile() {
  //   return Center(
  //     child: Stack(children: <Widget>[
  //       CircleAvatar(
  //         radius: 80.0,
  //         backgroundImage: _imageFile == null
  //             ? AssetImage("assets/profile.jpeg")
  //             : FileImage(File(_imageFile.path)),
  //       ),
  //       Positioned(
  //         bottom: 20.0,
  //         right: 20.0,
  //         child: InkWell(
  //           onTap: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: ((builder) => bottomSheet()),
  //             );
  //           },
  //           child: Icon(
  //             Icons.camera_alt,
  //             color: Colors.teal,
  //             size: 28.0,
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  Widget bottomSheet() {
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
                takePhoto(ImageSource.camera);
              },
              label: Text(
                text('camera'),
              ),
            ),

            // ignore: deprecated_member_use
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text(
                text('gallery'),
              ),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    // ignore: unused_local_variable
    // ignore: unused_local_variable
    SharedPreferences pref = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    var image = await ImagePicker().pickImage(
      source: source,
    );
    // final pickedFile = await _picker.getImage(
    //   source: source,
    // );
    // var pic = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        imagepassed = true;
        imageF = File(image.path);
        print('IMAGE PATH =$imageF');
      } else {
        imagepassed = true;
        print('No image selected.');
      }
      // // _imageFile = pickedFile;
      // // imageF= image;
      // imageF = File(image.path);
      Navigator.pop(context);
    });
  }

  /*Future<Null> faceBookLogin() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    //await Geolocator().getCurrentPosition();
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webOnly;
    // final result = await facebookSignIn.logInWithReadPermissions(['email']);
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    // await facebookSignIn.logIn(['email']);
    print(result.errorMessage);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print(accessToken.token);
// Create a credential from the access token
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        final graphResponse =
            await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=first_name,email,picture&access_token=${accessToken.token}'));
        final profile = jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          name = profile['first_name'];
          image = profile['picture']['data']['url'];
        });

        SharedPreferences shp = await SharedPreferences.getInstance();
        var id = profile['id'];

        // int uid = int.parse(currentUser.id) ;
        // shp.setInt("id", int.parse(id));
        shp.setString("name", name);
        shp.setString("email", profile['email']);
        shp.setString("profileImage", image);
        shp.setInt("islogin", 1);
        shp.setString("checkLogin", "a");
        await lController.facebookUser(profile['email'], name, id);

        // lController.pimage.value = currentUser.photoUrl;
        print(name);

        print(image);

        print('''
       Logged in!

       Token: ${accessToken.token}
       User id: ${accessToken.userId}
       Expires: ${accessToken.expires}
       Permissions: ${accessToken.permissions}
       Declined permissions: ${accessToken.declinedPermissions}
       ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).pop();
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        Get.snackbar(result.errorMessage, "");
        Navigator.of(context).pop();
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }*/

  void _signupWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    switch (result.status) {
      case LoginStatus.success:
        _onFacebookSuccess(result);
        break;
      case LoginStatus.cancelled:
        Navigator.of(context).pop();
        print('Login cancelled by the user.');
        break;
      case LoginStatus.failed:
        Get.snackbar(result.message, "");
        Navigator.of(context).pop();
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
    final profile = jsonDecode(graphResponse.body);
    print(profile);
    setState(() {
      name = profile['first_name'];
      image = profile['picture']['data']['url'];
    });

    SharedPreferences shp = await SharedPreferences.getInstance();
    var id = profile['id'];

    // int uid = int.parse(currentUser.id) ;
    // shp.setInt("id", int.parse(id));
    shp.setString("name", name);
    shp.setString("email", profile['email']);
    shp.setString("profileImage", image);
    shp.setInt("islogin", 1);
    shp.setString("checkLogin", "a");
    await lController.facebookUser(profile['email'], name, id);

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
      print(error);
    } finally {}
  }

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

  Future<void> handleSignOut() async {
    googleSignIn.disconnect();
  }
}
