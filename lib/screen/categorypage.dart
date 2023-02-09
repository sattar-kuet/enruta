import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/style.dart';
// ignore: unused_import
import 'package:enruta/model/near_by_place_data.dart';
import 'package:enruta/screen/searchResult/searchController.dart';
import 'package:enruta/screen/searchResult/searchResult.dart';
import 'package:enruta/view/category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/helper.dart';

// ignore: must_be_immutable
class CategoryPage extends StatefulWidget {
  final pageTitle;
  final int? pageType;

  CategoryPage({this.pageTitle, this.pageType});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final tController = Get.put(TestController());

  final searchCont = Get.put(SearchController());

  var selectedCard = 'WEIGHT';

  var selectedCards = 'WEIGHT';

  //RxList<Datum> itemList = List<Datum>().obs;

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  Future<void> fetchData() async {
    await tController.getnearByPlace();
    // itemList.refresh();
    tController.nearbycat = tController.nearbyres
        .where((u) => (u.catId == widget.pageType))
        .toList()
        .obs;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            tController.nearbycat.clear();
            tController.nearbycat.refresh();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),

        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // toolbarHeight: MediaQuery.of(context).size.height/10,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        title: Text(widget.pageTitle,
            style: GoogleFonts.poppins(fontSize: 18.0, color: Colors.white)),
        bottom: PreferredSize(
            preferredSize: Size(0, 60),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: buidTextfield3(text('Search any product here'), context),
            )
            // ],
            // ),
            ),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(children: [
          Container(
            child: Obx(
              () => tController.spin.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (tController.nearbycat.isNotEmpty) //tController.datum.length >0
                      ? ListView(
                          children: <Widget>[
                            //showHotList(widget.pageType),
                            Container(
                              color: Color(Helper.getHexToInt("#F8F9FF")),
                              padding: EdgeInsets.only(bottom: 80),
                              child: Column(
                                children: [
                                  new Row(
                                    children: [
                                      // Expanded(
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 20, bottom: 5, top: 15),
                                          child: Text(
                                            widget.pageTitle +
                                                " " +
                                                text('near_you'),
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )),
                                    ],
                                  ),
                                  new Container(
                                      child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.9 * 0.8,
                                      crossAxisSpacing: 5,
                                    ),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.all(15),
                                    itemCount: tController.nearbycat.length,
                                    itemBuilder: (context, index) {
                                      //  print('FAVOURITE ==$}');
                                      return CategoryListView3(
                                        itemData: tController.nearbycat[index],
                                        callback: () {
                                          setState(() {});
                                        },
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                              text('we_couldnt_find_any_shop_near_by_you')),
                        ),
            ),
          ),
          // Align(alignment: Alignment.bottomCenter, child: BottomNavigation()),
        ]),
      ),
    );
  }

  Widget buidTextfield3(String hintText, BuildContext context) {
    final searchController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            // color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 4),
                          hintText: hintText,
                          hintStyle: GoogleFonts.poppins(
                              color: Color(
                                Helper.getHexToInt("#aab7b8"),
                              ),
                              fontSize: 15),
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              print("object");
                              searchCont
                                  .searchData(searchController.text.toString());
                              // Get.to(SearchResult());
                            },
                            child: Icon(
                              Icons.search,
                              color: Color(Helper.getHexToInt("#aab7b8")),
                            ),
                          )),
                      onSubmitted: (value) {
                        searchCont.searchData(searchController.text);
                        print(searchController.text);
                      },
                      controller: searchController,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      bottomsheetfilter() ?? errro(),
                    );
                    // Get.to(SearchResult());
                  },
                  child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 10,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(Helper.getHexToInt("#11C4A1")),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      child: Container(
                        child: SvgPicture.asset(
                            "assets/icons/filter_list-24px.svg"),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget errro() {
    return SizedBox(
      height: 0,
    );
  }

  Widget scrolview(
    String title,
    String image,
  ) {
    return Column(
      children: <Widget>[
        Container(
          // color: Colors.blue,
          alignment: Alignment.center,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 4, bottom: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(Helper.getHexToInt("#F9F9F9")),
//                                   borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,

                  radius: 60.0,
                  // backgroundImage:
                  //     SvgPicture.asset("assets/image/shopping-bag.svg"),
                  child: Container(
                    child: SvgPicture.asset(image),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    // fontFamily: 'Poppinsr',
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomsheetfilter() {
    return Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        // context: context,
        // backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        // builder: (BuildContext bc) {
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text('filters'),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'TTCommonsm',
                              color: black,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pop
                              searchCont.clearFilter();
                              // Get.back();
                            },
                            child: Text(
                              text('clear'),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'TTCommonsm',
                                  color: black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                bottom: 80,
                left: 0,
                right: 0,
                child: Container(
                    // height: 400,
                    margin: EdgeInsets.only(top: 15),
                    child: ListView(
                      children: [
                        Divider(
                          thickness: 1,
                          color: Color(Helper.getHexToInt("#707070"))
                              .withOpacity(0.1),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('Currently open'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter1.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter1.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('Offering discount'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter2.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter2.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('free_delivery'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter3.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter3.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            text('filter_by_menu'),
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'TTCommonsm',
                                color: Color(Helper.getHexToInt("#C4C4C4"))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 5,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('fries_&_wedges'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter4.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter4.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('thai_food'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter6.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter6.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('italian_food'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter7.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter7.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('indian'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter8.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter8.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('chains_items'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter9.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter9.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: getFilter(),
                        // )
                      ],
                    )),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: getFilter(),
                ),
              )
            ],
          ),
        ));
  }

  Widget getFilter() {
    return InkWell(
      onTap: () {
        // var addrestype = searchController.text;
        // mymapcont.savelocation(addrestype);
        //searchCont.itemList.where(() => );
        print('RES LIST =}');

        searchCont.filter('delivery_charge');
        //  searchCont.searchData(searchController.text);
        // searchCont.searchData('');

        Get.off(SearchResult());
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Color(Helper.getHexToInt("#11C7A1")),
            Color(Helper.getHexToInt("#11E4A1"))
          ]),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
            child: Text(
          text('apply_filter'),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'TTCommonsm',
          ),
        )),
      ),
    );
  }
}

class CategoryPage2 extends StatefulWidget {
  final pageTitle;

  CategoryPage2({
    this.pageTitle,
  });

  @override
  _CategoryPage2State createState() => _CategoryPage2State();
}

class _CategoryPage2State extends State<CategoryPage2> {
  final tController = Get.put(TestController());

  final searchCont = Get.put(SearchController());

  var selectedCard = 'WEIGHT';

  var selectedCards = 'WEIGHT';

  //RxList<Datum> itemList = List<Datum>().obs;

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }
  //  Future<void> fetchData() async {
  //   await tController.getnearByPlace();
  //   // itemList.refresh();
  //   tController.polularShopList = tController.polularShopList
  //       .where((u) => (u.catId == widget.))
  //       .toList()
  //       .obs;
  // }

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),

        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // toolbarHeight: MediaQuery.of(context).size.height/10,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        title: Text(widget.pageTitle,
            style: GoogleFonts.poppins(fontSize: 18.0, color: Colors.white)),
        bottom: PreferredSize(
            preferredSize: Size(0, 60),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: buidTextfield3(text('Search any product here'), context),
            )
            // ],
            // ),
            ),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(children: [
          Container(
            child: Obx(() {
              print(tController.polularShopList
                  .map((element) => element.toJson()));
              return

                  //  tController.spin.value
                  //     ? Center(
                  //         child: CircularProgressIndicator(),
                  //       )
                  //     :

                  (tController.polularShopList.isNotEmpty ??
                          true) //tController.datum.length >0
                      ? ListView(
                          children: <Widget>[
                            //showHotList(widget.pageType),
                            Container(
                              color: Color(Helper.getHexToInt("#F8F9FF")),
                              padding: EdgeInsets.only(bottom: 80),
                              child: Column(
                                children: [
                                  new Row(
                                    children: [
                                      // Expanded(
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 20, bottom: 5, top: 15),
                                          child: Text(
                                            widget.pageTitle +
                                                " " +
                                                text('near_you'),
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )),
                                    ],
                                  ),
                                  new Container(
                                      child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.9 * 0.8,
                                      crossAxisSpacing: 5,
                                    ),
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.all(15),
                                    itemCount:
                                        tController.polularShopList.length,
                                    itemBuilder: (context, index) {
                                      //  print('FAVOURITE ==$}');
                                      return CategoryListView2(
                                        itemData:
                                            tController.polularShopList[index],
                                        callback: () {
                                          setState(() {});
                                        },
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                              text('we_couldnt_find_any_shop_near_by_you')),
                        );
            }),
          ),
          // Align(alignment: Alignment.bottomCenter, child: BottomNavigation()),
        ]),
      ),
    );
  }

  // Widget showHotList(int type) {
  //   if (type == 1) {
  //     return Container(
  //       padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
  //       color: Colors.white,
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           children: <Widget>[
  //             scrolview("Vegan", "assets/icons/food1.svg"),
  //             scrolview("Vegetarian", "assets/icons/foodrestaurant.svg"),
  //             scrolview("Pescatarian", "assets/icons/vegetable.svg"),
  //             scrolview("Low Carb", "assets/icons/dinner.svg"),
  //             scrolview("Keto", "assets/icons/food1.svg"),
  //             scrolview("35-40 min", "assets/icons/dinner.svg"),
  //             scrolview("35-40 min", "assets/icons/food1.svg"),
  //             scrolview("35-40 min", "assets/icons/food1.svg"),
  //             scrolview("35-40 min", "assets/icons/food1.svg"),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  Widget buidTextfield3(String hintText, BuildContext context) {
    final searchController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            // color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 4),
                          hintText: hintText,
                          hintStyle: GoogleFonts.poppins(
                              color: Color(
                                Helper.getHexToInt("#aab7b8"),
                              ),
                              fontSize: 15),
                          border: InputBorder.none,
                          prefixIcon: InkWell(
                            onTap: () {
                              print("object");
                              searchCont
                                  .searchData(searchController.text.toString());
                              // Get.to(SearchResult());
                            },
                            child: Icon(
                              Icons.search,
                              color: Color(Helper.getHexToInt("#aab7b8")),
                            ),
                          )),
                      onSubmitted: (value) {
                        searchCont.searchData(searchController.text);
                        print(searchController.text);
                      },
                      controller: searchController,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      bottomsheetfilter() ?? errro(),
                    );
                    // Get.to(SearchResult());
                  },
                  child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 10,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(Helper.getHexToInt("#11C4A1")),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      child: Container(
                        child: SvgPicture.asset(
                            "assets/icons/filter_list-24px.svg"),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget errro() {
    return SizedBox(
      height: 0,
    );
  }

  Widget scrolview(
    String title,
    String image,
  ) {
    return Column(
      children: <Widget>[
        Container(
          // color: Colors.blue,
          alignment: Alignment.center,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 4, bottom: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(Helper.getHexToInt("#F9F9F9")),
//                                   borderRadius: BorderRadius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,

                  radius: 60.0,
                  // backgroundImage:
                  //     SvgPicture.asset("assets/image/shopping-bag.svg"),
                  child: Container(
                    child: SvgPicture.asset(image),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    // fontFamily: 'Poppinsr',
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomsheetfilter() {
    return Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        // context: context,
        // backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        // builder: (BuildContext bc) {
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text('filters'),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'TTCommonsm',
                              color: black,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pop
                              searchCont.clearFilter();
                              // Get.back();
                            },
                            child: Text(
                              text('clear'),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'TTCommonsm',
                                  color: black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                bottom: 80,
                left: 0,
                right: 0,
                child: Container(
                    // height: 400,
                    margin: EdgeInsets.only(top: 15),
                    child: ListView(
                      children: [
                        Divider(
                          thickness: 1,
                          color: Color(Helper.getHexToInt("#707070"))
                              .withOpacity(0.1),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('Currently open'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter1.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter1.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('Offering discount'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter2.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter2.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('free_delivery'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter3.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter3.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            text('filter_by_menu'),
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'TTCommonsm',
                                color: Color(Helper.getHexToInt("#C4C4C4"))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 5,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('fries_&_wedges'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter4.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter4.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('thai_food'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter6.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter6.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('italian_food'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter7.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter7.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('indian'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter8.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter8.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: CheckboxListTile(
                              title: Text(text('chains_items'),
                                  style: TextStyle(
                                      fontFamily: 'TTCommonsm',
                                      fontSize: 16.0,
                                      color: Color(
                                          Helper.getHexToInt("#6F6F6F")))),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: searchCont.filter9.value,
                              onChanged: (bool? value) {
                                // Get.find<TestController>().filter1.toggle();
                                searchCont.filter9.toggle();
                                print(value);
                              },
                              activeColor: theamColor,
                              // checkColor: theamColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1,
                            color: Color(Helper.getHexToInt("#707070"))
                                .withOpacity(0.1),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: getFilter(),
                        // )
                      ],
                    )),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: getFilter(),
                ),
              )
            ],
          ),
        ));
  }

  Widget getFilter() {
    return InkWell(
      onTap: () {
        // var addrestype = searchController.text;
        // mymapcont.savelocation(addrestype);
        //searchCont.itemList.where(() => );
        print('RES LIST =}');

        searchCont.filter('delivery_charge');
        //  searchCont.searchData(searchController.text);
        // searchCont.searchData('');

        Get.off(SearchResult());
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Color(Helper.getHexToInt("#11C7A1")),
            Color(Helper.getHexToInt("#11E4A1"))
          ]),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
            child: Text(
          text('apply_filter'),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'TTCommonsm',
          ),
        )),
      ),
    );
  }
}
