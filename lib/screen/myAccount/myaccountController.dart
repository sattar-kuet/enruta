import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString username = "".obs;
  RxString phone = "".obs;
  RxString id = "".obs;

  @override
  void onInit() {
    getUserInfo();
    super.onInit();
  }

  getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    name.value = sp.getString("name")!;
    email.value = sp.getString("email")!;
    username.value = sp.getString("username")!;
    phone.value = sp.getString("phone")!;
    id.value = sp.getInt("id").toString();
  }
}
