import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/paymentController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/payment_method_list_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodListView extends StatelessWidget {
  const PaymentMethodListView(
      {Key key,
      this.paymentData,
      this.animationController,
      this.animation,
      this.paymentSelection,
      this.callback})
      : super(key: key);
  final bool paymentSelection;
  final VoidCallback callback;
  final PaymentMethodListData paymentData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    final pmController = Get.put(PaymentController());
    return Obx(() {
      return Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        decoration: BoxDecoration(
            color: pmController.selectedMethod.value == 2
                ? cardbackgroundColor
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 2,
                color: (paymentSelection == false)
                    ? Colors.white
                    : pmController.selectedMethod.value == 2
                        ? Color(Helper.getHexToInt("#11C4A1"))
                        : Color(Helper.getHexToInt("#F0F0F0")))),
        child: InkWell(
          onTap: () {
            pmController.selectedMethod.value = 2;

            Get.find<CartController>().setpayment("Master Card");

            pmController.paymentType.value = 2;

            if (pmController.totalPayment.value != 0) Get.back();
          },
          child: Stack(
            children: [
              Positioned(
                top: 10,
                right: 20,
                bottom: 10,
                child: Container(
                  height: 30,
                  width: 51,
                  child: Image.asset(paymentData.imagePath),
                ),
              ),
              Positioned(
                top: 24,
                left: 16,
                child: Center(
                  child: Container(
                    child: Text(
                      paymentData.paymentTitle,
                      style: TextStyle(
                          fontFamily: "TTCommonsr",
                          fontSize: 13,
                          color: Color(Helper.getHexToInt("#8D8D8D"))),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 42,
                  left: 16,
                  child: Center(
                    child: Text(
                      paymentData.paymentDetails,
                      style: TextStyle(
                          fontFamily: "TTCommonsr",
                          fontSize: 17,
                          color: Color(Helper.getHexToInt("#8D8D8D"))),
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
