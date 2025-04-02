import 'dart:convert';

import 'package:get/get.dart';
// import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/models/address_model.dart';
import 'package:lulu3/models/user_model.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class LocationRepo {
  final HttpClient httpClient;
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.httpClient, required this.sharedPreferences, required this.apiClient});

  // Future<http.Response> getAddressFromGeocode(LatLng latLng) async {
  //   final url = '${AppConstants.MAP_HOST}?key=${AppConstants.APP_API}&language=en&latlng=${latLng.latitude},${latLng.longitude}';
  //   var response = await http.get(Uri.parse(url));
  //   print("getAddressFromGeocode"+response.toString());
  //   if(response.statusCode == 200) {
  //     Map data = jsonDecode(response.body);
  //     String _formattedAddress = data["results"][0]["formatted_address"];
  //     print("response ==== $_formattedAddress");
  //   }
  //   return response;
  // }

  String getuserAddress() {
    print("user address from shared preferences " + sharedPreferences.getString(AppConstants.USER_ADDRESS)!);
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }

  Future<http.Response> addAddress(AddressModel addressModel) async {
    var newJson = addressModel.toJson();
    newJson.putIfAbsent("user_id", () => UserModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ACCOUNT)!)).id);
    newJson.putIfAbsent("created_at", () => DateTime.now().toString());
    newJson.putIfAbsent("updated_at", () => DateTime.now().toString());
    return await httpClient.postData(AppConstants.ADD_USER_ADDRESS_URL, newJson);
  }

  Future<http.Response> getAllAddress() async {
    return await httpClient.postData(AppConstants.ADDRESS_LIST_URL, {"user_id": UserModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ACCOUNT)!)).id});
  }

  Future<bool> saveUserAddress(String userAddress) async {
    return await sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
  }

  // Future<http.Response> getZone(String lat, String lng) async {
  //   return await httpClient.postData(AppConstants.ZONE_URL, {"lat": lat, "lng": lng});
  // }
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.ZONE_URL}?lat=$lat&lng=$lng');
  }

  // Future<Response> searchLocation(String text) async {
  //   return await apiClient.getData('${AppConstants.SEARCH_LOCATION_URL}?search_text=$text');
  // }

  Future<http.Response> searchLocationByHttp(String text) async {
    return await httpClient.getData(AppConstants.SEARCH_LOCATION_URL+text+'&key='+AppConstants.APP_API);
  }

  Future<Response> setLocation(String placeID) async {
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URL}?placeid=$placeID');
  }

  Future<http.Response> setLocationByHttp(String placeID) async {
    return await httpClient.getData(AppConstants.PLACE_DETAILS_URL+placeID+'&key='+AppConstants.APP_API);
  }
}