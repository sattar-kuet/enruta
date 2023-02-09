import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/model/Product_model.dart';
import 'package:get/get.dart';

import 'cart_model.dart';

class ProductController extends GetxController {
  CartController cController = Get.find();

  Rx<Product?> _product = Rx<Product?>(null);
  Product? get product {
    return _product.value;
  }

  addProduct() {
    try {
      // ignore: unused_local_variable
      CartItemModel cartItem = cController.cartItems.firstWhere((cartItem) {
        return cartItem.product!.id == this.product!.id;
      });
    } catch (error) {
      // appController.cartItems.add(CartItemModel(
      //   product: this.product,
      //   quantity: 1,
      // ));
    }
    Get.back();
  }
}
