import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/orderController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/banner_model.dart';
import 'package:enruta/model/item_list_data.dart';
import 'package:enruta/screen/categorypage.dart';
import 'package:enruta/screen/getReview/getReview.dart';
import 'package:enruta/screen/myAccount/myaccount.dart';
import 'package:enruta/screen/myMap/mapController.dart';
import 'package:enruta/screen/orerder/curentOrderController.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:enruta/screen/setLocation.dart';
import 'package:enruta/screen/viewcategorypage.dart';
import 'package:enruta/view/menu_list_view.dart';
import 'package:enruta/view/popular_shop_list_view.dart';
import 'package:enruta/widgetview/loading_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../helper/helper.dart';
import 'drawer/myDrawerPage.dart';
import 'myFavorite/myFavorite.dart';
import 'orerder/allorder.dart';

final LoadingIndicatorNotifier _indicatorNotifier = LoadingIndicatorNotifier();

class HomePage extends StatefulWidget {
  @override
  _HomeScreenNewState createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomePage> {
  int _currentIndex = 0;

  final icons = [
    "assets/icons/home.svg",
    "assets/icons/heartq.svg",
    "assets/icons/list.svg",
    "assets/icons/user.svg",
    "assets/icons/menu.svg",
  ];

  final titles = ['Home', 'Favourite', 'Order', 'Account', 'Menu'];

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: MyDrawerPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(Helper.getHexToInt("#11C4A1")),
        unselectedItemColor: Color(Helper.getHexToInt("##929292")),
        currentIndex: _currentIndex,
        items: List.generate(icons.length, (index) {
          final icon = icons[index];
          final title = titles[index];
          final color = _currentIndex == index ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292"));
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              icon,
              color: color,
              height: 18,
              width: 18,
            ),
            label: title,
          );
        }).toList(),
        onTap: (index) {
          if (index == 4) return _scaffoldState.currentState!.openDrawer();
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // SizedBox(),
          HomePageTab(),
          MyFavorite(),
          AllOrder(),
          MyAccount(),
          SizedBox(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePageTab extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageTab> {
  BannerModel? bannerModel;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  void loadServices() async {
    // await permission();

    final position = await getLocationPermission();

    if (position != null) await tController.getLocation();

    //callApi();
    await fetchData();

    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    bannerView();
  }

  Future<void> bannerView() async {
    try {
      dynamic response = await http.get(Uri.parse(Service.banner));
      print("*****************Jainish ${response.body}");
      bannerModel = bannerModelFromJson(response.body);

      debugPrint("*****************Jainish ${bannerModel!.banners!.length}");
      setState(() {});
    } catch (e) {}
  }

  @override
  dispose() {
    _indicatorNotifier.dispose();
    super.dispose();
  }

  final tController = Get.put(TestController());
  final orderController = Get.put(OrderController());
  final cartController = Get.put(CartController());

  final dController = Get.put(ResetController());

  List<ItemListData> itemList = ItemListData.itemList;

  final language = Get.put(LanguageController());
  List images = ['assets/icons/3899145.png', 'assets/icons/3515737.png', 'assets/icons/3899145.png'];

  PageController _pageController = PageController();
  int activePage = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String text(String key) {
    return language.text(key);
  }

  final messaging = FirebaseMessaging.instance;

  Future<void> fetchData() async {
    AllOrderModel orderModel = await orderController.getOrder();
    orderModel.orders!.forEach((element) {
      if (element.statusValue == 3 && element.isReviewTaken == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => GetReviewPage(element.products!.isEmpty ? [] : element.products!.first.map((e) => e.shopId).toList(), element.id, 0)),
        );
      }
    });
    await tController.getPopularShops();
    setState(() {});
  }

  Future<void> permission() async {
    try {
      await Permission.location.request();
      bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = (await Permission.locationWhenInUse.request()).isGranted;
        if (!_serviceEnabled) {
          Get.defaultDialog(title: "Location Service Disable", content: Text('Please enable service first'), radius: 10, actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () async {
                  await AppSettings.openAppSettings();
                  this.permission();
                  Navigator.of(context).pop();
                },
                child: Text("Settings")),
          ]);
        }
      }

      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        await tController.getLocation();
      } else {
        Get.defaultDialog(title: "Permission Denied", content: Text('Please give Permission first'), radius: 10, actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () async {
                await AppSettings.openAppSettings();
                this.permission();
                Navigator.of(context).pop();
              },
              child: Text("Settings")),
        ]);
      }
    } on PlatformException catch (e) {
      Get.defaultDialog(title: e.code, content: Text(e.message!), actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () async {
              await AppSettings.openLocationSettings();
              permission();
              Navigator.of(context).pop();
            },
            child: Text("Settings")),
      ]);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Position?> getLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
       GetSnackBar(message: 'Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        Get.defaultDialog(title: "Location Service Disable", content: Text('Please enable service first'), radius: 10, actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AppSettings.openAppSettings();
              getLocationPermission();
            },
            child: Text("Settings"),
          ),
        ]);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      GetSnackBar(title: 'Location permissions are permanently denied, we cannot request permissions.');

      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Get.put(MyMapController());
    tController.getmenulist();
    language.loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    //popularController.getorderStatus(popularController.curentOrder.value.id);

    final popularController = Get.put(CurrentOrderController());

    return LoadingIndicator(
      loadingStatusNotifier: _indicatorNotifier.statusNotifier,
      indicatorType: LoadingIndicatorType.Overlay,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(),
          // leading: IconButton(
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          //   icon: Icon(Icons.menu),
          // ),
          iconTheme: IconThemeData(color: Colors.white),
          toolbarHeight: 90,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                  Color(Helper.getHexToInt("#11C7A1")),
                  // Colors.green[600],
                  Color(Helper.getHexToInt("#11E4A1"))
                ]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(text('home'), style: TextStyle(fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(0, 5),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SetLocation(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Obx(() {
                  return tController.address.value.isEmpty
                      ? Text(
                          'Loading...',
                          style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 14.0, color: Color(Helper.getHexToInt("#FFFFFF")).withOpacity(0.8)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            tController.addressType.value == '1'
                                ? Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : tController.addressType.value == '2'
                                    ? Icon(
                                        Icons.home,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : tController.addressType.value == '3'
                                        ? Icon(
                                            Icons.location_city,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                            (tController.addressType.value == '4')
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
                                      child: Text(
                                          tController.addressType.value == '2'
                                              ? "Home"
                                              : tController.addressType.value == '3'
                                                  ? "Office"
                                                  : tController.addressType.value == '5'
                                                      ? tController.addressTypeTitle.value
                                                      : '${tController.address.value}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'TTCommonsm', fontSize: 16.0, color: Color(Helper.getHexToInt("#FFFFFF")).withOpacity(0.8))),
                                    ),
                                  )
                                : Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            style:
                                                TextStyle(fontFamily: 'TTCommonsm', fontSize: 16.0, color: Color(Helper.getHexToInt("#FFFFFF")).withOpacity(0.8)),
                                            text: tController.addressType.value == '2'
                                                ? "Home"
                                                : tController.addressType.value == '3'
                                                    ? "Office"
                                                    : tController.addressType.value == '5'
                                                        ? tController.addressTypeTitle.value
                                                        : '${tController.address.value}'),
                                      ),
                                    ),
                                ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: white.withOpacity(0.8),
                            )
                          ],
                        );
                }),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 10),
            Container(
              color: Color(Helper.getHexToInt("#F8F9FF")),
              width: 120,
              child: Obx(() {
                Get.put(TestController());
                return GridView.count(
                  crossAxisCount: 4,
                  controller: new ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(15),
                  children: List.generate(tController.category.length, (index) {
                    return MenuItemView(
                      categoryData: tController.category[index],
                    );
                  }),
                );
              }),
            ),
            Obx(() => popularController.isLoading.value
                ? const SizedBox()
                : Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: PageViewScreen(
                      orders: popularController.allCurrentOrderList,
                      pageController: _pageController,
                      onTap: (index) => _showSheet(context, popularController.allCurrentOrderList[index].status),
                    ))),
            /*FutureBuilder<List<OrderModel>>(
                  future: popularController.getCurrentOrder(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.active) {
                      return Container(
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snap.data?.isEmpty ?? true) {
                      return SizedBox(
                        height: 0,
                      );
                    } else if (snap.hasError) {
                      return Container();
                    } else {
                      return Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          child: PageViewScreen(
                            onTap: (index) {
                              if (snap.data![index] == null) {
                                Fluttertoast.showToast(msg: "No details found");
                              } else {
                                _showSheet(context, snap.data![index].status);
                              }
                            },
                            pageController: _pageController,
                            snap: snap,
                          ));
                    }
                  }),*/
            SizedBox(height: 20),
            bannerModel == null
                ? Center(child: CircularProgressIndicator())
                : BannerView(
                    banner: bannerModel,
                  ),
            Obx(() {
              if (tController.orderiscoming.value)
                return Container(
                  height: 100,
                  child: Center(
                    child: Container(child: CircularProgressIndicator()),
                  ),
                );
              else
                return tController.polularShopList.isNotEmpty //tController.polularShopList.value.length > 0
                    /**/ ? Container(
                        color: cardbackgroundColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Text(
                                        text('popular_restaurants'),
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#000000")).withOpacity(0.8)),
                                      )),
                                ),
                                // Expanded(
                                Container(
                                    margin: EdgeInsets.only(
                                      right: 20,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Get.to(ViewCategoryPage(pageTitle: tController.category[0].name, pageType: tController.category[0].id));
                                      },
                                      child: Text(
                                        text('view_all'),
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(fontSize: 17, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                                      ),
                                    )),
                                // child: Text(
                                //   text('Reload'),
                                //   textAlign: TextAlign.end,
                                //   style: TextStyle(
                                //       fontFamily: 'TTCommonsm',
                                //       fontSize: 17,
                                //       color: Color(Helper.getHexToInt(
                                //               "#11C4A1"))
                                //           .withOpacity(1)),
                                // )),
                                // )
                              ],
                            ),
                            Container(
                                child: Obx(
                              // ignore: invalid_use_of_protected_member
                              () => tController.polularShopList.value.length > 0
                                  ? GridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.9 * 0.8,
                                      crossAxisSpacing: 5,
                                      controller: new ScrollController(keepScrollOffset: false),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                                      children: List.generate(
                                          tController
                                              .polularShopList
                                              // ignore: invalid_use_of_protected_member
                                              .value
                                              .length, (index) {
                                        return PopularShopListView(
                                          itemData: tController
                                              .polularShopList
                                              // ignore: invalid_use_of_protected_member
                                              .value[index],
                                        );
                                      }),
                                    )
                                  : Text(""),
                            )),
                          ],
                        ),
                        /**/
                      )
                    : Container(
                        margin: EdgeInsets.all(40),
                        child: Center(
                            child: EmptyWidget(
                                title: text('no_restaurants'),
                                subTitle: text('no_popular_restaurants_available_yet'),
                                // image: 'assets/images/userIcon.png',
                                image: null,
                                packageImage: PackageImage.Image_1,
                                titleTextStyle: Theme.of(context)
                                    .typography
                                    .dense
                                    // ignore: deprecated_member_use
                                    .headline4!
                                    .copyWith(color: Color(0xff9da9c7)),
                                subtitleTextStyle: Theme.of(context)
                                    .typography
                                    .dense
                                    // ignore: deprecated_member_use
                                    .bodyText1!
                                    .copyWith(color: Color(0xffabb8d6)))),
                      );
            })
          ],
        ),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(2),
        width: 6,
        height: 6,
        decoration:
            BoxDecoration(color: currentIndex == index ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#B0F7E9")), shape: BoxShape.circle),
      );
    });
  }

  /*Widget showSlider() {
    return Container(
      height: 148.0,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () {
          // Get.to(Promotion());
        },
        child: Carousel(
          dotPosition: DotPosition.bottomCenter,
          overlayShadow: false,
          borderRadius: true,
          boxFit: BoxFit.fill,
          autoplay: true,
          images: [
            AssetImage('assets/icons/3899145.png'),
            AssetImage('assets/icons/3515737.png'),
            AssetImage('assets/icons/3899145.png'),
          ],
          dotSize: 5.0,
          indicatorBgPadding: 1.0,
        ),
      ),
    );
  }*/

  void _showSheet(BuildContext context, String? status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      // set this to true
      builder: (_) {
        final popularController = Get.put(CurrentOrderController());
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.64,
          minChildSize: 0.2,
          maxChildSize: 1,
          builder: (_, controller) {
            return Obx(() {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: popularController.detailsModel.value.order == null
                      ? Center(
                          child: Text("No data found"),
                        )
                      : ListView(
                          controller: controller,
                          addAutomaticKeepAlives: true,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop(context);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 20,
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width,
                              child: Image(
                                image: AssetImage("assets/icons/orderprocess.png"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  text('your_order_placed_successfully'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'TTCommonsd',
                                    color: Color(
                                      Helper.getHexToInt("#959595"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "It may take " + deliveryTime(popularController.deleveryTime.value, status ?? "") + " min to arrive",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#959595"))),
                              ),
                            ),
                            (popularController.detailsModel.value.order!.subTxt!.isEmpty)
                                ? Container()
                                : RichText(
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 12.0, color: Color(Helper.getHexToInt("#808080")).withOpacity(0.8)),
                                        text: popularController.detailsModel.value.order!.subTxt ?? ""),
                                  ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  text('order_details'),
                                  style: GoogleFonts.poppins(fontSize: 18, color: Color(Helper.getHexToInt("#000000"))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('your_order_form'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.orderFrom ?? "",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('your_order_number'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.number ?? "",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        text('delivery_address'),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.address.value,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 18.0, color: Color(Helper.getHexToInt("#535353"))),
                                          text: popularController.detailsModel.value.order!.orderItemNames ?? ""),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.price ?? "",
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 25,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('subtotal'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.price ?? "",
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 25,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('delivery_fee'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.deliveryCharge.toString(),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            popularController.detailsModel.value.order!.voucher! <= 0.0
                                ? Container()
                                : Container(
                                    height: MediaQuery.of(context).size.height / 25,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height / 25,
                                          width: Get.width / 2,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            text('voucher'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            popularController.detailsModel.value.order!.voucher.toString(),
                                            maxLines: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 20,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('total_include_vat'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 22, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order!.price.toString(),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 22, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                ),
              );
            });
          },
        );
      },
    );
  }

  // ignore: missing_return
  // void showSuccessfullyBottomPopup(BuildContext context, String status) {
  //   showMaterialModalBottomSheet(
  //       context: context,
  //       backgroundColor: white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       builder: (BuildContext bc) {
  //         // return shoall(context);
  //         return Container(
  //           // height: 400,
  //           height: MediaQuery.of(context).size.height / 1.15,
  //           padding: EdgeInsets.only(left: 20, right: 20),
  //           decoration: BoxDecoration(color: white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //           child: ListView(
  //             children: [
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.all(10),
  //                 alignment: Alignment.centerRight,
  //                 child: Icon(
  //                   Icons.add_circle,
  //                   color: theamColor,
  //                 ),
  //               ),
  //               Container(
  //                 height: 150,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Image(
  //                   image: AssetImage("assets/icons/orderprocess.png"),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(5.0),
  //                 child: Center(
  //                   child: Text(
  //                     text('your_order_placed_successfully'),
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontFamily: 'TTCommonsd',
  //                       color: Color(
  //                         Helper.getHexToInt("#959595"),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   "It may take " + deliveryTime(popularController.deleveryTime.value, status) + " min to arrive",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#959595"))),
  //                 ),
  //               ),
  //               RichText(
  //                 textAlign: TextAlign.center,
  //                 maxLines: 2,
  //                 text: TextSpan(
  //                     style: TextStyle(fontSize: 12.0, color: Color(Helper.getHexToInt("#808080")).withOpacity(0.8)),
  //                     text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"
  //                         "s standard dummy text ever"),
  //               ),
  //               SizedBox(
  //                 height: 3,
  //               ),
  //               Divider(
  //                 thickness: 1,
  //               ),
  //               Container(
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     text('order_details'),
  //                     style: GoogleFonts.poppins(fontSize: 18, color: Color(Helper.getHexToInt("#000000"))),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('your_order_form'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.orderFrom!,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('your_order_number'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.number!,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 height: 30,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('delivery_address'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.address.value,
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Divider(
  //                 thickness: 1,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 20,
  //                       width: Get.width / 2,
  //                       alignment: Alignment.centerLeft,
  //                       child: RichText(
  //                         textAlign: TextAlign.center,
  //                         maxLines: 2,
  //                         text: TextSpan(
  //                             style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 18.0, color: Color(Helper.getHexToInt("#535353"))),
  //                             text: popularController.detailsModel.value.order!.orderItemNames),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.price!,
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Divider(
  //                 thickness: 1,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 20,
  //                       width: Get.width / 2,
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('subtotal'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.price!,
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 20,
  //                       width: Get.width / 2,
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('delivery_fee'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.deliveryCharge.toString(),
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 height: 25,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 20,
  //                       width: Get.width / 2,
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('voucher'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.voucher.toString(),
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Divider(
  //                 thickness: 1,
  //               ),
  //               Container(
  //                 height: 35,
  //                 padding: EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       height: 20,
  //                       width: Get.width / 2,
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         text('total_include_vat'),
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(fontSize: 22, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#535353"))),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Text(
  //                         popularController.detailsModel.value.order!.price.toString(),
  //                         maxLines: 1,
  //                         textAlign: TextAlign.right,
  //                         style: TextStyle(fontSize: 22, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#000000"))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  Widget shoall(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: .95,
        initialChildSize: .2,
        minChildSize: .2,
        builder: (context, scrollController) {
          return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  color: white,
                ),
                child: Column(
                  children: [
                    Text("data"),
                    Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: Image(
                        image: AssetImage("assets/icons/orderprocess.png"),
                      ),
                    ),
                    Center(
                      child: Text(
                        text('your_order_placed_successfully'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontFamily: 'TTCommonsd', color: Color(Helper.getHexToInt("#959595"))),
                      ),
                    ),
                    Text(
                      text('you_will_receive_confirmation_on_your_email'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontFamily: 'TTCommonsm', color: Color(Helper.getHexToInt("#959595"))),
                    ),
                  ],
                ),
              ));
        });
  }

  String deliveryTime(int time, String status) {
    switch (status) {
      case "Processing":
        time = (time - (time * .05).toInt());
        break;
      case "On the way":
        time = (time - (time * .3).toInt());
        break;
    }
    return time.toString();
  }
}

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key, required this.orders, required this.onTap, required this.pageController}) : super(key: key);
  final PageController pageController;
  final List<OrderModel> orders;
  final void Function(int) onTap;

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  int activeOrderPage = 0;
  final tController = Get.put(TestController());
  final popularController = Get.put(CurrentOrderController());

  List<OrderModel> get orders => widget.orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: widget.pageController,
            pageSnapping: true,
            itemCount: orders.length,
            onPageChanged: (page) {
              setState(() {
                activeOrderPage = page;
              });
            },
            itemBuilder: (context, index) {
              final order = orders[index];

              if (order.status == "Completed") {
                tController.completeOrder(popularController.detailsModel.value.order!.shopId!);
                return SizedBox();
              } else if ((order.status != "Cancelled")) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // child: Center(
                  child: InkWell(
                    onTap: () async {
                      try {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await popularController.getorderStatus(order.id);

                        if (popularController.detailsModel.value.order != null) {
                          print('success');
                          Navigator.of(context).pop();
                          widget.onTap(index);
                          // showSuccessfullyBottompopup(
                          //     context, order.status);
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } finally {}
                      // Get.to(AddNewMethod());

                      // shoall(context);
                      print("Add New Method");
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Image.asset("assets/icons/roundpoint.png"),
                              // Icon(Icons.radio_button_on_rounded),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    order.shopName ?? '',
                                    style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 15, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(0.8)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 50),
                          child: Center(
                            // child: Text("data"),
                            child: RichText(
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 13.0, color: Color(Helper.getHexToInt("#808080")).withOpacity(0.8)),
                                  text: "${order.resType}"), // + "${popularController.order.value.status}"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: indicators(orders.length, activeOrderPage)),
        )
      ],
    );
    /*return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: widget.pageController,
            pageSnapping: true,
            itemCount: widget.snap!.data!.length,
            onPageChanged: (page) {
              setState(() {
                activeOrderPage = page;
              });
            },
            itemBuilder: (context, index) {
              if (widget.snap!.data![index].status == "Completed") {
                tController.completeOrder(popularController.detailsModel.value.order!.shopId!);

                return SizedBox(
                  height: 0,
                );
              } else if ((widget.snap!.data![index].status != "Completed") || (widget.snap!.data![index].status != "Cancelled")) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // child: Center(
                  child: InkWell(
                    onTap: () async {
                      try {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await popularController.getorderStatus(widget.snap!.data![index].id);

                        if (popularController.detailsModel.value.order != null) {
                          print('success');
                          Navigator.of(context).pop();
                          widget.onTap!(index);
                          // showSuccessfullyBottompopup(
                          //     context, snap.data[index].status);
                        }
                      } catch (e) {
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } finally {}
                      // Get.to(AddNewMethod());

                      // shoall(context);
                      print("Add New Method");
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Image.asset("assets/icons/roundpoint.png"),
                              // Icon(Icons.radio_button_on_rounded),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    // popularController.order.value.orderFrom,
                                    widget.snap!.data![index].shopName == null ? "" : widget.snap!.data![index].shopName!,
                                    style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 15, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(0.8)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 50),
                          child: Center(
                            // child: Text("data"),
                            child: RichText(
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 13.0, color: Color(Helper.getHexToInt("#808080")).withOpacity(0.8)),
                                  text: "${widget.snap!.data![index].resType}"), // + "${popularController.order.value.status}"
                              //"${widget.snap.data[index].resType} Your rider will pic it once it's ready"), // + "${popularController.order.value.status}"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if (widget.snap!.data![index].status == null) {
                return SizedBox(
                  height: 0,
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: indicators(widget.snap!.data!.length, activeOrderPage)),
        )
      ],
    );*/
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(2),
        width: 6,
        height: 6,
        decoration:
            BoxDecoration(color: currentIndex == index ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#B0F7E9")), shape: BoxShape.circle),
      );
    });
  }

  String deliveryTime(int time, String status) {
    switch (status) {
      case "Processing":
        time = (time - (time * .05).toInt());
        break;
      case "On the way":
        time = (time - (time * .3).toInt());
        break;
    }
    return time.toString();
  }
}

class BannerView extends StatefulWidget {
  final BannerModel? banner;

  const BannerView({Key? key, this.banner}) : super(key: key);

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  final language = Get.put(LanguageController());
  final tController = Get.put(TestController());

  String text(String key) {
    return language.text(key);
  }

  // PageController _pageController = PageController();

  // List images = [
  //   'assets/icons/3899145.png',
  //   'assets/icons/3515737.png',
  //   'assets/icons/3899145.png'
  // ];

  int _currentPage = 0;
  Timer? _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.banner!.banners!.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      // var popularController = Get.put(CurentOrderController());
      // popularController.getCurrentOrder();

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      text('what_s_new'),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(Helper.getHexToInt("#000000")).withOpacity(0.8)),
                      textAlign: TextAlign.start,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: PageView.builder(
                itemCount: widget.banner!.banners!.length,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return GestureDetector(
                    onTap: () async {
                      try {
                        _indicatorNotifier.show();
                        print(pagePosition);
                        await tController.getPopularShops(widget.banner!.banners![pagePosition].shopIds);
                        await Get.to(CategoryPage2(
                          pageTitle: "Restaurant",
                        ));
                      } catch (e) {
                      } finally {
                        _indicatorNotifier.hide();
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(widget.banner!.banners![pagePosition].cover ?? "assets/icons/3899145.png"), fit: BoxFit.cover),
                          ),
                        )),
                  );
                }),
          ),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: indicators(widget.banner!.banners!.length, activePage))
          // Container(
          //   child: showSlider(),
          // ),
        ],
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(2),
        width: 6,
        height: 6,
        decoration:
            BoxDecoration(color: currentIndex == index ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#B0F7E9")), shape: BoxShape.circle),
      );
    });
  }
}

int activePage = 0;
