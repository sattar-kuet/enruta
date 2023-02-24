import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class MapUtil {
  // static final _apiKey = 'AIzaSyAH6DZSt3tjE7lIrdPe4aCRdxFdiI4wJ8Y';
  static final _apiKey = 'AIzaSyATKB_VySXKb6yTpajxWx4aqxVAqH7BgKs';
  static final _places = GoogleMapsPlaces(apiKey: _apiKey);
  static final _geocoding = GoogleMapsGeocoding(apiKey: _apiKey);
  static const _language = 'en';
  static const _region = 'bd';

  static Future<List<PlacesSearchResult>?> searchNearbyPlaces(LatLng latLng) async {
    final PlacesSearchResponse response = await _places.searchNearbyWithRadius(
      Location(lat: latLng.latitude, lng: latLng.longitude),
      25,
      language: _language,
    );

    if (response.errorMessage?.isNotEmpty == true || response.status == GoogleResponseStatus.requestDenied) {
      debugPrint('Camera Location Search Error: ${response.errorMessage!}');
      return null;
    }

    return response.results;
  }

  static Future<PlaceDetails?> getPlaceDetail(String placeId) async {
    final PlacesDetailsResponse detailResponse = await _places.getDetailsByPlaceId(placeId, language: _language, region: _region);

    if (detailResponse.errorMessage?.isNotEmpty == true || detailResponse.status == GoogleResponseStatus.requestDenied) {
      debugPrint('Fetching details by placeId Error: ${detailResponse.errorMessage!}');

      return null;
    }
    return detailResponse.result;
  }

  static Future<List<PlacesSearchResult>?> getPlaceByText(String text) async {
    final PlacesSearchResponse response = await GoogleMapsPlaces(apiKey: _apiKey).searchByText(text, region: _region, language: _language);
    if (response.status == GoogleResponseStatus.requestDenied || response.errorMessage?.isNotEmpty == true) return null;

    return response.results;
  }

  static Future<List<GeocodingResult>?> searchByCameraLocation(LatLng latLng) async {
    final GeocodingResponse response = await _geocoding.searchByLocation(Location(lat: latLng.latitude, lng: latLng.longitude), language: _language);

    if (response.errorMessage?.isNotEmpty == true || response.status == GoogleResponseStatus.requestDenied) {
      debugPrint('Camera Location Search Error: ${response.errorMessage!}');
      return null;
    }

    return response.results;

    // return await getPlaceDetail(response.results[0].placeId);
  }
}
