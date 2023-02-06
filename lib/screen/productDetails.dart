import 'package:enruta/controllers/cartController.dart';
import 'package:enruta/controllers/productController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/model/Product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  final Product menuitemdata;
  final String shopid;
  final double vat;
  final double deliveryCharge;

  ProductDetails({
    Key key,
    this.menuitemdata,
    this.shopid,
    this.vat,
    this.deliveryCharge,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final pController = Get.put(ProductController());

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            widgetPageViewHeader(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, top: 20.0, right: 24.0),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildWidgetProductName(context),
                              SizedBox(
                                height: 10,
                              ),
                              // ListView.builder(
                              //     itemCount: 4,
                              //     scrollDirection: Axis.vertical,
                              //     itemBuilder: (context, index) {
                              //       return productColor();
                              //     }),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            "COLOR",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'TTCommonsm',
                                                color: Color(Helper.getHexToInt(
                                                    "#8D92A3"))),
                                          ),
                                        ),
                                      ),

                                      // productColor(true, "#F5003C"),
                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      // productColor(false, "#F5C300"),
                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      // productColor(false, "#00C6F5"),
                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      // productColor(false, "#7800F5"),

                                      Expanded(
                                        flex: 2,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget
                                                .menuitemdata.colors.length,
                                            itemBuilder: (context, index) {
                                              return productColor(
                                                  widget.menuitemdata
                                                      .colors[index],
                                                  index);
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            "SIZE",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'TTCommonsm',
                                                color: Color(Helper.getHexToInt(
                                                    "#8D92A3"))),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget
                                                .menuitemdata.sizes.length,
                                            itemBuilder: (context, index) {
                                              return productSize(
                                                  index,
                                                  widget.menuitemdata
                                                      .sizes[index]);
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              // _buildWidgetProductPrice(context),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 16.0),
                                child: Divider(
                                    thickness: 1,
                                    color: Color(
                                      Helper.getHexToInt("#F1F3F8"),
                                    )),
                              ),
                              // WidgetChooseColor(),
                              SizedBox(height: 5.0),
                              // WidgetChooseSize(),
                              buidbottomfield(),
                              // _buildWidgetProductInfo(context),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetProductName(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  widget.menuitemdata.title,
                  style: TextStyle(
                      fontFamily: "TTCommonsm",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(Helper.getHexToInt("#000000"))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 10, 0),
              child: Text(
                "\$" + widget.menuitemdata.price.toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'TTCommonsd',
                    fontWeight: FontWeight.bold,
                    color: Color(Helper.getHexToInt("#11C7A1"))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildWidgetProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'This is a beautiful women Mini Dress for your daily look, '
                  'it is elegance meets... ',
              style: Theme.of(context)
                  .textTheme
                  // ignore: deprecated_member_use
                  .bodyText2
                  .merge(TextStyle(fontSize: 16.0)),
            ),
            TextSpan(
                text: 'More',
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.bodyText2.merge(
                      TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
          ],
        ),
      ),
    );
  }

  Widget buidbottomfield() {
    return InkWell(
      onTap: () {
        // Get.bottomSheet();
        widget.menuitemdata.selectcolor = widget.menuitemdata.pcolor.value;
        widget.menuitemdata.selectSize = widget.menuitemdata.psize.value;
        print(
            "shopid : ${widget.shopid}  vat:${widget.vat}  Size : ${widget.menuitemdata.selectSize} color: ${widget.menuitemdata.selectcolor}");
        widget.menuitemdata.qty = widget.menuitemdata.pqty.toInt();

        cartController.additemtocarts(widget.menuitemdata, widget.shopid,
            widget.vat, widget.deliveryCharge);

        // menuitemdata.selectcolor = menuitemdata.pcolor.value;
        // menuitemdata.selectSize = menuitemdata.psize.value;
        cartController.isInChart(widget.shopid, widget.menuitemdata);
        Get.back();

        // GetStorage box = GetStorage();
        // box.write("cartList", Get.find<CartController>().cartList);
        // box.write("shopid", shopid);
        // box.write("vat", vat);
        // box.write("deliveryCharge", deliveryCharge);
        // print(vat);
        // box.write("shopid", shopid);
        // print("object");
      },
      child: Stack(
        children: [
          Container(
            height: 60,
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
              "Add to Cart",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'TTCommonsm',
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget widgetPageViewHeader() {
    final listImageHeader = widget.menuitemdata.logo;

    var heightImage = Get.height / 1.3;
    return Container(
      height: heightImage,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemBuilder: (context, index) {
              return Image.network(
                widget.menuitemdata.logo[index],
                fit: BoxFit.cover,
                width: Get.width,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Center(
                      child: Image.asset(
                    "assets/icons/image.png",
                    scale: 5,
                  ));
                },
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Center(child: LinearProgressIndicator());
                },
              );
            },
            itemCount: listImageHeader.length,
            onPageChanged: (index) {
              pController.changeIndex(index);
              print(pController.position.value);
              // setState(() {
              //   _indexHeader = index;
              // });
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Get.height / 2.1,
              right: 20,
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  for (int i = 0; i < listImageHeader.length; i++)
                    if (i == pController.position.value)
                      circleBar(true)
                    else
                      circleBar(false),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                )),
          ),
        ],
      ),

      //  Image.network(menuitemdata.logo[0],
      //     fit: BoxFit.fill, width: Get.width, errorBuilder:
      //         (BuildContext context, Object exception, StackTrace stackTrace) {
      //   return Center(
      //       child: Image.asset(
      //     "assets/icons/image.png",
      //     scale: 5,
      //   ));
      // }
      // loadingBuilder: (context, child, progress) {
      //   return progress == null
      //       ? child
      //       : LinearProgressIndicator();
      // },
      // ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isActive ? 16 : 12,
      width: isActive ? 16 : 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: isActive ? Color(Helper.getHexToInt("#11C4A1")) : null,
        // border: isActive
        //     ? Border.all(color: Color(Helper.getHexToInt("#11C4A1")))
        //     : null,
      ),
      padding: EdgeInsets.all(isActive ? 4.0 : 0.0),
      child: Container(
        width: isActive ? 16 : 16,
        height: isActive ? 16 : 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(Helper.getHexToInt("#11C4A1")).withOpacity(0.22),
        ),
      ),
    );
  }

  Widget productColor(String color, int index) {
    var pController = Get.put(ProductController());

    return Obx(() {
      bool isActive = pController.colorSelect.value == index;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              pController.colorSelect(index);
              widget.menuitemdata.pcolor(color);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: isActive ? 50 : 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  // color: isActive ? Color(Helper.getHexToInt("#11C4A1")) : null,
                  // image: isActive ? Icon(Icons.check_circle, color: white) :null,

                  // image: ImageIcon(Icons.ac_unit),
                  border: isActive
                      ? Border.all(
                          color: color == "#FFFFFF"
                              ? Colors.black12
                              : Color(Helper.getHexToInt(color)),
                          width: 3,
                        )
                      : Border.all(
                          color: color == "#FFFFFF"
                              ? Colors.black12
                              : Color(Helper.getHexToInt(color)),
                          width: 3,
                        )),
              padding: EdgeInsets.all(2),
              child: Container(
                width: isActive ? 50 : 50,
                height: isActive ? 50 : 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Color(Helper.getHexToInt(color))),
                child: isActive
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: color == "#FFFFFF"
                              ? Colors.black54
                              : Colors.white,
                          size: 25,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget productSize(int index, String size) {
    var pController = Get.put(ProductController());

    return Obx(() {
      bool isActive = pController.sizeSelect.value == index;
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              pController.sizeSelect(index);
              widget.menuitemdata.psize(size);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: isActive ? 40 : 40,
              width: isActive ? 40 : 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: isActive
                    ? Color(Helper.getHexToInt("#11E5A1"))
                    : Color(Helper.getHexToInt("#F7F8FA")),
                // border: isActive
                //     ? Border.all(color: Color(Helper.getHexToInt("#F7F8FA")))
                //     : null,
              ),
              padding: EdgeInsets.all(isActive ? 0.0 : 0.0),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'TTCommonsm',
                      color: isActive
                          ? white
                          : Color(Helper.getHexToInt("#8D92A3"))),
                ),
                // width: isActive ? 40 : 40,
                // height: isActive ? 40 : 40,
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(20)),
                //     color: Color(Helper.getHexToInt("#F7F8FA"))),
              ),
            ),
          ),
        ],
      );
    });
  }
}
