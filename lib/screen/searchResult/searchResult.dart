import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/drawer/myDrawerPage.dart';
import 'package:enruta/screen/searchResult/searchController.dart';
import 'package:enruta/view/category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SearchResult extends StatelessWidget {
  // final pageTitle;
  // final int pageType;

  // SearchResult({this.pageTitle, this.pageType});
  TestController tController = Get.find();
  final searchCont = Get.put(SearchController());

  final language = Get.put(LanguageController());
  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: MyDrawerPage(),
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, colors: [
              Color(Helper.getHexToInt("#11C7A1")),
              // Colors.green[600],
              Color(Helper.getHexToInt("#11E4A1"))
            ]),
          ),
        ),
        backgroundColor: Color(Helper.getHexToInt("#11C7A1")),
        elevation: 0.0,
        title: Text(text('search_result'),
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.search,
          //       color: white,
          //     ),
          //     onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: white,
              ),
              onPressed: () {
                Get.bottomSheet(bottomsheetfilter());
              }),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    // color: Color(Helper.getHexToInt("#F8F9FF")),
                    padding: EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        new Row(
                          children: [
                            // Expanded(
                            Obx(() => Container(
                                margin: EdgeInsets.only(
                                    left: 20, bottom: 10, top: 20),
                                child: Text(
                                  '${searchCont.filterlength.value} ' +
                                      text('Shop found near you'),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )))
                          ],
                        ),
                        new Container(
                          child: GetBuilder<SearchController>(
                           builder: (_){return GridView.count(
                             crossAxisCount: 2,
                             controller:
                             new ScrollController(keepScrollOffset: false),
                             shrinkWrap: true,
                             scrollDirection: Axis.vertical,
                             padding: EdgeInsets.all(15),
                             childAspectRatio: 0.8,
                             children: List.generate(
                                 searchCont.filterData.length, (index) {
                               return CategoryListView(
                                 itemData: searchCont.searchDataList![index],
                               );
                             }),
                           );},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   height: 73,
            //   child: BottomNavigation(key as GlobalKey<ScaffoldState>?),
            // ),
          ],
        ),
      ),
    );
  }

  Widget errro() {
    return SizedBox(
      height: 0,
    );
  }

  Widget bottomsheetfilter() {
    return Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 20,
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
                                color: black),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
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
                              title: Text(text('Currently Open'),
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
                        // Container(
                        //   padding: EdgeInsets.only(left: 25),
                        //   child: Text(
                        //     text('filter_by_menu'),
                        //     style: TextStyle(
                        //         fontSize: 17,
                        //         fontFamily: 'TTCommonsm',
                        //         color: Color(Helper.getHexToInt("#C4C4C4"))),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // Container(
                        //   height: 5,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // Obx(
                        //   () => Container(
                        //     child: CheckboxListTile(
                        //       title: Text(
                        //           text('fries_&_wedges'),
                        //           style: TextStyle(
                        //               fontFamily: 'TTCommonsm',
                        //               fontSize: 16.0,
                        //               color: Color(
                        //                   Helper.getHexToInt("#6F6F6F")))),
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //       value: searchCont.filter4.value,
                        //       onChanged: (bool value) {
                        //         // Get.find<TestController>().filter1.toggle();
                        //         searchCont.filter4.toggle();
                        //         print(value);
                        //       },
                        //       activeColor: theamColor,
                        //       // checkColor: theamColor,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 3,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // Obx(
                        //   () => Container(
                        //     child: CheckboxListTile(
                        //       title: Text(
                        //           text('thai_food'),
                        //           style: TextStyle(
                        //               fontFamily: 'TTCommonsm',
                        //               fontSize: 16.0,
                        //               color: Color(
                        //                   Helper.getHexToInt("#6F6F6F")))),
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //       value: searchCont.filter6.value,
                        //       onChanged: (bool value) {
                        //         // Get.find<TestController>().filter1.toggle();
                        //         searchCont.filter6.toggle();
                        //         print(value);
                        //       },
                        //       activeColor: theamColor,
                        //       // checkColor: theamColor,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 3,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // Obx(
                        //   () => Container(
                        //     child: CheckboxListTile(
                        //       title: Text(
                        //           text('italian_food'),
                        //           style: TextStyle(
                        //               fontFamily: 'TTCommonsm',
                        //               fontSize: 16.0,
                        //               color: Color(
                        //                   Helper.getHexToInt("#6F6F6F")))),
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //       value: searchCont.filter7.value,
                        //       onChanged: (bool value) {
                        //         // Get.find<TestController>().filter1.toggle();
                        //         searchCont.filter7.toggle();
                        //         print(value);
                        //       },
                        //       activeColor: theamColor,
                        //       // checkColor: theamColor,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 3,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // Obx(
                        //   () => Container(
                        //     child: CheckboxListTile(
                        //       title: Text(
                        //           text('indian'),
                        //           style: TextStyle(
                        //               fontFamily: 'TTCommonsm',
                        //               fontSize: 16.0,
                        //               color: Color(
                        //                   Helper.getHexToInt("#6F6F6F")))),
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //       value: searchCont.filter8.value,
                        //       onChanged: (bool value) {
                        //         // Get.find<TestController>().filter1.toggle();
                        //         searchCont.filter8.toggle();
                        //         print(value);
                        //       },
                        //       activeColor: theamColor,
                        //       // checkColor: theamColor,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 3,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // Obx(
                        //   () => Container(
                        //     child: CheckboxListTile(
                        //       title: Text(
                        //           text('chains_items'),
                        //           style: TextStyle(
                        //               fontFamily: 'TTCommonsm',
                        //               fontSize: 16.0,
                        //               color: Color(
                        //                   Helper.getHexToInt("#6F6F6F")))),
                        //       controlAffinity: ListTileControlAffinity.leading,
                        //       value: searchCont.filter9.value,
                        //       onChanged: (bool value) {
                        //         // Get.find<TestController>().filter1.toggle();
                        //         searchCont.filter9.toggle();
                        //         print(value);
                        //       },
                        //       activeColor: theamColor,
                        //       // checkColor: theamColor,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 3,
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: Divider(
                        //     thickness: 1,
                        //     color: Color(Helper.getHexToInt("#707070"))
                        //         .withOpacity(0.1),
                        //   ),
                        // ),
                        // // Container(
                        //   padding: EdgeInsets.only(left: 20, right: 20),
                        //   child: getFilter(),
                        // )
                      ],
                    )),
              ),
              Positioned(
                bottom: 5,
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
      // onTap: () {
      //   var addrestype = textController.text;
      //   mymapcont.savelocation(addrestype);
      //   Get.back();
      // },
      child: InkWell(
        onTap: () {
          searchCont.filter('delivery_charge');
          Get.back();
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
      ),
    );
  }
}
