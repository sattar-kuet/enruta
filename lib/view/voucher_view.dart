import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';
import 'package:enruta/screen/voucher/voucher_model.dart';
import 'package:enruta/widgetview/textwidget.dart';
import 'package:enruta/widgetview/voucherpanel.dart';
import 'package:flutter/material.dart';

class VoucherView extends StatelessWidget {
  const VoucherView(
      {Key key,
      this.voucherData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Voucher voucherData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return
        // voucherData.title != null
        //   ?
        Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Stack(
          children: [
            VoucherPanelWidget(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              isCornerRounded: true,
              color: Color(Helper.getHexToInt("#6EFFD1")),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.all(1.2),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(1),
              child: TextWidget(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                isCornerRounded: true,
                color: Color(Helper.getHexToInt("#EFFFFA")),
                child: InkWell(
                  onTap: () {
                    print("here");
                  },
                  child: Stack(
                    // ignore: deprecated_member_use
                    //overflow: Overflow.visible,
                    children: [
                      Positioned(
                        top: 13,
                        left: 16,
                        child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            child: Text(
                              voucherData.title ?? "",
                              style: TextStyle(
                                fontFamily: "TTCommonsd",
                                fontSize: 16,
                                color: black,
                              ),
                            )),
                      ),
                      Positioned(
                          top: 38,
                          left: 16,
                          child: Center(
                            child: Text(
                              voucherData.code ?? "",
                              style: TextStyle(
                                  fontFamily: "TTCommonsd",
                                  fontSize: 14,
                                  color: Color(Helper.getHexToInt("#9F9F9F"))),
                            ),
                          )),
                      Positioned(
                        bottom: 21,
                        left: 16,
                        right: 20,
                        child: Center(
                            child: Text(
                          "\$" + voucherData.minOrder.toString() ??
                              "" + " minimum",
                          style: TextStyle(
                            fontFamily: "TTCommonsd",
                            fontSize: 11,
                            color: text1Color,
                          ),
                        )),
                      ),
                      Positioned(
                          bottom: 20,
                          right: 20,
                          child: Center(
                            child: Text(
                              voucherData.validity.toString() ?? "",
                              style: TextStyle(
                                  fontFamily: "TTCommonsd",
                                  fontSize: 14,
                                  color: Color(Helper.getHexToInt("#9F9F9F"))),
                            ),
                          )),
                      Positioned(
                          top: 13,
                          right: 20,
                          child: Container(
                            height: 25,
                            // width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color: Color(Helper.getHexToInt("#C5FFEC"))
                                  .withOpacity(0.67),
                            ),
                            child: Center(
                              child: Text(
                                "\$" + voucherData.discount.toString() ?? "",
                                style: TextStyle(
                                    fontFamily: "TTCommonsd",
                                    fontSize: 14,
                                    color:
                                        Color(Helper.getHexToInt("#9F9F9F"))),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    // : SizedBox(
    //     height: 0,
    //   );
  }
}
