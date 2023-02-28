import 'package:enruta/api/service.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/category_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
// static const String url = 'https://app.enrutard.com/api/v2/categories';

  // ignore: deprecated_member_use
  RxList<Category> category = <Category>[].obs;

  final address = ''.obs;
  var userlat = ''.obs;
  final userlong = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // getmenulist();
    _getLocation();
  }

  void getmenulist() async {
    await Future.delayed(Duration(seconds: 1));
    Service.getcategory().then((values) {
      // todos = values.categories.toList();
      if (values != null) {
        category.value = values.categories!.toList();
      }
    });
  }

  _getLocation() async {
    await Future.delayed(Duration(seconds: 1));
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final formattedAddress = await Helper().getNearbyPlaces(position.latitude, position.longitude);

    userlat.value = '${position.latitude}';
    userlong.value = '${position.longitude}';

    address.value = formattedAddress;
    address(formattedAddress);
  }
}
