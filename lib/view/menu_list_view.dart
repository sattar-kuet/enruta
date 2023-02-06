import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/model/category_model.dart';
import 'package:enruta/screen/categorypage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItemView extends StatelessWidget {
  const MenuItemView(
      {Key key,
      this.categoryData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Category categoryData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.find<TestController>();
    return Container(
      child: InkWell(
        hoverColor: Color(Helper.getHexToInt("#11C4A1")),
        // child: Card(
        child: Container(
          margin: EdgeInsets.all(5),
          // duration: Duration(milliseconds: 500),
          // curve: Curves.easeIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          height: 10.0,
          width: 10.0,

          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: MediaQuery.of(context).size.width / 10,
                          child: Image.network(categoryData.icon,
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              scale: 10.0, errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                            return Center(
                                child: Image.asset(
                              "assets/icons/image.png",
                              scale: 5,
                            ));
                          }),
                        )),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 1, right: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(categoryData.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppinsr',
                              fontSize: 11.0,
                              color: Color(Helper.getHexToInt("#6F6F6F")),
                            )),
                      ],
                    ),
                  ),
                )
              ]),
        ),
        // ),
        onTap: () {
          // print("categorypage");

          Get.to(CategoryPage(
              pageTitle: categoryData.name, pageType: categoryData.id));
          // if (cardTitle == "Restarurant") {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => CategoryPage(
          //         pageTitle: categoryData.name, pageType: categoryData.id)));
          // selectCard(cardTitle);
          // }

          // Route route = MaterialPageRoute(
          //                                  builder: (context) => CategoryPage());
          //                              Navigator.push(context, route);
        },
      ),
    );
  }
}
