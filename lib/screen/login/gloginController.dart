import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GLoginController extends GetxController {
  final googleSignIn = GoogleSignIn();
  var _isSigningIn = false.obs;

  @override
  void onInit() {
    _isSigningIn.value = false;
    super.onInit();
  }

  bool get isSigningIn => _isSigningIn.value;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn.value = isSigningIn;
    update();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      print("---------$googleAuth");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
