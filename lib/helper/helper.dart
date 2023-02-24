import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'map_util.dart';

class Helper {
  static int getHexToInt(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  Future<Position> getCurrentPosition() async => await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  Future<String> getNearbyPlaces(double lat, double lng) async {
    final result = await MapUtil.searchByCameraLocation(LatLng(lat, lng));
    if (result != null && result.isEmpty) return '';

    final first = result!.first;

    if (first.formattedAddress != null) return first.formattedAddress!;

    final placeDetail = await MapUtil.getPlaceDetail(first.placeId);

    return placeDetail?.vicinity ?? placeDetail?.formattedAddress ?? placeDetail?.name ?? '';
  }

  Future<PlacesSearchResult?> getPlaceByText(String address) async {
    final result = await MapUtil.getPlaceByText(address);
    if (result != null && result.isEmpty) return null;

    return result!.first;
  }
}
