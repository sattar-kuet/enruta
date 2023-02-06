import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AddCreditProvider with ChangeNotifier {
  String url = "https://core.spreedly.com/v1/payment_methods.json";
  dynamic headers = {
    'Authorization':
        'Basic NnhNbnZuc3lDbnJvWE1lTTZTMExlVFJiYndqOlQ2VkxETWQycG4zNWptNFkzNFUzcDVkdjlCSENpSUowVGRjVVh5WGRaNW9VYng0OW84aWt3WW5uenZrTDBRZUE=',
    'Content-Type': 'application/json'
  };
  Future<void> addCreditCard() async {
    try {
      Response response = await http.post(
        Uri.parse(
          url,
        ),
        headers: headers,
        body: json.encode(
          {
            "payment_method": {
              "credit_card": {
                "first_name": "Joe",
                "last_name": "Jones",
                "number": "5555555555554444",
                "verification_value": "423",
                "month": "3",
                "year": "2029",
                "company": "Acme Inc.",
                "address1": "33 Lane Road",
                "address2": "Apartment 4",
                "city": "Wanaque",
                "state": "NJ",
                "zip": "31331",
                "country": "US",
                "phone_number": "919.331.3313",
                "shipping_address1": "33 Lane Road",
                "shipping_address2": "Apartment 4",
                "shipping_city": "Wanaque",
                "shipping_state": "NJ",
                "shipping_zip": "31331",
                "shipping_country": "US",
                "shipping_phone_number": "919.331.3313"
              },
              "email": "joey@example.com",
              "metadata": {
                "key": "string value",
                "another_key": 123,
                "final_key": true
              }
            }
          },
        ),
      );
      dynamic createData = jsonDecode(response.body);
      print(createData);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
