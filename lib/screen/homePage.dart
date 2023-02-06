import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:enruta/api/service.dart';
import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/orderController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/all_order_model.dart';
import 'package:enruta/model/banner_model.dart';
import 'package:enruta/model/item_list_data.dart';
import 'package:enruta/screen/bottomnavigation/bottomNavigation.dart';
import 'package:enruta/screen/categorypage.dart';
import 'package:enruta/screen/getReview/getReview.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/helper.dart';
import 'drawer/myDrawerPage.dart';

import 'package:empty_widget/empty_widget.dart';
import 'package:http/http.dart' as http;

final LoadingIndicatorNotifier _indicatorNotifier = LoadingIndicatorNotifier();

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerModel bannerModel;

  @override
  void initState() {
    super.initState();
    permission();

    //callApi();
    new Timer.periodic(Duration(seconds: 30), (Timer t) {
      if (mounted) setState(() {});
    });
    fetchData();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    bannerView();
  }

  Future<void> bannerView() async {
    try {
      dynamic response = await http.get(Uri.parse(Service.banner));
      print("*****************Jainish ${response.body}");
      bannerModel = bannerModelFromJson(response.body);

      debugPrint("*****************Jainish ${bannerModel.banners.length}");
      setState(() {});
    } catch (e) {}
  }

  @override
  dispose() {
    _indicatorNotifier.dispose();
    super.initState();
  }

  final tController = Get.put(TestController());
  final orderController = Get.put(OrderController());
  final cartController = Get.put(CartController());

  final dController = Get.put(ResetController());

  final popularController = Get.put(CurentOrderController());

  List<ItemListData> itemList = ItemListData.itemList;

  final language = Get.put(LanguageController());
  List images = [
    'assets/icons/3899145.png',
    'assets/icons/3515737.png',
    'assets/icons/3899145.png'
  ];

  PageController _pageController = PageController();
  PageController _pageOrderController = PageController();
  int activePage = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String text(String key) {
    return language.text(key);
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> fetchData() async {
    AllOrderModel orderModel = await orderController.getOrder();
    orderModel.orders.forEach((element) {
      if (element.statusValue == 3 && element.isReviewTaken == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => GetReviewPage(
                  element.products.isEmpty
                      ? []
                      : element.products.first.map((e) => e.shopId).toList(),
                  element.id,
                  0)),
        );
      }
    });
    await tController.getPopularShops();
    setState(() {});
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> permission() async {
    try {
      await Permission.location.request();
      bool _serviceEnabled = await Geolocator().isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled =
            (await Permission.locationWhenInUse.request()).isGranted;
        if (!_serviceEnabled) {
          Get.defaultDialog(
              title: "Location Service Disable",
              content: Text('Please enable service first'),
              radius: 10,
              actions: [
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
      var permission = await Geolocator().checkGeolocationPermissionStatus();
      if (permission == GeolocationStatus.granted) {
        await tController.getLocation();
      } else {
        Get.defaultDialog(
            title: "Permission Denied",
            content: Text('Please give Permission first'),
            radius: 10,
            actions: [
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
      Get.defaultDialog(title: e.code, content: Text(e.message), actions: [
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
    return LoadingIndicator(
      loadingStatusNotifier: _indicatorNotifier.statusNotifier,
      indicatorType: LoadingIndicatorType.Overlay,
      child: Scaffold(
        key: _key,
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(text('home'),
              style: TextStyle(
                  fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
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
                          style: TextStyle(
                              fontFamily: 'TTCommonsm',
                              fontSize: 14.0,
                              color: Color(Helper.getHexToInt("#FFFFFF"))
                                  .withOpacity(0.8)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 3),
                                      child: Text(
                                          tController.addressType.value == '2'
                                              ? "Home"
                                              : tController.addressType.value ==
                                                      '3'
                                                  ? "Office"
                                                  : tController.addressType
                                                              .value ==
                                                          '5'
                                                      ? tController
                                                          .addressTypeTitle
                                                          .value
                                                      : '${tController.address.value}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'TTCommonsm',
                                              fontSize: 16.0,
                                              color: Color(Helper.getHexToInt(
                                                      "#FFFFFF"))
                                                  .withOpacity(0.8))),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 3),
                                    child: RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: 'TTCommonsm',
                                              fontSize: 16.0,
                                              color: Color(Helper.getHexToInt(
                                                      "#FFFFFF"))
                                                  .withOpacity(0.8)),
                                          text: tController.addressType.value ==
                                                  '2'
                                              ? "Home"
                                              : tController.addressType.value ==
                                                      '3'
                                                  ? "Office"
                                                  : tController.addressType
                                                              .value ==
                                                          '5'
                                                      ? tController
                                                          .addressTypeTitle
                                                          .value
                                                      : '${tController.address.value}'),
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
        drawer: MyDrawerPage(),
        body: Container(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.only(
                  bottom: 30,
                ),
                child: ListView(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom:8.0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     // height: MediaQuery.of(context).size.height / 8,
                    //     height: MediaQuery.of(context).size.height / 8,
                    //     decoration: BoxDecoration(
                    //         gradient:
                    //             LinearGradient(begin: Alignment.topLeft, colors: [
                    //           Color(Helper.getHexToInt("#11C7A1")),
                    //           // Colors.green[600],
                    //           Color(Helper.getHexToInt("#11E4A1"))
                    //         ]),
                    //         borderRadius: BorderRadius.only(
                    //             bottomLeft: Radius.circular(15),
                    //             bottomRight: Radius.circular(15))),
                    //     child: Container(
                    //       child: Stack(
                    //         // mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Column(
                    //             mainAxisAlignment: MainAxisAlignment.end,
                    //             children: [
                    //               Center(
                    //                 child: Text(text('home'),
                    //                     style: GoogleFonts.poppins(
                    //                         fontSize: 18.0, color: Colors.white)),
                    //               ),
                    //               SizedBox(
                    //                 height: 5,
                    //               ),
                    //               InkWell(
                    //                 onTap: () {
                    //                   Get.to(SetLocation());
                    //                 },
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Icon(
                    //                       Icons.location_on,
                    //                       size: 19,
                    //                       color: Colors.white,
                    //                     ),
                    //                     Container(
                    //                         width: 250,
                    //                         height: 12,
                    //                         child: Obx(() {
                    //                           return RichText(
                    //                             text: TextSpan(
                    //                                 style: TextStyle(
                    //                                     overflow: TextOverflow.fade,
                    //                                     fontFamily: 'TTCommonsm',
                    //                                     fontSize: 13.0,
                    //                                     color: Color(
                    //                                             Helper.getHexToInt(
                    //                                                 "#FFFFFF"))
                    //                                         .withOpacity(0.8)),
                    //                                 text:
                    //                                     '${tController.address.value}'),
                    //                           );
                    //                         })),
                    //                     Icon(
                    //                       Icons.arrow_forward_ios,
                    //                       size: 15,
                    //                       color: white.withOpacity(0.8),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //             ],
                    //           ),
                    //           // Positioned(
                    //           //   top: 30,
                    //           //   left: 100,
                    //           //   right: 100,
                    //           //   child: Center(
                    //           //     child: Text(text('home'),
                    //           //         style: TextStyle(
                    //           //             fontFamily: 'Poppins',
                    //           //             fontSize: 18.0,
                    //           //             color: Colors.white)),
                    //           //   ),
                    //           // ),
                    //           // Positioned(
                    //           //   top: 60,
                    //           //   left: 50,
                    //           //   // right: 50,
                    //           //   child: Row(
                    //           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           //     children: [],
                    //           //   ),
                    //           // ),
                    //           // Positioned(
                    //           //   top: 62,
                    //           //   left: 15,
                    //           //   right: 15,
                    //           //   child: InkWell(
                    //           //     onTap: () {
                    //           //       Get.to(SetLocation());
                    //           //     },
                    //           //     child: Align(
                    //           //       // alignment: Alignment.topCenter,
                    //           //       child: Container(
                    //           //         // width: MediaQuery.of(context).size.width,
                    //           //         child: Row(
                    //           //           mainAxisAlignment: MainAxisAlignment.center,
                    //           //           children: [
                    //           //             Icon(
                    //           //               Icons.location_on,
                    //           //               size: 19,
                    //           //               color: Colors.white,
                    //           //             ),
                    //           //             Container(child: Obx(() {
                    //           //               return Flexible(
                    //           //                 child: RichText(
                    //           //                   textAlign: TextAlign.center,
                    //           //                   maxLines: 2,
                    //           //                   text: TextSpan(

                    //           //                       style: TextStyle(
                    //           //                         overflow: TextOverflow.ellipsis,
                    //           //                           fontFamily: 'TTCommonsm',
                    //           //                           fontSize: 13.0,
                    //           //                           color: Color(
                    //           //                                   Helper.getHexToInt(
                    //           //                                       "#FFFFFF"))
                    //           //                               .withOpacity(0.8)),
                    //           //                       text:
                    //           //                           '${tController.address.value}'),
                    //           //                 ),
                    //           //               );
                    //           //             })),
                    //           //             Icon(
                    //           //               Icons.arrow_forward_ios,
                    //           //               size: 15,
                    //           //               color: white.withOpacity(0.8),
                    //           //             )
                    //           //           ],
                    //           //         ),
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Container(
                      color: Color(Helper.getHexToInt("#F8F9FF")),
                      width: 120,
                      child: Obx(() {
                        Get.put(TestController());
                        return GridView.count(
                          crossAxisCount: 4,
                          controller:
                              new ScrollController(keepScrollOffset: false),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(15),
                          children: List.generate(tController.category.length,
                              (index) {
                            return MenuItemView(
                              categoryData: tController.category[index],
                            );
                          }),
                        );
                      }),
                    ),
                    FutureBuilder<List<OrderModel>>(
                        future: popularController.getCurentOrder(),
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
                                    if (snap.data[index] == null) {
                                      Fluttertoast.showToast(
                                          msg: "No details found");
                                    } else {
                                      _showSheet(
                                          context, snap.data[index].status);
                                    }
                                  },
                                  pageController: _pageController,
                                  snap: snap,
                                ));
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
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
                            child:
                                Container(child: CircularProgressIndicator()),
                          ),
                        );
                      else
                        return tController.polularShopList
                                .isNotEmpty //tController.polularShopList.value.length > 0
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
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Color(
                                                            Helper.getHexToInt(
                                                                "#000000"))
                                                        .withOpacity(0.8)),
                                              )),
                                        ),
                                        // Expanded(
                                        Container(
                                            margin: EdgeInsets.only(
                                              right: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                Get.to(ViewCategoryPage(
                                                    pageTitle: tController
                                                        .category[0].name,
                                                    pageType: tController
                                                        .category[0].id));
                                              },
                                              child: Text(
                                                text('view_all'),
                                                textAlign: TextAlign.end,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    color: Color(
                                                            Helper.getHexToInt(
                                                                "#11C4A1"))
                                                        .withOpacity(1)),
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
                                      () => tController.polularShopList.value
                                                  .length >
                                              0
                                          ? GridView.count(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 5,
                                              childAspectRatio: 0.9 * 0.8,
                                              crossAxisSpacing: 5,
                                              controller: new ScrollController(
                                                  keepScrollOffset: false),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.only(
                                                  bottom: 10,
                                                  right: 10,
                                                  left: 10),
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
                                        subTitle: text(
                                            'no_popular_restaurants_available_yet'),
                                        // image: 'assets/images/userIcon.png',
                                        image: null,
                                        packageImage: PackageImage.Image_1,
                                        titleTextStyle: Theme.of(context)
                                            .typography
                                            .dense
                                            // ignore: deprecated_member_use
                                            .headline4
                                            .copyWith(color: Color(0xff9da9c7)),
                                        subtitleTextStyle: Theme.of(context)
                                            .typography
                                            .dense
                                            // ignore: deprecated_member_use
                                            .bodyText1
                                            .copyWith(
                                                color: Color(0xffabb8d6)))),
                              );
                    })
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigation(_key)),
            ],
          ),
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
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Color(Helper.getHexToInt("#11C4A1"))
                : Color(Helper.getHexToInt("#B0F7E9")),
            shape: BoxShape.circle),
      );
    });
  }

  Widget showSlider() {
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
  }

  void _showSheet(BuildContext context, String status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      // set this to true
      builder: (_) {
        final popularController = Get.put(CurentOrderController());
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
                                image:
                                    AssetImage("assets/icons/orderprocess.png"),
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
                                "It may take " +
                                    deliveryTime(
                                        popularController.deleveryTime.value ??
                                            0,
                                        status ?? "") +
                                    " min to arrive",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'TTCommonsm',
                                    color:
                                        Color(Helper.getHexToInt("#959595"))),
                              ),
                            ),
                            (popularController
                                    .detailsModel.value.order.subTxt.isEmpty)
                                ? Container()
                                : RichText(
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Color(Helper.getHexToInt(
                                                    "#808080"))
                                                .withOpacity(0.8)),
                                        text: popularController.detailsModel
                                                .value.order.subTxt ??
                                            ""),
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
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color:
                                          Color(Helper.getHexToInt("#000000"))),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order
                                              .orderFrom ??
                                          "",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order
                                              .number ??
                                          "",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        text('delivery_address'),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'TTCommonsm',
                                            color: Color(
                                                Helper.getHexToInt("#535353"))),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.address.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
                                          style: TextStyle(
                                              fontFamily: 'TTCommonsm',
                                              fontSize: 18.0,
                                              color: Color(Helper.getHexToInt(
                                                  "#535353"))),
                                          text: popularController.detailsModel
                                                  .value.order.orderItemNames ??
                                              ""),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController
                                              .detailsModel.value.order.price ??
                                          "",
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('subtotal'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController
                                              .detailsModel.value.order.price ??
                                          "",
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('delivery_fee'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController.detailsModel.value.order
                                          .deliveryCharge
                                          .toString(),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            popularController
                                        .detailsModel.value.order.voucher <=
                                    0.0
                                ? Container()
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              25,
                                          width: Get.width / 2,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            text('voucher'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'TTCommonsm',
                                                color: Color(Helper.getHexToInt(
                                                    "#535353"))),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            popularController.detailsModel.value
                                                .order.voucher
                                                .toString(),
                                            maxLines: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'TTCommonsm',
                                                color: Color(Helper.getHexToInt(
                                                    "#000000"))),
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
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    width: Get.width / 2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      text('total_include_vat'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#535353"))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      popularController
                                          .detailsModel.value.order.price
                                          .toString(),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'TTCommonsm',
                                          color: Color(
                                              Helper.getHexToInt("#000000"))),
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
  Widget showSuccessfullyBottompopup(BuildContext context, String status) {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext bc) {
          // return shoall(context);
          return Container(
            // height: 400,
            height: MediaQuery.of(context).size.height / 1.15,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: ListView(
              children: [
                Container(
                  height: 25,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.add_circle,
                    color: theamColor,
                  ),
                ),
                Container(
                  height: 150,
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
                    "It may take " +
                        deliveryTime(
                            popularController.deleveryTime.value, status) +
                        " min to arrive",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'TTCommonsm',
                        color: Color(Helper.getHexToInt("#959595"))),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color(Helper.getHexToInt("#808080"))
                              .withOpacity(0.8)),
                      text:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"
                          "s standard dummy text ever"),
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
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Color(Helper.getHexToInt("#000000"))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('your_order_form'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.orderFrom,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('your_order_number'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.number,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('delivery_address'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.address.value,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
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
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: Get.width / 2,
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'TTCommonsm',
                                  fontSize: 18.0,
                                  color: Color(Helper.getHexToInt("#535353"))),
                              text: popularController
                                  .detailsModel.value.order.orderItemNames),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.price,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
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
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: Get.width / 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('subtotal'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.price,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: Get.width / 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('delivery_fee'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController
                              .detailsModel.value.order.deliveryCharge
                              .toString(),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 25,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: Get.width / 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('voucher'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.voucher
                              .toString(),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
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
                  height: 35,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: Get.width / 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text('total_include_vat'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#535353"))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          popularController.detailsModel.value.order.price
                              .toString(),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'TTCommonsm',
                              color: Color(Helper.getHexToInt("#000000"))),
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
          );
        });
  }

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
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'TTCommonsd',
                            color: Color(Helper.getHexToInt("#959595"))),
                      ),
                    ),
                    Text(
                      text('you_will_receive_confirmation_on_your_email'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'TTCommonsm',
                          color: Color(Helper.getHexToInt("#959595"))),
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
  final PageController pageController;
  final AsyncSnapshot<List<OrderModel>> snap;
  void Function(int) onTap;

  PageViewScreen({Key key, this.pageController, this.snap, this.onTap})
      : super(
          key: key,
        );

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  int activeOrderPage = 0;
  final tController = Get.put(TestController());
  final popularController = Get.put(CurentOrderController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: widget.pageController,
            pageSnapping: true,
            itemCount: widget.snap.data.length,
            onPageChanged: (page) {
              setState(() {
                activeOrderPage = page;
              });
            },
            itemBuilder: (context, index) {
              if (widget.snap.data[index].status == "Completed") {
                tController.completeOrder(
                    popularController.detailsModel.value.order.shopId);

                return SizedBox(
                  height: 0,
                );
              } else if ((widget.snap.data[index].status != "Completed") ||
                  (widget.snap.data[index].status != "Cancelled")) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),

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
                        await popularController
                            .getorderStatus(widget.snap.data[index].id);

                        if (popularController.detailsModel.value.order !=
                            null) {
                          print('success');
                          Navigator.of(context).pop();
                          widget.onTap(index);
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
                                    widget.snap.data[index].shopName == null
                                        ? ""
                                        : widget.snap.data[index].shopName,
                                    style: TextStyle(
                                        fontFamily: 'TTCommonsm',
                                        fontSize: 15,
                                        color:
                                            Color(Helper.getHexToInt("#11C4A1"))
                                                .withOpacity(0.8)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 20, bottom: 20, right: 50),
                          child: Center(
                            // child: Text("data"),
                            child: RichText(
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 13.0,
                                      color:
                                          Color(Helper.getHexToInt("#808080"))
                                              .withOpacity(0.8)),
                                  text:
                                      "${widget.snap.data[index].resType}"), // + "${popularController.order.value.status}"
                              //"${widget.snap.data[index].resType} Your rider will pic it once it's ready"), // + "${popularController.order.value.status}"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if (widget.snap.data[index].status == null) {
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
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: indicators(widget.snap.data.length, activeOrderPage)),
        )
      ],
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(2),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Color(Helper.getHexToInt("#11C4A1"))
                : Color(Helper.getHexToInt("#B0F7E9")),
            shape: BoxShape.circle),
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
  final BannerModel banner;

  const BannerView({Key key, this.banner}) : super(key: key);

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
  Timer _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.banner.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      var popularController = Get.put(CurentOrderController());

      popularController.getCurentOrder();

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
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Color(Helper.getHexToInt("#000000"))
                              .withOpacity(0.8)),
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
                itemCount: widget.banner.banners.length,
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
                        await tController.getPopularShops(
                            widget.banner.banners[pagePosition].shopIds);
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
                                image: NetworkImage(
                                    widget.banner.banners[pagePosition].cover ??
                                        "assets/icons/3899145.png"),
                                fit: BoxFit.cover),
                          ),
                        )),
                  );
                }),
          ),
          SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: indicators(widget.banner.banners.length, activePage))
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
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Color(Helper.getHexToInt("#11C4A1"))
                : Color(Helper.getHexToInt("#B0F7E9")),
            shape: BoxShape.circle),
      );
    });
  }
}

int activePage = 0;
