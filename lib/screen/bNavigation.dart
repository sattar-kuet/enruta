import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/homePage.dart';
import 'package:enruta/screen/myAccount/myaccount.dart';
import 'package:enruta/screen/myOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  final List<Widget> bodyContent = [
    HomePage(),
    Text("asdsdasdasd"),
    MyOrder(),
    MyAccount(),
    Text("Infsdfsdfsdfo"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("getxNav"),
      // ),
      body: Obx(
        () => Center(
          child: bodyContent.elementAt(navController.selectedIndex),
        ),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: BottomNavigationBar(
              // type: BottomNavigationBarType.fixed,

              // type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Color(Helper.getHexToInt("#6F6F6F")),
              unselectedItemColor: Color(Helper.getHexToInt("##929292")),
              selectedFontSize: 14,
              unselectedFontSize: 14,

              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/home.svg"),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/search.svg"),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/list.svg"),
                  label: 'Order',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/user.svg"),
                  label: 'Account',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/icons/menu.svg"),
                  label: 'Menu',
                ),
              ],
              currentIndex: navController.selectedIndex,
              onTap: (index) => navController.selectedIndex = index,
            ),
          ),
        ),
      ),
    );
  }
  
}

class NavController extends GetxController {
  final _selectedIndex = 0.obs;

  get selectedIndex => this._selectedIndex.value;
  set selectedIndex(index) => this._selectedIndex.value = index;

  
}
