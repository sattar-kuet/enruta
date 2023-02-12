import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/screen/voucher/voucher_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherController extends GetxController {
  Rx<Voucher?> voucher = Voucher().obs;
  var isLoading = true.obs;
  CartController ccont = Get.find();

  var code = "".obs;
  var discount = 0.obs;
  var minimum = 0.obs;
  var vdata = 0.obs;
  @override
  void onInit() {
    getvoucher();
    super.onInit();
  }

  void getvoucher() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var id = pre.getInt("id");
    print('id is $id');

    isLoading(true);
    //await Future.delayed(Duration(seconds: 3));
    await Service.getAllVoucher(id).then((values) {
      voucher.value = values!.voucher;
      code.value = voucher.value!.code!;
      discount.value = voucher.value!.discount!;
      minimum.value = voucher.value!.minOrder!;
      vdata.value = 1;
    }).whenComplete(() => isLoading(false));
  }

  void advoucher(bool isFromBootm) {
    String miniprice = minimum.value.toString();

    // ignore: unused_local_variable
    var pk = miniprice.toDouble();

    ccont.shopvoucher.value = discount.value;
    ccont.voucherMinimum.value = minimum.value;
    ccont.voucherName.value = voucher.value!.code!;

    ccont.totalCalculate();
    if (isFromBootm == false) {
      Get.back();
    }
  }
}
