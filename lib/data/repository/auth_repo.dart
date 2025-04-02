// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:lulu/data/api/api_client.dart';
// import 'package:lulu/data/api/http_client.dart';
// import 'package:lulu/models/signup_body_model.dart';
// import 'package:lulu/models/user_model.dart';
// import 'package:lulu/utils/app_constants.dart';
// import 'package:http/http.dart' as http;
//
// class AuthRepo {
//   final ApiClient apiClient;
//   final HttpClient httpClient;
//   final SharedPreferences sharedPreferences;
//   AuthRepo({
//     required this.apiClient,
//     required this.httpClient,
//     required this.sharedPreferences});
//
//   // Future<Response> registration(SignUpBody signUpBody) async {
//   //   return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
//   // }
//
//   Future<http.Response> registration(SignUpBody signUpBody) async {
//     return await httpClient.postData(AppConstants.SIGN_UP_URL, signUpBody.toJson());
//   }
//
//   bool userHasLoggedIn() {
//     return sharedPreferences.containsKey(AppConstants.USER_ACCOUNT);
//   }
//
//   // Future<String> getUserToken() async {
//   //   return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
//   // }
//
//   Future<UserModel?> getUserAccount() async {
//     var accountString = await sharedPreferences.getString(AppConstants.USER_ACCOUNT);
//     return accountString != null ? jsonDecode(accountString) as UserModel : null;
//   }
//
//   // Future<Response> login(String email, String password) async {
//   //   await apiClient.login();
//   //   return await apiClient.postData(AppConstants.LOGIN_URI, {"email": email, "password": password});
//   // }
//
//   Future<http.Response> login(String email, String password) async {
//     return await httpClient.postData(AppConstants.LOGIN_URL, {"email": email, "password": password});
//   }
//
//   // saveUserToken(String token) async {
//   //   apiClient.token = token;
//   //   apiClient.updateHeader(token);
//   //   return await sharedPreferences.setString(AppConstants.TOKEN, token);
//   // }
//
//   saveUserAccount(UserModel userModel) async {
//     return await sharedPreferences.setString(AppConstants.USER_ACCOUNT, jsonEncode(userModel));
//   }
//
//   // Future<void> saveUserNumberandPassword(String number, String password) async {
//   //   try {
//   //     await sharedPreferences.setString(AppConstants.PHONE, number);
//   //     await sharedPreferences.setString(AppConstants.PASSWORD, password);
//   //   } catch (e) {
//   //     throw(e);
//   //   }
//   // }
//
//   bool clearSharedData() {
//     // sharedPreferences.remove(AppConstants.TOKEN);
//     // sharedPreferences.remove(AppConstants.PASSWORD);
//     // sharedPreferences.remove(AppConstants.PHONE);
//     sharedPreferences.remove(AppConstants.USER_ACCOUNT);
//     // apiClient.token = '';
//     // apiClient.updateHeader('');
//     return true;
//   }
// }