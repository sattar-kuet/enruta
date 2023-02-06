// import 'package:enruta/controllers/cartController.dart';
// import 'package:enruta/helper/style.dart';
// import 'package:enruta/screen/setLocation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// enum DialogAction { yes, abort }

// class Dialogs {
//   final CartController cartCont = Get.put(CartController());
//   static Future<DialogAction> yesAbortDialog(
//     BuildContext context,
//     String title,
//     String body,
//   ) async {
//     final action = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           // title: Text(title),
//           content: Container(
//             height: Get.height / 5,
//             child: Column(
//               children: [
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: Text("Order Method"),
//                 ),
//                 Divider(
//                   thickness: 1,
//                 ),
//                 // addresstype(context),
//               ],
//             ),
//           ),
//         );

//         // AlertDialog(
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(10),
//         //   ),
//         //   title: Text(title),
//         //   content: Text("sdfsdf"),
//         //   actions: <Widget>[
//         //     FlatButton(
//         //       onPressed: () => Navigator.of(context).pop(DialogAction.abort),
//         //       child: const Text('No'),
//         //     ),
//         //     RaisedButton(
//         //       onPressed: () => Navigator.of(context).pop(DialogAction.yes),
//         //       child: const Text(
//         //         'Yes',
//         //         style: TextStyle(
//         //           color: Colors.white,
//         //         ),
//         //       ),
//         //     ),
//         //   ],
//         // );
//       },
//     );
//     return (action != null) ? action : DialogAction.abort;
//   }

//   Widget addresstype(BuildContext context) {
//     return Container(
//         height: 140,
//         width: Get.width,
//         child: Column(
//           children: [
//             Divider(
//               thickness: 1,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Center(
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: InkWell(
//                       onTap: () {
//                         cartCont.deliverOption.value = "pick up";
//                         cartCont.deliveryType.value = 0;
//                         print(cartCont.deliverOption.value);
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         height: 100,
//                         width: Get.width / 5,
//                         padding: EdgeInsets.only(top: 20),
//                         margin: EdgeInsets.only(left: 20, right: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: white,
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 40,
//                               width: 40,
//                               //  child: Image.asset("assets/icons/shout.png"),
//                               child: Image.asset(
//                                 "assets/icons/take-away@2x.png",
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             SafeArea(
//                               child: Container(
//                                 height: 20,
//                                 child: Text("Pick Up",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.black,
//                                       fontFamily: 'TTCommonsm',
//                                     )),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: InkWell(
//                       onTap: () {
//                         cartCont.deliveryType.value = 1;
//                         Navigator.of(context).pop();
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SetLocation()));
//                         // Navigator.of(context).pop();
//                         // Get.to(SetLocation());
//                       },
//                       child: Container(
//                         height: 100,
//                         width: Get.width / 5,
//                         padding: EdgeInsets.only(top: 20),
//                         margin: EdgeInsets.only(right: 20, left: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: white,
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 40,
//                               width: 40,
//                               //  child: Image.asset("assets/icons/directions_bikes-24px"),
//                               child: Image.asset(
//                                 "assets/icons/directions_bike-24px.png",
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               height: 20,
//                               child: Text("Delivery",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black,
//                                     fontFamily: 'TTCommonsm',
//                                   )),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
// }
