import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;
  HttpClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    _mainHeaders=<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }
  Future<http.Response> postData(String uri, dynamic body) async {
    // print('http postData request with ' + uri + ' ' + body.toString());
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: _mainHeaders,
        body: jsonEncode(body),
      );
      // print("http post response: "+response.statusCode.toString()+' '+response.body.toString());
      return response;
    } catch (e) {
      // print("http post response: "+e.toString());
      return http.Response("Http post request failed!", 1);
    }
  }
  Future<http.Response> getData(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _mainHeaders,
      );
      // print("http get response: "+response.statusCode.toString()+' '+response.body.toString());
      return response;
    } catch (e) {
      // print("http get response: "+e.toString());
      return http.Response("Http get request failed!", 1);
    }
  }
}