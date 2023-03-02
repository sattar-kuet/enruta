import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/orderdetailsmodel.dart';

import 'package:enruta/model/popular_shop.dart';
import 'package:enruta/screen/myMap/mapController.dart';
import 'package:enruta/screen/orderStutas/orderStatus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'orderDetailsModel.dart';

class CurrentOrderController extends GetxController {
  final tController = Get.put(TestController());

  // ignore: deprecated_member_use
  RxList<OrderModel> allCurrentOrderList = <OrderModel>[].obs;

  // ignore: deprecated_member_use
  RxList<Datums> polularShopList = <Datums>[].obs;
  Rx<OrderModel> currentOrder = OrderModel().obs;

  // late final List<OrderModel> currentOrder
  var pageLoader = false.obs;

  var gtotal = 0.0;

  @override
  void onInit() async {
    await getPopularOrder();
    await getCurrentOrder();

    super.onInit();
  }

  void getCurentOneOrder() {}

  // MyMapController  mapController =   Get.find();
  final cCont = Get.put(MyMapController());

  var isLoading = false.obs;
  var getorderStatusforindivisualLoading = false.obs;
  Rx<OrderDetailsModel> detailsModel = OrderDetailsModel().obs;
  Rx<Order> order = Order().obs;
  RxList<Order> orderall = <Order>[].obs;
  var address = ''.obs;
  var deleveryTime = 0.obs;

  Future<void> getorderStatus(int? id) async {
    try {
      await Service().getOrderDetails(id).then((values) async {
        if (values != null) {
          detailsModel.value.order = values.order;
          deleveryTime.value = (await Service.getTimebyOrder(detailsModel.value.order!.id))!;

          //order.value = values.order;
          await getPointerLocation(values.order!.lat!, values.order!.lng);
        }
        // cCont.getShopLocation(order.value.lat, order.value.lng);
        //   cCont.getshopsLocation(order.value.lat, order.value.lng);
        //gettotal();
      });
    } finally {}
  }

  Future<void> getorderStatusforindivisual(int? id) async {
    OrderDetailsPageModel odp;
    int? time;
    try {
      getorderStatusforindivisualLoading(true);
      await Service().getOrderDetails(id).then((values) async {
        //
        OrderDetailsModel oModerAll = values!;
        time = await Service.getTimebyOrder(values.order!.id);
        getPointerLocation(oModerAll.order!.lat!, oModerAll.order!.lng);
        odp = new OrderDetailsPageModel(details: oModerAll, time: time);
        print("details = ${odp.details!.order!.orderFrom}");
        Get.to(OrderStatus(odp));
        //order.value = values.order;

        // cCont.getShopLocation(order.value.lat, order.value.lng);
        //   cCont.getshopsLocation(order.value.lat, order.value.lng);
        //gettotal();
      });
    } catch (e) {
      return null;
    } finally {
      getorderStatusforindivisualLoading(false);
    }
    // await getpointerLocation(odp.details.order.lat, odp.details.order.lng);

    // isLoading(false);
  }

  // double get totalPrice =>
  //     cartList.fold(0, (sum, item) => sum + item.price * item.qty);
  void gettotal() {
    final a = order.value.price?.toDouble() ?? 0.0;

    var b = order.value.deliveryCharge!;
    var c = order.value.voucher!;
    var d = order.value.coupon!;

    var e = order.value.offer!;
    gtotal = a + b - c - d - e;
  }

  Future<List<OrderModel>> getCurrentOrder() async {
    isLoading(true);
    SharedPreferences spreferences = await SharedPreferences.getInstance();

    var id = spreferences.getInt("id");
    print("id---" + id.toString());
    try {
      allCurrentOrderList.value = [];

      await Service.getCurrentOrder(id).then((values) async {
        allCurrentOrderList.value = values.orders!.toList();
        await getorderStatus(currentOrder.value.id);
      });
    } finally {
      isLoading(false);
    }
    //await Future.delayed(Duration(seconds: 3));

    return allCurrentOrderList.toList();
  }

  getPopularOrder() async {
    isLoading(true);
    SharedPreferences spreferences = await SharedPreferences.getInstance();

    var id = spreferences.getInt("id");
    var lat = tController.userlat.value;
    var lo = tController.userlong.value;
    try {
      allCurrentOrderList.value = [];
      if (lat > 0) {
        await Future.delayed(Duration(seconds: 1));
        Service.getPopularShop(id, lat, lo).then((values) {
          if (values != null) {
            polularShopList.value = values.data!.toList();
          }

          // if(polularShopList.value.length>0){
          //   curentOrder.value = polularShopList.value[0];
          // }
          print(polularShopList.length);
          isLoading(false);
        });
      }
    } finally {}
  }

  Future getPointerLocation(String lat, String? lng) async {
    if (lat.isEmpty && lng!.isEmpty) {
      return;
    }
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    address.value = await Helper().getNearbyPlaces(position.latitude, position.longitude);
  }
}
