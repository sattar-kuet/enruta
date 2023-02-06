import 'package:enruta/api/service.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  // ignore: deprecated_member_use
  var allOrderList = List<OrderModel>().obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getAllOrder();
  }

  void getAllOrder() async {
    isLoading(true);
    SharedPreferences pre = await SharedPreferences.getInstance();
    var id = pre.getInt("id");
    // int pId = int.parse(id);
    print('pid is $id');
    try {
      allOrderList.value = [];

      await Service.getAllOrder(id).then((values) {
        allOrderList.value = values.orders.toList();
        print(allOrderList.length);
        isLoading(false);
      });
    } finally {}
  }

  Future<AllOrderModel> getOrder() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var id = pre.getInt("id");
    // int pId = int.parse(id);
    print('pid is $id');
    return Service.getAllOrder(id);
  }
}
