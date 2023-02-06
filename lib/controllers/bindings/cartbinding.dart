import 'package:enruta/controllers/menuController.dart';
import 'package:get/get.dart';

class CartBind extends Bindings {
  @override
  void dependencies() {
    print("cartbaind");
    Get.lazyPut<MenuController>(() => MenuController());

    
  }
}
