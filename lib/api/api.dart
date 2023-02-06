import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enruta/model/Response.dart';
import 'package:enruta/model/category_model.dart';
import 'package:enruta/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as g;
import 'package:get_storage/get_storage.dart' as gs;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// ignore: non_constant_identifier_names
final String BASE_URL = 'https://enruta.itscholarbd.com/api/v2';

Future loginUser(String email, String password) async {
  String url = BASE_URL + '/login';
  final response = await http.post(Uri.parse(url), headers: {"Accept": "Application/json"}, body: {'login': email, 'password': password});
  var convertedDatatojson = jsonDecode(response.body);
  return convertedDatatojson;
}

Future<Response> sendForm(String url, Map<String, dynamic> data, Map<String, File> files) async {
  String url = 'https://enruta.itscholarbd.com/api/v2/signup';
  // Map<String, File> f = FileImage(File(files.path));
  Map<String, MultipartFile> fileMap = {};
  for (MapEntry fileEntry in files.entries) {
    File file = fileEntry.value;
    String fileName = basename(file.path);
    fileMap[fileEntry.key] = MultipartFile(file.openRead(), await file.length(), filename: fileName);
  }
  data.addAll(fileMap);
  var formData = FormData.fromMap(data);
  Dio dio = new Dio();
  final response = await dio.post(url, data: formData, options: Options(contentType: 'multipart/form-data'));
  if (response.statusCode == 200) {
    var convertedDatatojson = jsonDecode(response.toString());
    var a = convertedDatatojson["status"];
    if (a == 1) {
      g.Get.snackbar("Welcome", "Registration  success", colorText: Colors.white);
      g.Get.offAll(LoginPage());
      return response;
    } else {
      g.Get.snackbar(" ", "Something wrong", colorText: Colors.white);
    }
    return response;

// return AllOrderModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get order List.');
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final dir = await getTemporaryDirectory();
  final byteData = await rootBundle.load(path);

  final file = File('${dir.path}/dummy.png');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

Future<dynamic> registration(String name, String address, String email, String password, String imageFile) async {
  if (imageFile == null) {
    imageFile = (await getImageFileFromAssets("assets/icons/profileimage.png")).path;
  }
  var request = http.MultipartRequest('POST', Uri.parse("https://enruta.itscholarbd.com/api/v2/signup"));
  print('path = $imageFile');
  request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.toString()));
  request.fields['user_id'] = '155';
  request.fields['name'] = name;
  request.fields['email'] = email;
  request.fields['password'] = password;
  request.fields['address'] = address;
  http.Response response = await http.Response.fromStream(await request.send());
  return jsonDecode(response.body);
  // var res = await request.send().then((value) async {
  //   final respStr = await value.stream;
  //
  // });
  //print("\n\n\n:::"+response.body.toString()+"\nImage:"+pk);

//   if (response.statusCode == 200) {
//     var convertedDatatojson = jsonDecode(response.body);
//
//     return convertedDatatojson;
// // return AllOrderModel.fromJson(jsonDecode(response.body));
//   } else {
//
//     //throw Exception('Failed to get order List.');
//     return jsonDecode(response.body);
//   }

// https://enruta.itscholarbd.com/api/v2/signup [POST]
}

const baseUrl = "https://enruta.itscholarbd.com/api";

class API {
  static Future categoryList() {
    var url = baseUrl + "/v2/categories";
    return http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
  }
}

Future<List<Category>> categoryList() async {
  var url = 'https://enruta.itscholarbd.com/api/v2/categories';
  //encode Map to JSON
  var response = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  );
  final responseJson = json.decode(response.body);

  // Iterable list = responseJson['categories'];
  Respons respons = new Respons();
  respons.categories = responseJson['categories'];

  // print(list);
  print(respons.categories);

  if (respons.categories != null) {
    return respons.categories;
  }
  return null;

  // if (responseJson['status'] == 200) {
  //   // return list.map((mod) => Category.fromJson(mod)).toList();
  // }
}
