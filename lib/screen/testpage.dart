import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/item_list_data.dart';
import 'package:enruta/screen/bottomnavigation/bottomNavigation.dart';
import 'package:enruta/screen/drawer/myDrawerPage.dart';
import 'package:enruta/view/item_list_view.dart';
import 'package:enruta/view/menu_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TestPage extends StatelessWidget {
  final tController = Get.put(TestController());
  List<ItemListData> itemList = ItemListData.itemList;
  GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerPage(),
      key: key,
      body: Container(
        child: Stack(
          children: [
            Container(
              // margin: EdgeInsets.only(bottom: 50),
              padding: EdgeInsets.only(bottom: 30),

              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height / 8,
                    height: 110,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                          Color(Helper.getHexToInt("#11C7A1")),
                          // Colors.green[600],
                          Color(Helper.getHexToInt("#11E4A1"))
                        ]),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    child: Container(
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Positioned(
                            top: 30,
                            left: 100,
                            right: 100,
                            child: Center(
                              child: Text("Home", style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0, color: Colors.white)),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 50,
                            // right: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ),
                          Positioned(
                            top: 62,
                            left: 5,
                            right: 5,
                            child: Align(
                              // alignment: Alignment.topCenter,
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    tController.addressType.value == '1'
                                        ? Icon(
                                            Icons.location_on,
                                            size: 18,
                                          )
                                        : tController.addressType.value == '2'
                                            ? Icon(
                                                Icons.home,
                                                size: 18,
                                              )
                                            : tController.addressType.value == '3'
                                                ? Icon(
                                                    Icons.location_city,
                                                    size: 18,
                                                  )
                                                : Icon(
                                                    Icons.location_on,
                                                    size: 18,
                                                  ),
                                    Container(child: Obx(() {
                                      return Text('${tController.address.value}',
                                          textAlign: TextAlign.justify,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontFamily: 'TTCommonsm', fontSize: 13.0, color: Color(Helper.getHexToInt("#FFFFFF")).withOpacity(0.8)));
                                    })),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: white.withOpacity(0.8),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // showMenue(),
                  Container(
                    color: Color(Helper.getHexToInt("#F8F9FF")),
                    child: Obx(
                      () => GridView.count(
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
                      ),
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                  child: Text(
                                    "What's New?",
                                    style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 15, color: Color(Helper.getHexToInt("#000000")).withOpacity(0.8)),
                                    textAlign: TextAlign.start,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: showSlider(),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    color: cardbackgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 20, bottom: 10, top: 20),
                                  child: Text(
                                    "Popular Restaurants",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 16, color: Color(Helper.getHexToInt("#000000")).withOpacity(0.8)),
                                  )),
                            ),
                            // Expanded(
                            Container(
                                margin: EdgeInsets.only(right: 20, bottom: 10, top: 20),
                                child: Text(
                                  "View All",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontFamily: 'TTCommonsm', fontSize: 15, color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(1)),
                                )),
                            // )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 10,
                          child: GridView.count(
                            crossAxisCount: 2,
                            controller: new ScrollController(keepScrollOffset: false),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            childAspectRatio: 0.9,
                            padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                            children: List.generate(itemList.length, (index) {
                              return ItemListView(
                                  // itemData: itemList[index],
                                  );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 73,
              child: BottomNavigation(key),
            ),
          ],
        ),
      ),
    );
  }

  Widget showSlider() {
    return Container(
      height: 148.0,
      margin: EdgeInsets.only(left: 10, right: 10),
      /*  child: Carousel(
        dotPosition: DotPosition.bottomLeft,
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
      ),*/
    );
  }
}
