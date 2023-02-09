import 'package:enruta/api/service.dart';
import 'package:enruta/model/addReview.dart';
import 'package:enruta/model/category_model.dart';
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/model/popular_shop.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestController extends GetxController {
  static const String url = 'https://enruta.itscholarbd.com/api/v2/categories';

  RxList<Category> category = <Category>[].obs;

  RxList<Datum> nearbyres = <Datum>[].obs;
  RxList<Datum?> nearFavList = <Datum>[].obs;

  // ignore: deprecated_member_use
  RxList<Datum> nearbycat = <Datum>[].obs;

  // ignore: deprecated_member_use
  RxList<Datums> polularShopList = <Datums>[].obs;
  var sendtime = "".obs;

  var shopid = 0.obs;
  Rx<int>? orderCompletedShop;

  final address = ''.obs;
  final addressType = ''.obs;
  final addressTypeTitle = ''.obs;
  var userlat = 0.0.obs;
  var userlong = 0.0.obs;
  var locationpermision = false.obs;
  var st = 0.obs;
  RxBool spin = false.obs;
  RxBool spinFav = false.obs;
  var isLoading = true.obs;
  var orderiscoming = true.obs;

  @override
  void onInit() {
    super.onInit();
    // getmenulist();
    // getLocation();
  }

  RxBool filter1 = true.obs;
  RxBool filter2 = true.obs;
  RxBool filter3 = true.obs;
  RxBool filter4 = true.obs;
  RxBool filter5 = true.obs;
  RxBool filter6 = true.obs;
  RxBool filter7 = true.obs;
  RxBool filter8 = true.obs;
  RxBool filter9 = true.obs;

  void getmenulist() async {
    try {
      isLoading(true);
      await Service.getcategory().then((values) {
        // todos = values.categories.toList();
        category.value = values!.categories!.toList();
        print("category.toList");
        // print(category.toList);
        // print(category.length);
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  completeOrder(int shopid) async {
    SharedPreferences spreferences = await SharedPreferences.getInstance();
    spreferences.setInt("OrderCompletedShop", shopid);
    print("Complete Order called");
  }

  addrivew(List<int?> shopid, double rating, String comment, int? orderId) async {
    SharedPreferences spreferences = await SharedPreferences.getInstance();
    var id = spreferences.getInt("id");
    for (var item in shopid) {
      var model = new AddReview(userId: id, shopId: item, rating: rating, comment: comment, orderId: orderId);
      await Service.addOrUpdateReview(model);
    }
  }

  getPopularShops([var shpos]) async {
    orderiscoming(true);
    var lat = userlat.value;
    var lo = userlong.value;

    try {
      // allCurentOrderList.value = [];
      if (lat > 0) {
        isLoading(true);

        await Service.getPopularShop(23, lat, lo, shopIds: shpos).then((values) {
          if (values != null) {
            polularShopList.value = values.data!.toList();
          }
          st.value = values.status!;
          print("$shpos from getpopularshop ");

          polularShopList.value = values.data!.toList();
          //print(polularShopList[1]);

          if (polularShopList.length > 0) {
            // curentOrder.value = polularShopList.value[0];
          }
        }).whenComplete(() => orderiscoming(false));
      }
    } catch (e) {
      print(e);
    } finally {
      orderiscoming(false);
      isLoading(false);
    }
  }

  Future<void> getnearByPlace() async {
    try {
      spin(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var a = prefs.getString("shopid");
      if (a != null) {
        shopid.value = int.parse(a);
      }

      int userid = prefs.getInt("id") ?? 0;
      print(userid);
      var lat = userlat.value;
      var lo = userlong.value;
      if (lat == 0.0 || lo == 0.0) {
        await getLocation(isRequiredCall: false);
        lat = userlat.value;
        lo = userlong.value;
      }
      await Service.createAlbum(
        userid,
        lat,
        lo,
      ).then((values) {
        spin(false);
        if (values != null) {
          st.value = values.status!;
          nearbyres(values.data!);

          print("nearby $nearbyres");
          print("Sortin");
          nearbyres.forEach((d) {
            if (d.shopId == shopid.value) {
              sendtime.value = d.time!;
              print("XXXX: ${d.time}");
            }
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      spin(false);
    }
  }

  Future<void> getFavList() async {
    try {
      spinFav(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int userid = prefs.getInt("id") ?? 93;
      print(userid);
      var lat = userlat.value;
      var lo = userlong.value;
      await Service.createAlbum(userid, lat, lo).then((values) {
        if (values != null) {
          print("nearby $nearFavList");
          print("Sortin");
          nearFavList = values.data!.where((e) => e.favorite!).toList().obs;
        }
      });
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
    } finally {
      spinFav(false);
    }
  }

  Future<void> getLocation({bool isRequiredCall = true}) async {
    try {
      GetStorage box = GetStorage();
      Coordinates? coordinates;
      Position position;
      if (box.read("selectLet") != null && box.read("selectLet") != 'null') {
        userlat.value = double.parse(box.read("selectLet"));
        userlong.value = double.parse(box.read("selectLng"));
        print("----${userlat.value}");
        print(userlong.value);
        coordinates = new Coordinates(userlat.value, userlong.value);
        print("-------${userlat.value}");

        print("Got from storage");
      } else {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          locationpermision.value = true;
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          userlat.value = position.latitude;
          userlong.value = position.longitude;
          coordinates = new Coordinates(position.latitude, position.longitude);
          print("Got from Onilne");
        } else {}
      }

      if (coordinates != null) {
        await Future.delayed(Duration(milliseconds: 500));
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        address.value = '${first.addressLine}';
        address(first.addressLine);
        if (box.read('selectAddressType') != null && box.read('selectAddressType') != 'null') {
          addressType(box.read('selectAddressType'));
        }
        if (box.read('selectAddressTypeTitle') != null && box.read('selectAddressTypeTitle') != 'null') {
          addressTypeTitle(box.read('selectAddressTypeTitle'));
        }
      }

      //print(address);
      if (isRequiredCall) {
        await getnearByPlace();
        await getPopularShops();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
//Popular and nearby issue//

///////////////////*****************************//////////////////////// */
/////////////////////***************************//////////////////////
