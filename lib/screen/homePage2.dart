import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/cartPage.dart';
import 'package:enruta/screen/resetpassword/resetController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'homePage.dart';

class HomePaget extends StatefulWidget {
  @override
  _HomePagetState createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePaget> {
  int _curentIndex = 0;
  final List<Widget> _children = [
    CartPage(),
    HomePage(),
    CartPage(),
    CartPage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(ResetController());
    return Scaffold(
        body: _children[_curentIndex],
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Color(Helper.getHexToInt("#6F6F6F")),
              unselectedItemColor: Color(Helper.getHexToInt("##929292")),
              // selectedFontSize: 14,
              // unselectedFontSize: 14,
              // new

              currentIndex:
                  _curentIndex, // this will be set when a new tab is tapped
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
              onTap: (index) {
                setState(() {
                  _curentIndex = index;
                });
              },
            ),
          ),
        ));
  }
}
