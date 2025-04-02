import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/app_constants.dart';
import 'package:lulu3/data/api/http_client.dart';

class SystemRepo {
  final HttpClient httpClient;

  SystemRepo({
    required this.httpClient,
  });

  Future<http.Response> getSystemInfo() async {
    return await httpClient.getData(AppConstants.GET_SYSTEM_INFO);
  }

  Future<http.Response> getProductType() async {
    return await httpClient.getData(AppConstants.GET_Product_TYPE);
  }
}