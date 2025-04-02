import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;
  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders={
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }
  Future<Response> getData(String url, {Map<String, String>? headers}) async {
    try {
      Response response = await get(
          url,
        headers: headers ?? _mainHeaders,
      );
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
  Future<Response> postData(String uri, dynamic body) async {
    print(uri);
    print(body);
    try {
      // Response response = await post(uri, body, headers: _mainHeaders);
      Response response = await post("https://jayu.tech/shopping-app/backend/account/Customer_Login.php", {
        "password": "123456",
        "email": "a@a.com"
      });
      print("post response: "+ response.body.toString());
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
  void updateHeader(String token) {
    _mainHeaders={
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> login() async {
    final response = await http.post(
      Uri.parse('https://jayu.tech/shopping-app/backend/account/Customer_Login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "password": "123456",
        "email": "a@a.com"
      }),
    );
    print("http response: "+response.body.toString());
    return response;
  }
}