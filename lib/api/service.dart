import 'dart:convert';

import 'package:enruta/model/Response.dart';
import 'package:enruta/model/addReview.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/menu_model_data.dart';
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/model/popular_shop.dart';
import 'package:enruta/model/review_model.dart';
import 'package:enruta/model/sendOrder.dart';
import 'package:enruta/screen/orerder/orderDetailsModel.dart';
import 'package:enruta/screen/promotion/offerModel.dart';
import 'package:enruta/screen/voucher/voucher_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/menu_items_model.dart';
import '../model/search_item.dart';

class Service {
  static const String url = 'https://enruta.itscholarbd.com/api/v2/categories';

  static const String urls = 'https://enruta.itscholarbd.com/api/v2/nearByShop';

  static const String getAllorderUrl = 'https://enruta.itscholarbd.com/api/v2/myOrder';

  static const String getCurentOrderUrl = 'https://enruta.itscholarbd.com/api/v2/myCurrentOrder';

  static const String getPopularShopUrl = 'https://enruta.itscholarbd.com/api/v2/nearByPopularShop';
  static const String getSearchUrl = 'https://enruta.itscholarbd.com/api/v2/search';

  static const String placeOrderurls = 'https://enruta.itscholarbd.com/api/v2/placeOrder';
  static const String us = 'https://enruta.itscholarbd.com/api/v2/getProductByShopId';
  static const String baseUrl = 'https://enruta.itscholarbd.com/api/v2/';

  static const String base_url = 'https://enruta.itscholarbd.com';

  static const String toggleFavorite = 'https://enruta.itscholarbd.com/api/v2/toggleFavourite';

  static const String getOffersUrl = 'https://enruta.itscholarbd.com/api/v2/getOffers';

  static const String getOrderDetailsApi = 'https://enruta.itscholarbd.com/api/v2/getOrderByOrderId';

  static const String getVoucherUrl = 'https://enruta.itscholarbd.com/api/v2/getVoucherByUserId';
  static const String addorupdaterivew = 'https://enruta.itscholarbd.com/api/v2/addORupdateReview';
  static const String banner = "http://enruta.itscholarbd.com/api/v2/banner";

  static Future<Respons> addorupdateReview(AddReview model) async {
    var data = json.encode(model.toJson());
    print(data);
    try {
      final response = await http.post(Uri.parse(addorupdaterivew),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);
      if (200 == response.statusCode) {
        print(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<int> getTimebyOrder(int orderid) async {
    print("get time called");
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}getDeliveryTimeByOrderId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'id': orderid,
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        return int.parse(response.body);
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Respons> getcategory() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (200 == response.statusCode) {
        final Respons respons = responsFromJson(response.body);
        return respons;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // ignore: missing_return
  static Future<MenuModel> menulist(var x) async {
    if (x != null) {
      try {
        // print(uri);

        // final response = await http.get(uri, headers: headers);

        final response = await http.post(
          Uri.parse("https://enruta.itscholarbd.com/api/v2/getProductByShopId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'shop_id': x.toString(),
          }),
        );

        print('Jainish get menu api error ${x.toString()}');

        print('Jainish get menu api error ${response.statusCode}');

        if (response.statusCode == 200) {
          print("Jainish get menu api error ${response.body}");
          final MenuModel model = menuModelFromJson(response.body);
          print("Jainish get menu api error $model");
          // print(model.products.toList());
          //print(response.body);
          return model;
        } else {
          print("get menu api error");
          return null;
        }
      } catch (e) {
        print('Jainish get menu api error ${e.toString()}');
        return null;
      }
    }
  }

  // static Future<MenuModel> getMenuList(var x) async {
  //   try {
  //     // print(x);
  //     var uri = Uri.parse(base_url);
  //     uri = uri.replace(queryParameters: <String, String>{'shop_id': '2'});

  //     final response = await http.get(
  //       uri,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final MenuModel model = menuModelFromJson(response.body);
  //       // print(model.products.toList());

  //       return model;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  static Future<NearByPlace> getNearByPlace(int userid, var lat, var long) async {
    String lats = lat.toString();
    String lon = long.toString();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userid.toString(),
          'lat': lats,
          'lng': lon,
        }),
      );
      if (response.statusCode == 200) {
        return NearByPlace.fromJson(jsonDecode(response.body));
      } else {
        print("NULLSSSSS");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<OfferModel> getAllOffers() async {
    try {
      final response = await http.post(
        Uri.parse(getOffersUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{}),
      );

      if (response.statusCode == 200) {
        print("//////////////////////////////" + response.body);
        return OfferModel.fromJson(jsonDecode(response.body));
      } else {
        print("data null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<OrderDetailsModel> getOrderDetails(int id) async {
    print("order id : $id");
    try {
      final response = await http.post(
        Uri.parse(getOrderDetailsApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"id": '$id'}),
      );
      if (response.statusCode == 200) {
        print(response.body);
        print(response.statusCode);
        return OrderDetailsModel.fromJson(jsonDecode(response.body));
      } else {
        print("data null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<CuponModel> getCuppons(
      // ignore: non_constant_identifier_names
      String shop_id,
      // ignore: non_constant_identifier_names
      String user_id,
      String code) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "applyCode"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"shop_id": '$shop_id', "user_id": '$user_id', "code": '$code'}),
      );
      if (response.statusCode == 200) {
        return CuponModel.fromJson(response.body);
      } else {
        print("data null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<VoucherModel> getAllVoucher(var id) async {
    try {
      final response = await http.post(
        Uri.parse(getVoucherUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"user_id": '$id'}),
      );
      if (response.statusCode == 200) {
        return VoucherModel.fromJson(jsonDecode(response.body));
      } else {
        print("data null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ReviewModel> getreview(int id) async {
    try {
      var url = baseUrl + "getReviews";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'shop_id': id.toString(),
        }),
      );
      print("review body ${response.body}");
      if (response.statusCode == 200) {
        return ReviewModel.fromJson(jsonDecode(response.body));
      } else {
        print("riview api status eror");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<NearByPlace> createAlbum(int id, var lat, var lo) async {
    // String json = '{"user_id": $id, "lat": $lat, "lng": $lo}';
    try {
      String json = '{"user_id": $id, "lat": $lat, "lng": $lo}';
      print("=========Near By Details" + json);
      final response = await http.post(Uri.parse(urls),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json);
      print('SUCCESSFUL: $response');
      if (response.statusCode == 200) {
        print('SUCCESSFUL: ');

        return NearByPlace.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create album.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  static Future<AllOrderModel> getAllOrder(int id) async {
    String json = '{"user_id": $id}';
    print(json);

    final response = await http.post(Uri.parse(getAllorderUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);

    if (response.statusCode == 200) {
      return AllOrderModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get order List.');
    }
  }

  static Future<AllOrderModel> getCurentOrder(int userId) async {
    String json = '{"user_id": $userId}';
    print(json);
    final response = await http.post(Uri.parse(getCurentOrderUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
    dynamic data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return AllOrderModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get order List.');
    }
  }

  static Future<PopularShop> getPopularShop(var userId, var lat, var lo, {List shop_ids}) async {
    try {
      // g.Get.put(TestController());
      print("Get popular whenComplete");
      // final tController = g.Get.find<TestController>();
      String json = '{"user_id": $userId, "lat": $lat, "lng": $lo,"shop_ids": $shop_ids}';
      // tController.spin.value = true;
      print("User id $json");

      print('Jainish ******************* $json');
      print('Jainish ******************* $getPopularShopUrl');

      final response = await http.post(Uri.parse(getPopularShopUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json);

      //print(response.body);
      print("${response.statusCode} response status");
      print("**************" + response.body);

      if (response.statusCode == 200) {
        // tController.spin.value = false;

        var p = PopularShop.fromJson(jsonDecode(response.body));
        print('Jainish ******************* ${p.data.length}');
        print(p);
        return p;
      } else {
        throw Exception('Failed to get order List.');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> sendorder(SendOrderModel order) async {
    var jsonData = order.toJson();
    var a = json.encode(order);
    print("to json");
    print(jsonData);
    print(a);

    final response = await http.post(Uri.parse(placeOrderurls),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: a);

    if (response.statusCode == 200) {
      return response;
    } else {
      print(response);
      print(Exception());
      throw Exception(response.statusCode);

      // throw Exception('Order submint field');
    }
  }

  static Future<http.Response> setToggleFavorite(var userid, var shop, var status) async {
    print('settoggele favorite in $userid   $shop  $status');

    final response = await http.post(Uri.parse(toggleFavorite),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"user_id": userid.toString(), "shop_id": shop.toString(), "status": status}));

    if (response.statusCode == 200) {
      print('ADD TO FAVOURITE');
      return response;
    } else {
      throw Exception('Order submint field');
    }
  }

  Future<SearchItem> getSearchMethod(String search) async {
    print('getSearch start');

    var response = await http.post(Uri.parse(getSearchUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({"param": search, "user_id": 309, "lat": 21.221699988798132, "lng": 72.83830001950264}));

    if (response.statusCode == 200) {
      SearchItem searchItem = SearchItem.fromJson(jsonDecode(response.body));
      return searchItem;
    } else {
      throw Exception('Order submint field ${response.body}');
    }
  }

  /// ?????????????????????????/ get menu
  Future<MenuItemsModel> getMenuList(shopId) async {
    var response = await http.post(Uri.parse("https://enruta.itscholarbd.com/api/v2/getProductByShopId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({"shop_id": shopId}));

    if (response.statusCode == 200) {
      print("data : ${response.body}");
      MenuItemsModel searchItem = MenuItemsModel.fromJson(jsonDecode(response.body));
      return searchItem;
    } else {
      throw Exception('getMenuList<<<<<<<<<<< field ${response.body}');
    }
  }
}
