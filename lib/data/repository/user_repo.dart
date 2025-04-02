import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/models/address_model.dart';
import 'package:lulu3/models/user_model.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;

import '../../models/signup_body_model.dart';

class UserRepo {
  final ApiClient apiClient;
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;
  UserRepo({
    required this.apiClient,
    required this.httpClient,
    required this.sharedPreferences,
  });
  // Future<Response> getUserInfo() async {
  //   return await apiClient.getData(AppConstants.USER_INFO_URI);
  // }
  Future<http.Response> getUserInfo() async {
    return await httpClient.postData(AppConstants.LOGIN_URL, {
      "email": UserModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ACCOUNT)!)).email,
      "password": UserModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ACCOUNT)!)).password,
    });
  }

  Future<http.Response> getUserAddresses(String userId) async {
    return await httpClient.postData(AppConstants.ADDRESS_LIST_URL, {"user_id": userId});
  }

  Future<http.Response> getAddressFromGeocode(LatLng latLng) async {
    final url = '${AppConstants.MAP_HOST}?key=${AppConstants.APP_API}&language=en&latlng=${latLng.latitude},${latLng.longitude}';
    var response = await http.get(Uri.parse(url));
    print("getAddressFromGeocode"+response.toString());
    if(response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String _formattedAddress = data["results"][0]["formatted_address"];
      print("response ==== $_formattedAddress");
    }
    return response;
  }

  Future<http.Response> setLocationByHttp(String placeID) async {
    return await httpClient.getData(AppConstants.PLACE_DETAILS_URL+placeID+'&key='+AppConstants.APP_API);
  }

  Future<http.Response> searchLocationByHttp(String text) async {
    return await httpClient.getData(AppConstants.SEARCH_LOCATION_URL+text+'&key='+AppConstants.APP_API);
  }

  Future<http.Response> addAddress(AddressModel addressModel) async {
    var newJson = addressModel.toJson();
    newJson.putIfAbsent("user_id", () => UserModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ACCOUNT)!)).id);
    newJson.putIfAbsent("created_at", () => DateTime.now().toString());
    newJson.putIfAbsent("updated_at", () => DateTime.now().toString());
    return await httpClient.postData(AppConstants.ADD_USER_ADDRESS_URL, newJson);
  }

  Future<bool> saveUserAddress(String userAddress) async {
    return await sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
  }

  String getUserAddress() {
    print("user address from shared preferences " + sharedPreferences.getString(AppConstants.USER_ADDRESS)!);
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }

  Future<http.Response> registration(SignUpBody signUpBody) async {
    return await httpClient.postData(AppConstants.SIGN_UP_URL, signUpBody.toJson());
  }

  saveUserAccount(UserModel userModel) async {
    return await sharedPreferences.setString(AppConstants.USER_ACCOUNT, jsonEncode(userModel));
  }

  Future<http.Response> login(String email, String password) async {
    return await httpClient.postData(AppConstants.LOGIN_URL, {"email": email, "password": password});
  }

  bool userHasLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.USER_ACCOUNT);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.USER_ACCOUNT);
    return true;
  }

  UserModel? getUserAccount() {
    var accountString = sharedPreferences.getString(AppConstants.USER_ACCOUNT);
    return accountString != null ? jsonDecode(accountString) as UserModel : null;
  }
}