import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/productController.dart';
import 'package:enruta/controllers/textController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/screen/myFavorite/myFavoriteView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite();

  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  final tController = Get.put(TestController());

  fetchData() async {
    await tController.getFavList();

    // itemList.refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final pController = Get.put(ProductController());

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
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
          title: Text(text('my_favorite'), style: TextStyle(fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
          centerTitle: true,
        ),
        body: Obx(() => tController.spinFav.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : tController.nearFavList.isEmpty
                ? Container(
                    margin: EdgeInsets.all(50),
                    child: Center(
                        child: EmptyWidget(
                            title: text('no_favorite'),
                            subTitle: text('no_current_favorite_available_yet'),
                            // image: 'assets/images/userIcon.png',
                            image: null,
                            packageImage: PackageImage.Image_2,
                            // ignore: deprecated_member_use
                            titleTextStyle: Theme.of(context)
                                .typography
                                .dense
                                // ignore: deprecated_member_use
                                .headline4!
                                .copyWith(color: Color(0xff9da9c7)),
                            // ignore: deprecated_member_use
                            subtitleTextStyle: Theme.of(context)
                                .typography
                                .dense
                                // ignore: deprecated_member_use
                                .bodyText1!
                                .copyWith(color: Color(0xffabb8d6)))),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.9 * 0.8,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: tController.nearFavList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return MyFavoriteView(
                        itemData: tController.nearFavList[index],
                        callback: () {
                          print(tController.nearFavList[index]!.shopId);
                          // ignore: unused_local_variable

                          var status = tController.nearFavList[index]!.isFavorite.value ? 0 : 1;
                          print(' STATUS ==$status');
                          print(' STATUS ==${tController.nearFavList[index]!.shopId}');
                          pController.sendfavorit(tController.nearFavList[index]!.shopId, status);

                          tController.nearFavList[index]!.isFavorite.toggle();
                          tController.nearFavList[index]!.favorite = !tController.nearFavList[index]!.favorite!;
                          if (!tController.nearFavList[index]!.isFavorite.value) {
                            tController.nearFavList.removeAt(index);
                            tController.polularShopList.forEach((element) {
                              if (element.catId == tController.nearFavList[index]!.catId) {
                                element.isFavorite.toggle();
                                element.favorite = !element.favorite!;
                              }
                            });
                          }

                          !tController.nearFavList[index]!.isFavorite.value
                              ? Get.snackbar('Added in Favourites', '', colorText: Colors.white)
                              : Get.snackbar('Removed from Favourites', '', colorText: Colors.white);
                        },
                      );
                    })));
  }
}
