import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/bottomnavigation/bottomController.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/myAccount/myaccount.dart';
import 'package:enruta/screen/myFavorite/myFavorite.dart';
import 'package:enruta/screen/orerder/allorder.dart';
import 'package:enruta/screen/searchResult/searchController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// @immutable
// ignore: must_be_immutable
class BottomNavigation extends StatefulWidget {
  GlobalKey<ScaffoldState>? key;

  BottomNavigation(this.key);

  // void onTabTappeds(BuildContext context) {
  //   if (_currentIndex == 0) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //       (Route<dynamic> route) => false,
  //     );
  //   } else if (_currentIndex == 1) {
  //     print("one");
  //   } else if (_currentIndex == 2) {
  //     print("two");
  //   } else if (_currentIndex == 3) {
  //     print("three");
  //   }
  // }

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final search = Get.put(SearchController());

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  @override
  Widget build(BuildContext context) {
    final bottomController = Get.put(BottomController());

    void onTabTapped(int index) {
      print(index);
      if (index == 0) {
        // if (currentScrreen != 0) {
        //   currentScrreen = index;
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomePage()),
        //     (Route<dynamic> route) => false,
        //   );
        // }

        // controller.getPopularShops();
        Get.to(HomePage());
      } else if (index == 1) {
        print("one");

        Get.to(MyFavorite());
      } else if (index == 2) {
        // if (currentScrreen != index) {
        //   currentScrreen = index;
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyOrder()),
        //   (Route<dynamic> route) => true,
        // );
        Get.to(AllOrder());
        // Get.showSnackbar(goHomebottomfield(context));
        // }
        print("two");
      } else if (index == 3) {
        print("three");
        Get.to(MyAccount());
      } else if (index == 4) {
        print("four");
        Scaffold.of(widget.key!.currentContext!).openDrawer();
        // Get.to(GetReviewPage());
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(15), topRight: Radius.circular(15)
          ),
      child: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Color(Helper.getHexToInt("#11C7A1"))),
        selectedItemColor: Color(Helper.getHexToInt("#11C7A1")),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        // selectedIconTheme: IconThemeData(
        //   color: Color(Helper.getHexToInt("#11C4A1")),
        // ),
        // unselectedIconTheme: IconThemeData(
        //   color: Color(Helper.getHexToInt("#929292")),
        // ),
        // selectedItemColor: Color(Helper.getHexToInt("#11C4A1")),
        // unselectedItemColor: Color(Helper.getHexToInt("#929292")),

        // selectedLabelStyle: TextStyle(
        //     color: Color(Helper.getHexToInt("#11C4A1")), fontSize: 10),
        // unselectedLabelStyle: TextStyle(
        //     color: Color(Helper.getHexToInt("#929292")), fontSize: 10),
        onTap: (v) {
          if (v != 4) {
            bottomController.curentPage(v);
          }
          print("tapped $v");

          onTabTapped(v);
        },
        // new

        currentIndex: bottomController.curentPage.value,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home.svg",
              color: bottomController.curentPage.value == 0 ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292")),
            ),
            label: text('home'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/heartq.svg",
              height: 22,
              width: 22,
              color: bottomController.curentPage.value == 1 ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292")),

              //color: Color(Helper.getHexToInt("#929292"))
            ),
            label: text('favorite'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/list.svg",
              color: bottomController.curentPage.value == 2 ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292")),

              //color: Color(Helper.getHexToInt("#929292"))
            ),
            label: text('order'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/user.svg",
              color: bottomController.curentPage.value == 3 ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292")),

              //color: Color(Helper.getHexToInt("#929292")),
            ),
            label: text('account'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/menu.svg",
              color: bottomController.curentPage.value == 4 ? Color(Helper.getHexToInt("#11C4A1")) : Color(Helper.getHexToInt("#929292")),

              //color: Color(Helper.getHexToInt("#929292")),
            ),
            label: text('menu'),
          ),
        ],
      ),
    );
  }

  Widget goHomebottomfield(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            //   (Route<dynamic> route) => false,
            // );
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                // Colors.green[600],
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              // color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
                child: Text(
              text('go_to_home_page'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'TTCommonsm',
              ),
            )),
          ),
        ),
      ],
    );
  }
}
