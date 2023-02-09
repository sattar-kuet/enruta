import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/screen/searchResult/searchResult.dart';
import 'package:get/get.dart';

import '../../api/service.dart';
import '../../model/search_item.dart';

class SearchController extends GetxController {
  // ignore: deprecated_member_use
  RxList<Datum> cartLists = <Datum>[].obs;

  // ignore: deprecated_member_use
  RxList<Datum> filterData = <Datum>[].obs;

  // ignore: deprecated_member_use
  RxList<Datum> datum = <Datum>[].obs;
  var filterlength = 0.obs;

  // ignore: deprecated_member_use
  var tempfilterData = <Datum>[];

  // ignore: deprecated_member_use
  RxList<Datum> itemList = <Datum>[].obs;
  RxBool filter1 = false.obs;
  RxBool filter2 = false.obs;
  RxBool filter3 = false.obs;
  RxBool filter4 = false.obs;
  RxBool filter5 = false.obs;
  RxBool filter6 = false.obs;
  RxBool filter7 = false.obs;
  RxBool filter8 = false.obs;
  RxBool filter9 = false.obs;

  @override
  void onInit() {
    super.onInit();
    cartLists.value = Get.find<TestController>().nearbyres.toList();
  }

  void clearFilter() {
    filter1.value = false; //currenty open
    filter2.value = false; //offering discount
    filter3.value = false; //free delevery
    filter4.value = false;
    filter5.value = false;
    filter6.value = false;
    filter7.value = false;
    filter8.value = false;
    filter9.value = false;
  }

  void searchData(String name) {
    final tController = Get.put(TestController());

    if (itemList.isEmpty == true) {
      tController.nearbycat.forEach((u) {
        itemList.add(u);
      });
    } else {
      itemList.clear();
      tController.nearbycat.forEach((u) {
        itemList.add(u);
      });
    }

    filterData.value = [];
    var searchData = name.length > 0 ? true : false;

    if (searchData) {
      for (var item in itemList) {
        String pname = item.name.toString().toLowerCase();
        print(name);
        if (pname.contains(name)) {
          filterData.add(item);
        }
      }
      filterData.toSet().toList();
      filterlength.value = filterData.length;
      Get.to(SearchResult());
    }
  }

  void filter(String name) {
    final tController = Get.put(TestController());
    filterData.clear();

    if (tController.nearbycat.isEmpty == true) {
      tController.nearbycat.forEach((u) {
        itemList.add(u);
      });
    } else {
      itemList.clear();
      tController.nearbycat.forEach((u) {
        itemList.add(u);
      });
    }

    filterData.value = [];
    var searchData = name.length > 0 ? true : false;

    if (searchData) {
      // itemList
      //     .where((item) => item.deliveryCharge.toString().toLowerCase() == '0');
      for (var item in itemList) {
        //  String pname = item.deliveryCharge.toString().toLowerCase();
        // print('LENGTH == ${item.deliveryCharge}');

        if (filter1.value == true) {
          //&& filter3.value == false
          // print('FIRST');
          //SHOP OPEN
          if (item.shopStatus == 2) {
            filterData.add(item);
            filterData.toSet().toList();
            // }
          }
        }
        if (filter2.value == true) {
          //filter1.value == false && filter3.value == true
          // print('SECOND');

          if (item.discountOffer != 0) {
            filterData.add(item);
            filterData.toSet().toList();
            // }
          }
        }
        if (filter3.value == true) {
          //filter1.value == true &&
          // print('THIRD');
          //FREE DELEVERy
          if (item.deliveryCharge == 0) {
            // && item.shopStatus == 2
            filterData.add(item);
            filterData.toSet().toList();
            // }
          }
        }

        // if (item.deliveryCharge == 0) {
        //   // print(item.name);
        //   filterData.add(item);
        //   filterData.toSet().toList();
        //   // }
        // }
        print('OUT from filter');
        filterData.toSet().toList();
        filterlength.value = filterData.length;
        Get.off(SearchResult());
      }
    }
  }

  ///search by char
  RxBool isSearching = false.obs;
  List<SearchData>? searchDataList = [];

  Future getSearch(
    String search,
  ) async {
    isSearching.value = true;
    searchDataList!.clear();
    update();

    await Service().getSearchMethod(search).then((value) {
      if (value.status == 1) {
        searchDataList = value.data;
        isSearching.value = false;
      } else {
        isSearching.value = false;
        Get.snackbar("not found", "there's no data found", colorText: red);
      }
      update();

      print("${value.data}");
    }).catchError((onError) {
      // Get.snackbar("not found", "there's ${onError.toString()}}",
      //     colorText: red, duration: Duration(seconds: 10));
      print("${onError.toString() +onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()+onError.toString()}");
      isSearching.value = false;
      update();
    });

    update();
  }
}
