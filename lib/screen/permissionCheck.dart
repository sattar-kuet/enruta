// import 'package:enruta/helper/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';


// import 'homePage.dart';

// class PermissionCheckScreen extends StatefulWidget {
//   @override
//   _PermissionCheckScreenState createState() => _PermissionCheckScreenState();
// }

// class _PermissionCheckScreenState extends State<PermissionCheckScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         padding: EdgeInsets.only(top: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               "assets/images/locationicon.png",
//               height: 80,
//               width: 80,
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
//               decoration: BoxDecoration(),
//               child: Center(
//                 child: Text(
//                     "This app collects location data to enable your nearby resturants and your address for tracking delevery items, even when the app is closed or not in use ",
//                     maxLines: 10,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 18.0,
//                         color: Colors.black)),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 await Geolocator().getCurrentPosition();
//                 var permission =
//                     await Geolocator().checkGeolocationPermissionStatus();
//                 if (permission != GeolocationStatus.denied) {
//                   Get.offAll(HomePage());
//                 } else {
//                   Get.defaultDialog(title: "Please give Permission first");
//                 }
//               },
//               child: Container(
//                 height: 50,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(Helper.getHexToInt("#11C7A1")),
//                 ),
//                 child: Center(
//                   child: Text("Give access",
//                       style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 15.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
