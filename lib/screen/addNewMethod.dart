import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enruta/controllers/language_controller.dart';
import 'package:enruta/controllers/paymentController.dart';
import 'package:enruta/controllers/productController.dart';
import 'package:enruta/helper/helper.dart';
import 'package:enruta/helper/style.dart';

import 'package:flutter/material.dart';

import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

// ignore: must_be_immutable
class AddNewMethod extends StatefulWidget {
  @override
  State<AddNewMethod> createState() => _AddNewMethodState();
}

class _AddNewMethodState extends State<AddNewMethod> {
  List imgList = [0, 1, 2];

  final pController = Get.put(ProductController());

  final payController = Get.put(PaymentController());

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final cardHName = TextEditingController();

  final cardNumber = TextEditingController();

  final expaireDate = TextEditingController();

  final cvvCode = TextEditingController();
  bool isLoading = false;

  OutlineInputBorder border;

  final language = Get.put(LanguageController());

  String text(String key) {
    return language.text(key);
  }

  List<GlobalKey<FormState>> _formKeys = [];

  final _formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    // print("helooo world");
    // addCreditCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(text('add_new_card'),
            style: TextStyle(
                fontFamily: 'Poppinsm', fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          card(),
          Container(
            // margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreditCardForm(
                  formKey: _formGlobalKey,
                  obscureCvv: false,
                  obscureNumber: false,
                  cardNumber: cardNumber.text,
                  cvvCode: cvvCode.text,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,

                  isExpiryDateVisible: true,
                  cardHolderName: cardHName.text,
                  expiryDate: expaireDate.text,
                  themeColor: Colors.green,
                  textColor: Colors.black,
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: border,
                    enabledBorder: border,
                  ),
                  expiryDateDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'Expired Date',
                  ),
                  cvvCodeDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'CVV',
                    hintText: 'XXX',
                  ),
                  cardHolderDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: border,
                    enabledBorder: border,
                    labelText: 'Card Holder',
                  ),
                  onCreditCardModelChange: (creditCardModel) {
                    setState(() {
                      cardNumber.text = creditCardModel.cardNumber;
                      expaireDate.text = creditCardModel.expiryDate;
                      cardHName.text = creditCardModel.cardHolderName;
                      cvvCode.text = creditCardModel.cvvCode;
                      // isCvvFocused = creditCardModel.isCvvFocused;
                    });
                  },

                  // onCreditCardModelChange: onCreditCardModelChange,
                ),
                //       Text(
                //         text('card_holder_name'),
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Color(Helper.getHexToInt("#22242A"))
                //               .withOpacity(0.44),
                //           fontFamily: 'TTCommonsm',
                //         ),
                //       ),
                //       Container(
                //         child: TextFormField(
                //           validator: (value) {
                //             if (value == null || (value.isEmpty)) {
                //               return "Please enter a card name";
                //             }
                //             return null;
                //           },
                //           autovalidateMode: _autovalidateMode,
                //           decoration: InputDecoration(
                //             hintText: "Jahid Jaykar",
                //             hintStyle: TextStyle(
                //               color: Color(Helper.getHexToInt("#22242A"))
                //                   .withOpacity(.1),
                //               fontSize: 16.0,
                //             ),
                //             // border: InputBorder.none,
                //           ),
                //           // focusNode: payController.myFocusNode,
                //           controller: cardHName,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20, top: 26),
                //   // margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                //   alignment: Alignment.centerLeft,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         text('card_number'),
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Color(Helper.getHexToInt("#22242A"))
                //               .withOpacity(0.44),
                //           fontFamily: 'TTCommonsm',
                //         ),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Expanded(
                //             child: Container(
                //               // height: 40,
                //               // width: MediaQuery.of(context).size.width * 0.9,
                //               child: TextFormField(
                //                 autovalidateMode: _autovalidateMode,
                //                 inputFormatters: [
                //                   CreditCardNumberInputFormatter(),
                //                 ],
                //                 validator: (value) {
                //                   if (value == null || (value.isEmpty)) {
                //                     return "Please enter a card number";
                //                   }
                //                   return null;
                //                 },
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(
                //                   hintText: "5560  1209  0987  4312",

                //                   hintStyle: TextStyle(
                //                     color: Color(Helper.getHexToInt("#22242A"))
                //                         .withOpacity(.1),
                //                     fontSize: 16.0,
                //                   ),
                //                   // border: InputBorder.none,
                //                   // border: OutlineInputBorder(
                //                   //   borderRadius: BorderRadius.circular(20.0),
                //                   // ),
                //                 ),
                //                 controller: cardNumber,
                //               ),
                //             ),
                //           ),
                //           Container(
                //             width: 50,
                //             height: 15,
                //             alignment: Alignment.centerRight,
                //             // decoration: BoxDecoration(
                //             // image: DecorationImage(
                //             child: Image.network(
                //                 'https://img.pngio.com/visa-card-logo-2020-visa-logo-png-5000_1533.png',
                //                 fit: BoxFit.fill),
                //             //  ),
                //             // ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                //   // margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                //   alignment: Alignment.centerLeft,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Expanded(
                //             child: Text(
                //               text('expire_date'),
                //               textAlign: TextAlign.left,
                //               style: TextStyle(
                //                 fontSize: 14,
                //                 color: Color(Helper.getHexToInt("#22242A"))
                //                     .withOpacity(0.44),
                //                 fontFamily: 'TTCommonsm',
                //               ),
                //             ),
                //           ),
                //           Expanded(
                //             child: Text(
                //               "CVV",
                //               textAlign: TextAlign.left,
                //               style: TextStyle(
                //                 fontSize: 14,
                //                 color: Color(Helper.getHexToInt("#22242A"))
                //                     .withOpacity(0.44),
                //                 fontFamily: 'TTCommonsm',
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Expanded(
                //             child: TextFormField(
                //               autovalidateMode: _autovalidateMode,
                //               validator: (value) {
                //                 if (value == null || (value.isEmpty)) {
                //                   return "Please enter a expir date";
                //                 }
                //                 return null;
                //               },
                //               keyboardType: TextInputType.number,
                //               inputFormatters: [
                //                 CreditCardExpirationDateFormatter(),
                //               ],
                //               decoration: InputDecoration(
                //                 hintText: "06/24",
                //                 hintStyle: TextStyle(
                //                   color: Color(Helper.getHexToInt("#22242A"))
                //                       .withOpacity(.1),
                //                   fontSize: 16.0,
                //                 ),
                //                 // border: InputBorder.none,
                //               ),
                //               controller: expaireDate,
                //             ),
                //           ),
                //           const SizedBox(width: 10),
                //           Expanded(
                //             child: TextFormField(
                //               autovalidateMode: _autovalidateMode,
                //               validator: (value) {
                //                 if (value == null || (value.isEmpty)) {
                //                   return "Please enter a cvv";
                //                 }
                //                 return null;
                //               },
                //               keyboardType: TextInputType.number,
                //               inputFormatters: [
                //                 CreditCardCvcInputFormatter(),
                //               ],
                //               decoration: InputDecoration(
                //                 hintText: "556 ",
                //                 hintStyle: TextStyle(
                //                   color: Color(Helper.getHexToInt("#22242A"))
                //                       .withOpacity(.1),
                //                   fontSize: 16.0,
                //                 ),
                //                 // border: InputBorder.none,
                //               ),
                //               controller: cvvCode,
                //             ),
                //           )
                //         ],
                //       ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          isLoading == true
              ? Center(child: CircularProgressIndicator())
              : orderbottomfield(),
        ],
      ),
    );
  }

  bool useGlassMorphism = false;

  // bool isCvvFocused = false;

  Widget card() {
    var heightImage = Get.height / 3.0;
    return Container(
      child: Column(
        children: [
          Container(
            child: CarouselSlider(
                items: imgList.map((i) {
                  return Builder(builder: (BuildContext context) {
                    return CreditCardWidget(
                      glassmorphismConfig: useGlassMorphism
                          ? Glassmorphism.defaultConfig()
                          : null,
                      expiryDate: "MM/yy",
                      cardHolderName: "CARD HOLDER",
                      cvvCode: "***",
                      showBackView: false,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: false,
                      cardBgColor: theamColor,
                      height: 180,
                      isSwipeGestureEnabled: false,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            'assets/mastercard.png',
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ],
                      cardNumber: '',
                    );
                  });
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  height: 230,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    pController.changeIndex(index);
                    print(pController.position.value);
                  },
                )),
          ),
          // Container(
          //   padding: EdgeInsets.only(right: 20, top: 10),
          //   child: Obx(
          //     () => Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: <Widget>[
          //         for (int i = 0; i < imgList.length; i++)
          //           if (i == pController.position.value)
          //             circleBar(true)
          //           else
          //             circleBar(false),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
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

  Widget orderbottomfield() {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            if (_formGlobalKey.currentState.validate()) {
              _autovalidateMode = AutovalidateMode.always;

              // Get.back();
            }
            await addCreditCard();
            print(cardHName.text);
            print(cardNumber.text);
            print(expaireDate.text);
            print(cardNumber.text);
            // Navigator.pop(context);
            print("hello");
            // showSuccessfullyBottompopup(context);
          },
          child: Container(
            height: 57,
            margin: EdgeInsets.symmetric(horizontal: 30),
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
              text('ADD_CARD'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'TTCommonsm',
              ),
            )),
          ),
        ),
      ],
    );
  }

  dynamic createData;
  Future<void> addCreditCard() async {
    try {
      setState(() {
        isLoading = true;
      });
      String url = "https://core.spreedly.com/v1/payment_methods.json";
      dynamic headers = {
        'Authorization':
            'Basic NnhNbnZuc3lDbnJvWE1lTTZTMExlVFJiYndqOlQ2VkxETWQycG4zNWptNFkzNFUzcDVkdjlCSENpSUowVGRjVVh5WGRaNW9VYng0OW84aWt3WW5uenZrTDBRZUE=',
        'Content-Type': 'application/json'
      };
      List expir = expaireDate.text.split("/");
      print(cardNumber.text);
      print(expir[1]);

      List cardName = cardHName.text.split(" ");
      print(cardName[1]);
      print(json.encode(
        {
          "payment_method": {
            "credit_card": {
              "first_name": cardName[0] ?? cardHName.text,
              "last_name": cardName[1] ?? "",
              "number": cardNumber.text.split(" ").join(""),
              "verification_value": cvvCode.text,
              "month": expir[0],
              "year": "20" + expir[1],
            },
          }
        },
      ));
      dynamic response = await http.post(
        Uri.parse(
          url,
        ),
        headers: headers,
        body: json.encode({
          "payment_method": {
            "credit_card": {
              "first_name": cardName[0] ?? cardHName.text,
              "last_name": cardName[1] ?? "",
              "number": cardNumber.text.split(" ").join(""),
              "verification_value": cvvCode.text,
              "month": expir[0],
              "year": "20" + expir[1],
            },
          }
        }),
      );
      createData = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      print("***************************************$createData");
      if (response.statusCode == 201) {
        Get.back();
      } else {
        Fluttertoast.showToast(msg: createData["errors"][0]["message"]);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


 
}
