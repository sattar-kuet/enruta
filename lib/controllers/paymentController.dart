import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PaymentController extends GetxController {
  var totalPayment = 0.0.obs;

  var paymentType = 1.obs;

  var selectedMethod = 1.obs;

  var myFocusNode = FocusNode();

  

  @override
  void onInit() {
    // getSelectedMothodType();
    super.onInit();
  }

  selectMethodType(int a) {
    GetStorage box = GetStorage();
    box.write('methodType', a);
  }

  // getSelectedMothodType() {
  //   GetStorage box = GetStorage();
  //   selectedMethod.value = box.read("methodType");
  // }
}
