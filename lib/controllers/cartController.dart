// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:math';

import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/loginController/loginController.dart';
import 'package:enruta/controllers/menuController.dart' as mc;
import 'package:enruta/controllers/suggestController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/Product_model.dart';

import 'package:enruta/model/sendOrder.dart';
import 'package:enruta/screen/cart/cart_model.dart';
import 'package:enruta/screen/homePage.dart';

import 'package:enruta/screen/voucher/voucher_model.dart';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as h;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/menu_items_model.dart';

class CartController extends GetxController {
  var position = 0.obs;
  var qty = 0.obs;
  var vat = 0.0.obs;
  var deliveryCharge = 0.0.obs;
  var grandTotal = 0.obs;
  var shoptype = "assets/images/type0.jpg".obs;
  var imageloader = false.obs;
  var menucover = ''.obs;
  var shopname = "".obs;
  var deleverytime = "".obs;

  // ignore: deprecated_member_use
  RxList<Product?> cartList = <Product?>[].obs;

  // var paymentOption = ''.obs;
  // ignore: non_constant_identifier_names
  var shop_category = ''.obs;
  var deliverOption = ''.obs;

  // ignore: non_constant_identifier_names
  var user_id = ''.obs;
  var order = SendOrderModel();
  var newOrder = 0.obs;
  var cupontype = 0.obs;

  // final menuController = Get.put(MenuController()).obs;
  // ignore: deprecated_member_use
  RxList<Product> menuItems = <Product>[].obs;

  // ignore: deprecated_member_use
  RxList<Product> menuItemsTemp = <Product>[].obs;
  var categoryName = ''.obs;

  // ignore: deprecated_member_use
  RxList<Product?> cartLists = <Product>[].obs;

  var deliveryType = 0.obs;
  var orderpassed = 0.obs;
  var ordertypetapped = false.obs;
  var selectaddresstapped = false.obs;
  var logCont = Get.put(LoginController());
  RxList<CartItemModel> items = RxList<CartItemModel>([]);

  // var cartL = List<Product>().obs;

  RxList<CartItemModel> cartItems = RxList<CartItemModel>([]);

  int get count => cartList.length;
  var subTprice = 0.0.obs;
  var tvatprice = 0.0.obs;
  var grandTotalprice = 0.0.obs;
  var tax = 0.obs;

  var cuppon = 0.0.obs;
  var cuponholder = 0.0.obs;
  var cupponMinimum = 0.obs;

  //for voucher
  var shopvoucher = 0.obs;
  var voucher = 0.obs;
  var voucherName = ''.obs;

  var voucherMinimum = 0.obs;

  var isLoding = false.obs;
  var submitorderstatus = false.obs;

  //for offer
  var discount = 0.obs;
  var minimumSpent = 0.obs;
  var offer = 0.obs;

  var checkOffer = 0.obs;
  var underValue = 0.obs;
  var cuponerrortxt = "".obs;

  double get totalPrice => cartList.fold(0, (sum, item) => sum + item!.price * item.qty);

  double get vatPrice => totalPrice * vat.value / 100;

  double get gTotal {
    var a = totalPrice + vatPrice + deliveryCharge.value - cuppon.value - voucher.value - discount.value;
    int fac = pow(10, 2) as int;
    a = (a * fac).round() / fac;
    return a;
  }

  // voucherMinimum.value>totalPrice?

  int? get countqty => cartList.first!.qty;
  var selectAddress = "".obs;
  var selectAddressType = "".obs;
  var selectAddressTitle = "".obs;
  var selectLat = "".obs;
  var selectLng = "".obs;
  final Rx<String?> shopid = ''.obs;

  var paymentoption = "Cash on delivery".obs;
  GetStorage box = GetStorage();

  @override
  void onInit() {
    totalcalculate();
    GetStorage box = GetStorage();
    if (shopid.value == null) {
      checkshopid();
    }

    if (box.read("selectAddress") != null) {
      selectAddress.value = box.read("selectAddress");
    }
    if (box.read("selectAddressType") != null) {
      selectAddressType.value = box.read("selectAddressType");
    }
    if (box.read("selectAddressTypeTitle") != null) {
      selectAddressTitle.value = box.read("selectAddressTypeTitle");
    }
    if (box.read("selectLet") != null) {
      selectLat.value = box.read("selectLet");
      selectLng.value = box.read("selectLng");
    }
    if (box.read("paymentoption") != null) {
      paymentoption.value = box.read("paymentoption");
    }

    getsuggetItems();
    print("Menu items fn called");

    List? storedCartList = GetStorage().read<List>('cartList');
    // shopid.value = GetStorage().read('shopid');

    if (storedCartList?.isNotEmpty ?? false) {
      cartList = storedCartList!.map((e) => Product.fromJson(e)).toList().obs;
    }
    if (cartList.length < 0) {
      box.remove("shopid");
      print("remove");
    }
    ever(cartList, (dynamic _) {
      GetStorage().write('cartList', cartList.toList());
    });
    removeShopID();

    super.onInit();
  }

  // ignore: deprecated_member_use
  RxList<Product?> suggetItems = <Product>[].obs;
  var isLoading = true.obs;

  void getsuggetItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopid.value = prefs.getString('shopid')!;
    print("shopid");
    shopid.value = box.read("shopid");
    print(shopid.value);
    try {
      suggetItems.assignAll([]);
      isLoading(true);
      // await Future.delayed(Duration(seconds: 1));
      await Service.menulist(shopid.value).then((val) {
        if (val != null) {
          suggetItems.assignAll(val.products!.toList());
          print(suggetItems.length);
        }
      });
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  void suggestUpdate() {
    List<int?> tmp = [];
    for (int i = 0; i < cartList.length; i++) {
      tmp.add(cartList[i]!.id);
    }
    suggetItems.assignAll(menuItems.value);

    for (int j = 0; j < tmp.length; j++) {
      suggetItems.removeWhere((item) => item!.id == tmp[j]);
    }
    print("menuitems lenght = ${suggetItems.length}, in cart =$tmp");
  }

  void additemtocarts(Product? item, String? shop, double? vats, double? deliveryC) async {
    print("shopid" '$shop');
    print(vats);
    print("deliveryC");
    print("ADD ITEM TO CARD CALLED");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopid.value = prefs.getString('shopid') ?? '';
    print("shop id is " '${shopid.value}');

    if (shopid.value == null) {
      prefs.setString('shopid', shop!);
      prefs.setDouble("vat", vats!);
      prefs.setDouble("deliveryCharge", deliveryC!);
      vat.value = vats;
      deliveryCharge.value = deliveryC;
      print("............working so far......");
      productadded(item!, shop);
    } else if (shop != null && shopid.value != shop) {
      Get.defaultDialog(title: "", content: Text("Your previous cart will be cleared if you proceed with this shop"), actions: [
        // ignore: deprecated_member_use
        ElevatedButton(
            child: Text("Cancel"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              Get.back();
            }),
        // ignore: deprecated_member_use
        ElevatedButton(
            child: Text("Ok"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theamColor,
            ),
            onPressed: () {
              // ignore: deprecated_member_use
              cartList.assignAll(<Product>[].obs);
              prefs.setString('shopid', shop);
              prefs.setDouble("vat", vats!);
              prefs.setDouble("deliveryCharge", deliveryC!);
              voucher.value = 0;
              voucherName.value = '';
              cuppon.value = 0.0;
              prefs.setString("categoryName", Get.find<mc.MenuController>().categoryName.value);
              Get.find<SuggestController>().getsuggetItems();
              Get.find<SuggestController>().removeitemfromlist(item!.id);

              vat.value = vats;
              deliveryCharge.value = deliveryC;
              shopid.value = shop;
              totalcalculate();
              Get.back();
              productadded(item, shop);
            })
      ]);
    } else if (shopid.value == shop) {
      print("*********from Add to cart ********* ${item!.selectcolor}");
      productadded(item, shop);
    }
  }

  void getplist() {
    print(".....plist called...");

    // ignore: unused_local_variable
    List? storedCartList = GetStorage().read<List>('cartList');

    // try {
    //   storedCartList.map((e) => print("abc"));
    // } catch (e) {
    //   print("eror abc");
    // }

    // if (storedCartList.length > 0) {
    //   // ignore: deprecated_member_use
    //   cartList = List<Product>().obs;

    //   cartList = storedCartList.map((e) => Product.fromJson(e)).toList().obs;
    //   // storedCartList.map((e) => Product.fromJson(e)).toList().obs;

    //   print(cartList.toList());
    // }
    ever(cartList, (dynamic _) {
      GetStorage().write('cartList', cartList.toList());
    });
  }

  void productadded(Product item, String? shop) async {
    print(item.selectcolor);

    print("Product Added Called............ + color : ${item.toJson().values}");

    GetStorage box = GetStorage();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // checkshopId(shop);
    // prefs.getString("shopid");
    // if (shopid.value != null) {
    var check = false;
    if (cartList.length == 0) {
      Get.snackbar(
        "",
        "item added",
        colorText: Colors.white,
      );
      cartList.add(item);

      print("cart len 0");
      print(jsonEncode(cartList));
      box.write("shopcategory", categoryName.value);
      box.write("cartList", cartList);
      //Get.find<SuggestController>().removeitemfromlist(item.id);
      var a = box.read("shopcategory");
      print("sssssss" + a);
      totalcalculate();

      getplist();
      check = true;
      print("when 0 ");
    } else {
      //cartList.add(item);
      print("cart len >0");

      for (var i = 0; i < cartList.length; i++) {
        if (item.id != 0 && item.id == cartList[i]!.id) {
          cartList.value[i]!.qty = item.qty;
          // cartList.value[i].selectcolor = item.selectcolor;
          // cartList.value[i].selectSize = item.selectSize;
          // Get.snackbar(" add", "item alrady added");
          Get.snackbar(
            "Cart",
            "Added to cart",
            colorText: Colors.white,
          );
          check = true;
          return;
        }
      }
      print(jsonEncode(cartList));
    }
    print("value value value" + '${cartList.value}');
    if (check == false) {
      cartList.add(item);

      print("cart check false");
      print(jsonEncode(cartList));

      box.write("cartList", Get.find<CartController>().cartList);
      //Get.find<SuggestController>().removeitemfromlist(item.id);
      totalcalculate();
      getplist();
      Get.snackbar(
        " add",
        "item added",
        colorText: Colors.white,
      );
    }
  }

  Future<bool> isInChart(String shopId, Product item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shop = prefs.getString('shopid');
    bool result = false;
    if (shop != null && int.parse(shop) == int.parse(shopId) && cartList.length != 0) {
      for (Product? p in cartList) {
        if (item.id != 0 && item.id == p!.id) {
          if (p.qty == item.pqty.value) {
            result = true;
          }
        }
      }
    }
    print("Shop:" + shopId + " Item:" + item.title! + " :$result");
    return result;
  }

  /// /// ///

  void addtocart(Product item, String s) {
    GetStorage box = GetStorage();
    shopid.value = box.read("shopid");
    print(shopid.value);
    if (shopid == null) {
      box.write('shopid', s);
      print(shopid);
    }

    if (shopid.value != s) {
      print("trurkjkj");

      Get.defaultDialog(title: "", content: Text("Your previous cart will be cleared if you proceed with this shop"), actions: [
        // ignore: deprecated_member_use
        ElevatedButton(
          child: Text("Cancel"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
            child: Text("Ok"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theamColor,
            ),
            onPressed: () {
              GetStorage().remove('cartList');
              Get.back();
              print(box.read("shopid"));
              cartList.value = box.read('cartList');
              // ignore: deprecated_member_use
              cartList.value = <Product>[];
            }),
      ]);
    } else {
      print(shopid);

      checkshopId(s);
      var check = false;
      if (cartList.length == 0) {
        Get.snackbar(
          " add",
          "item added",
          colorText: Colors.white,
        );
        cartList.add(item);

        box.write("cartList", Get.find<CartController>().cartList);
        print("when 0");
      }
      for (var i = 0; i < cartList.length; i++) {
        // print(cartList[i].id + item.id);
        if (item.id == cartList[i]!.id) {
          Get.snackbar(
            " add",
            "item alrady added",
            colorText: Colors.white,
          );
          // print(cartList[i].id + item.id);
          check = true;
          // return;
        }
      }
      if (check == false) {
        cartList.add(item);

        box.write("cartList", Get.find<CartController>().cartList);
        Get.snackbar(
          " add",
          "item added",
          colorText: Colors.white,
        );
      }
    }
  }

  bool checkshopId(String? id) {
    shopid.value = GetStorage().read('shopid');
    return true;
  }

  void removeShopID() {
    print(cartList.length);
    if (cartList.length == 0) {
      GetStorage box = GetStorage();
      box.remove("shopid");
      // print("sdfsdfsdf");
      // print(box.read("shopid"));
    }
  }

  void addtocarts(Product? item) {
    var check = false;
    if (cartList.length == 0) {
      cartList.add(item);

      box.write("cartList", Get.find<CartController>().cartList);
      print("when 0");
    }
    for (var i = 0; i < menuItems.value.length; i++) {
      if (menuItems.value[i].id == item!.id) {
        menuItems.value[i].pqty.value = item.qty!;
        // menuItems.value[i].selectcolor = item.selectSize;
        // // ignore: invalid_use_of_protected_member
        // menuItems.value[i].selectSize = item.selectcolor;
      }
    }

    for (var i = 0; i < cartList.length; i++) {
      print(cartList[i]!.id! + item!.id!);
      if (item.id == cartList[i]!.id) {
        print(cartList[i]!.id! + item.id!);
        check = true;
        // return;
      }
    }
    if (check == false) {
      cartList.add(item);

      box.write("cartList", Get.find<CartController>().cartList);
    }
  }

  Future<void> applyVoucher(String code) async {
    print("Shop id = $shopid from apply voucher $code");
    underValue.value = 0;
    CuponModel a = (await Service.getCuppons('${shopid.value}', user_id.value, code))!;

    try {
      if (a.offer != null) {
        cupponMinimum.value = a.offer!.minimum_spent!;
        cupontype.value = a.offer!.type!;
        if (cupontype.value == 1) {
          cuponholder.value = a.offer!.discount!.toDouble();
          print("c holder type 0 ${cuponholder.value}");
        } else if (cupontype.value == 2) {
          cuponholder.value = (subTprice * a.offer!.discount!) / 100;
          print("c holder type 1 ${cuponholder.value}");
        }
      }
    } catch (e) {
      cuponerrortxt.value = "wrong coupon code";

      checkOffer.value = 1;
      cuponholder.value = 0;
      cuppon.value = 0.0;
      print("check offer ${checkOffer.value}");
      print(cuponerrortxt.value);
    }
  }

  void totalcalculate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var pk = voucherMinimum.value.toDouble();

    if (totalPrice > voucherMinimum.value) {
      voucher.value = shopvoucher.value;
    } else {
      voucher.value = 0;
    }
    if (totalPrice > cupponMinimum.value) {
      //checkOffer.value = 0;
    } else {
      cuponerrortxt.value = "Minimum ammout is $cupponMinimum";
      print(cuponerrortxt.value);
      cuponholder.value = 0;
      checkOffer.value = 1;
      cupponMinimum.value = 0;
    }

    if (totalPrice > minimumSpent.value) {
      discount.value = offer.value;
    } else {
      discount.value = 0;
    }

    subTprice.value = totalPrice;
    tvatprice.value = vatPrice;
    cuppon.value = cuponholder.value;
    if (cuppon.value != 0) {
      Get.snackbar(
        "Couppon",
        "Applied",
        colorText: Colors.white,
      );
    }
    grandTotalprice.value = gTotal;
    shopid.value = prefs.getString("shopid")!;
    print("totalcalculate working");
    print(vat.value);
  }

  void checkshopid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopid.value = prefs.getString("shopid")!;
  }

  setdeleveryAddress({var addressdetails, var lat, var long}) {
    // GetStorage box = GetStorage();
    // // print(a);
    // // print(b);
    // // print(c);
    // List<AddressModel> addresslist =
    //     box.read('addressList') ? box.read('addressList') : [];

    box.write("selectLet", lat.toString());
    box.write("selectAddressType", selectAddressType.value);
    box.write("selectAddressTypeTitle", selectAddressTitle.value);
    box.write("selectLng", long.toString());
    print("lat lang written finished");
    box.write("adress_list", addressdetails);

    selectAddress.value = addressdetails.toString();
    selectAddressType.value = selectAddressType.value.toString();
    selectAddressTitle.value = selectAddressTitle.value.toString();
    selectLat.value = lat.toString();
    selectLng.value = long.toString();

    print("from set -- ${selectAddress.value}");
    Get.put(TestController()).getLocation();

    Get.back();
  }

  setpayment(var payment) {
    GetStorage box = GetStorage();
    box.write("paymentoption", payment);
    paymentoption.value = payment;
  }

  setqty(Product p) {
    try {
      for (var i = 0; i < cartList.length; i++) {
        if (p.id == cartList[i]!.id) {
          cartList[i]!.qty = p.qty;
        }
      }
    } catch (e) {}
  }

  Future sendOrder(BuildContext context) async {
    try {
      isLoding.value = true;
      GetStorage box = GetStorage();
      SharedPreferences pre = await SharedPreferences.getInstance();
      SendOrderModel sendOrder = new SendOrderModel();
      //Item p = new Item();
      // var pList = List<Item>();
      List<Item> pList = [];

      user_id.value = pre.getString("email")!;

      // deliveryCharge.value = deliveryCharge.value;

      grandTotal.value = gTotal.round();

      shop_category.value = '${shopid.value}';

      tax.value = vatPrice.toInt();

      sendOrder.userId = pre.getInt("id");
      if (sendOrder.userId == null) {
        logCont.checklogin();
      }
      sendOrder.shopCategory = pre.getString("categoryName");
      // if(sendOrder.shopCategory.isEmpty){
      sendOrder.shopCategory = box.read("shopcategory");
      sendOrder.shopName = shopname.value;
      sendOrder.deliveryAddress = selectAddress.value;
      sendOrder.deliveryAddressType = selectAddressType.value;
      sendOrder.orderDeadline = Get.put(TestController()).sendtime.value;
      // }

      sendOrder.lat = selectLat.value.toString();

      sendOrder.lng = selectLng.value.toString();
      //print("cartListcartListcartListcartList" + cartList.value.toString());
      for (var item in cartList) {
        Item p = new Item();
        p.name = item!.title;
        p.productId = item.id;
        p.qty = item.qty;
        p.price = item.price.toDouble();
        p.size = item.selectSize != null ? item.selectSize : "";
        p.color = item.selectcolor != null ? item.selectcolor : "";

        pList.add(p);
        // order.items.add(item);
      }
      sendOrder.items = pList.toList();
      // print("cartListcartListcartListcartList" + sendOrder.items[0].color);
      // order.items = cartList.toList();

      // order.items = cartList.toList();

      sendOrder.tax = vatPrice;
      sendOrder.coupon = cuppon.value;
      sendOrder.voucher = voucher.value;
      sendOrder.offer = discount.value;

      sendOrder.deliveryCharge = deliveryCharge.value.toDouble();

      sendOrder.paymentOption = paymentoption.value.toString();
      sendOrder.deliveryTimeInMinutes = 10;

      sendOrder.deliveryAddress = deliveryType.value == 1 ? selectAddress.value : 'Pick UP';

      newOrder.value = 1;
      print(pList);

      //await Future.delayed(Duration(seconds: 1));
      print(sendOrder.toJson());

      if (sendOrder.paymentOption == "Master Card") {
        await purchaseItem("WxrXWgPR8wBItl1IH9XH2UJ2lDt", 10, "YYK0a5skhG5NX8jxuXHQUvnzN9W");
      }

      await Service.sendorder(sendOrder).then((values) {
        h.Response res = values;
        //String responseCode = res.statusCode.toString();
        if (res.statusCode == 200) {
          submitorderstatus.value = true;

          sendOrder = new SendOrderModel();
          pList = [];
          cartList.value = [];
          print(cartList);
          clearall();

          Navigator.pop(context);
        }

        print(res.body);
        print(res.body);

        // Get.back();
        isLoding.value = false;
      });
    } catch (e) {
      print(e);
      isLoding.value = false;
      rethrow;
    }
  }

  Future<void> purchaseItem(String gatewayToken, int amount, String paymentMethodToken) async {
    try {
      String url = "https://core.spreedly.com/v1/gateways/$gatewayToken/purchase.json";
      dynamic headers = {
        'Authorization': 'Basic NnhNbnZuc3lDbnJvWE1lTTZTMExlVFJiYndqOlQ2VkxETWQycG4zNWptNFkzNFUzcDVkdjlCSENpSUowVGRjVVh5WGRaNW9VYng0OW84aWt3WW5uenZrTDBRZUE=',
        'Content-Type': 'application/json'
      };

      dynamic response = await post(
        Uri.parse(
          url,
        ),
        headers: headers,
        body: json.encode({
          "transaction": {"payment_method_token": paymentMethodToken, "amount": amount * 100, "currency_code": "USD"}
        }),
      );
      dynamic createData = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      print("***************************************$createData");
      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Success Payment!");
      } else {
        throw createData["errors"][0]["message"];
      }
    } catch (e) {
      rethrow;
    }
  }

  // increment() => qty++;
  void gobackhomePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    shopid.value = prefs.getString('shopid')!;
    prefs.remove("shopid");
    shopid.value = prefs.getString('shopid')!;

    print(shopid.value.toString());

    Get.offAll(HomePage());
  }

  void clearall() {
    deliveryCharge.value = 0;

    grandTotal.value = 0;
    subTprice.value = 0;
    tvatprice.value = 0;

    cuppon.value = 0.0;
    voucher.value = 0;
    discount.value = 0;
    grandTotalprice.value = 0;
    tax.value = 0;
    grandTotal.value = 0;
    cupponMinimum.value = 0;
    cuponholder.value = 0;
  }

  increment(int id) {
    qty++;
  }

  decrement() {
    if (qty > 0) {
      qty--;
    }
  }

  void getcoverPic(var id) async {
    print(".....Shop cat id......");
    try {
      //await Future.delayed(Duration(seconds: 1));
      Service.menulist(id).then((va) {
        if (va != null) {}
      });
    } catch (e) {
      print(e);
    }
  }

  void getmenuItems(var id) async {
    // SharedPreferences pre = await SharedPreferences.getInstance();
    try {
      menuItems.value = [];
      isLoading(true);
      imageloader(true);
      // await Future.delayed(Duration(seconds: 1));
      await Service.menulist(id).then((va) {
        if (va != null) {
          shoptype.value = "assets/images/type${va.shopCategory}.jpg";
          menucover.value = va.shopcover!;

          menuItemsTemp.value = va.products!.toList();
          categoryName.value = va.categoryName.toString();
          shopname.value = va.shopname!;

          print(menuItemsTemp.length);
          cartLists.value = cartList.value.toList();
          if (cartList.value.length > 0) {
            for (var j = 0; j < menuItemsTemp.value.length; j++) {
              for (var i = 0; i < cartList.length; i++) {
                if (menuItemsTemp.value[j].id != 0 && menuItemsTemp.value[j].id == cartList[i]!.id) {
                  // cartList.value[i].qty =item.qty;
                  menuItemsTemp.value[j].pqty.value = cartList[i]!.qty!;
                  // Get.snackbar(" add", "item alrady added");
                }
              }
            }
          }
          menuItems.value = menuItemsTemp.value;

          // update();
        } else {
          shoptype.value = "assets/images/type0.jpg";
        }
      });
    } catch (e) {
      shoptype.value = "assets/images/type0.jpg";
      imageloader(false);
    } finally {
      //print("get menu api end");

      isLoading(false);
      await Future.delayed(Duration(milliseconds: 2000));
      imageloader(false);
    }
  }

  RxBool isGetMenuItemsModel = false.obs;

  MenuItemsModel? menuItemsModel;

  getMenuItemsModel(
    shopId,
  ) async {
    isGetMenuItemsModel.value = true;
    menuItemsModel = null;
    update();

    await Service().getMenuList(shopId.toString()).then((value) {
      if (value.status == 1) {
        menuItemsModel = value;
        isGetMenuItemsModel.value = false;

        update();
      } else {
        isGetMenuItemsModel.value = false;
        Get.snackbar("not found", "there's no data found", colorText: red);
      }
      update();

      print("$value");
    }).catchError((onError) {
      Get.snackbar("not found", "there's ${onError.toString() + shopId.toString()}}", colorText: red, duration: Duration(seconds: 10));

      isGetMenuItemsModel.value = false;
      update();
    });

    update();
  }
}

extension NumberParsing on String {
  double toDouble() {
    return double.parse(this);
  }
}
