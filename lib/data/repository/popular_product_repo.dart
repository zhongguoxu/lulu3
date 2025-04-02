import 'package:get/get.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  final HttpClient httpClient;
  PopularProductRepo({required this.apiClient, required this.httpClient});
  // Future<Response> getPopularProductList() async {
  //   return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  // }
  Future<http.Response> getPopularProductList() async {
    return await httpClient.postData(AppConstants.GET_PRODUCTS_URL, {"type_id": AppConstants.POPULAR_PRODUCT_TYPE_ID});
  }
}