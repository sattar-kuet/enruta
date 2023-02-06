import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/orderdetailsmodel.dart';
//import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/model/popular_shop.dart';
import 'package:enruta/screen/myMap/mapController.dart';
import 'package:enruta/screen/orderStutas/orderStatus.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/style.dart';
import 'orderDetailsModel.dart';

class CurentOrderController extends GetxController {
  final tController = Get.put(TestController());
  // ignore: deprecated_member_use
  var allCurentOrderList = List<OrderModel>().obs;
  // ignore: deprecated_member_use
  var polularShopList = List<Datums>().obs;
  var curentOrder = OrderModel().obs;
  var pageLoader = false.obs;

  var gtotal = 0.0;

  @override
  void onInit() async {
    await getPopularOrder();
    await getCurentOrder();

    super.onInit();
  }

  void getCurentOneOrder() {}

  // MyMapController  mapController =   Get.find();
  final cCont = Get.put(MyMapController());

  var isLoading = false.obs;
  var getorderStatusforindivisualLoading = false.obs;
  var detailsModel = OrderDetailsModel().obs;
  var order = Order().obs;
  var orderall = <Order>[].obs;
  var address = ''.obs;
  var deleveryTime = 0.obs;

  Future<void> getorderStatus(int id) async {
    isLoading(true);
    try {
      await Service().getOrderDetails(id).then((values) async {
        if (values != null) {
        
          detailsModel.value.order = values.order;
          deleveryTime.value =
              await Service.getTimebyOrder(detailsModel.value.order.id);

          //order.value = values.order;
          await getpointerLocation(values.order.lat, values.order.lng);
        }
        // cCont.getShopLocation(order.value.lat, order.value.lng);
        //   cCont.getshopsLocation(order.value.lat, order.value.lng);
        //gettotal();
      });
    } finally {
      isLoading(false);
    }
  }

  Future<void> getorderStatusforindivisual(int id) async {
    OrderDetailsPageModel odp;
    int time;
    try {
      getorderStatusforindivisualLoading(true);
      await Service().getOrderDetails(id).then((values) async {
        //
        OrderDetailsModel oModerAll = values;
        time = await Service.getTimebyOrder(values.order.id);
        getpointerLocation(oModerAll.order.lat, oModerAll.order.lng);
        odp = new OrderDetailsPageModel(details: oModerAll, time: time);
        print("details = ${odp.details.order.orderFrom}");
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
    String a = order.value.price;
    var as = double.parse(a);

    var b = order.value.deliveryCharge;
    var c = order.value.voucher;
    var d = order.value.coupon;

    var e = order.value.offer;
    gtotal = as + b - c - d - e;
  }

  Future<List<OrderModel>> getCurentOrder() async {
    isLoading(true);
    SharedPreferences spreferences = await SharedPreferences.getInstance();

    var id = spreferences.getInt("id");
    print("id---" + id.toString());
    try {
      allCurentOrderList.value = [];

      await Service.getCurentOrder(id).then((values) async {
        allCurentOrderList.value = values.orders.toList();
    //    Get.snackbar("ordersList", "ordersList ordersListordersList ${values.orders.length}", colorText: red);

        // ignore: invalid_use_of_protected_member
        // if (allCurentOrderList.value.length > 0) {
        //   curentOrder.value =
        //       // ignore: invalid_use_of_protected_member
        //       allCurentOrderList.value[allCurentOrderList.value.length - 1];
        // }
        print(allCurentOrderList.length);
        await getorderStatus(curentOrder.value.id);
        isLoading(false);
      });
    } finally {}
    //await Future.delayed(Duration(seconds: 3));

    return allCurentOrderList.value.toList();
  }

  getPopularOrder() async {
    isLoading(true);
    SharedPreferences spreferences = await SharedPreferences.getInstance();

    var id = spreferences.getInt("id");
    var lat = tController.userlat.value;
    var lo = tController.userlong.value;
    try {
      allCurentOrderList.value = [];
      if (lat > 0) {
        await Future.delayed(Duration(seconds: 1));
        Service.getPopularShop(id, lat, lo).then((values) {
          if (!values.isNull) {
            polularShopList.value = values.data.toList();
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

  Future getpointerLocation(String lat, String lng) async {
    if (lat.isEmpty && lng.isEmpty) {
      return;
    }
    double lg = double.tryParse(lng);
    double la = double.tryParse(lat);
    print("call api");
    print(la);
    //await Future.delayed(Duration(seconds: 1));
    // ignore: unused_local_variable
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordi = new Coordinates(la, lg);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordi);
    // var add = await Geocoder.google(your_API_Key).findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    address.value = first.addressLine;
  }

  getShopAddress(String lat, String lng) async {
    var la = double.parse(lat);
    var lg = double.parse(lng);
    print(la);
    print(lg);

    final coordinates = new Coordinates(la, lg);
    print(lg);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(lg);
    var first = addresses.first;
    address.value = first.addressLine;
    print(address.value);
  }
}
