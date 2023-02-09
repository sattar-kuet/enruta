import 'package:empty_widget/empty_widget.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/orerder/curentOrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'curentOrderView.dart';

class AllOrder extends StatelessWidget {
  const AllOrder() : super();

  @override
  Widget build(BuildContext context) {
    final detailsController = Get.put(CurrentOrderController());

    final language = Get.put(LanguageController());

    String text(String key) {
      return language.text(key);
    }

    return Scaffold(
      backgroundColor: cardbackgroundColor,
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color(Helper.getHexToInt("#11C7A1")),
                Color(Helper.getHexToInt("#11E4A1"))
              ]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(text('my_current_order'), style: TextStyle(fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (detailsController.isLoading.value) return const Center(child: CircularProgressIndicator());

        if (detailsController.allCurrentOrderList.isEmpty)
          return Container(
            margin: EdgeInsets.all(50),
            child: Center(
                child: EmptyWidget(
                    title: text('no_order'),
                    subTitle: text('no_current_order_available_yet'),
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
          );

        final items = detailsController.allCurrentOrderList;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) => CurentOrderView(orderModel: items[index]),
        );
      }),
    );
  }
}
