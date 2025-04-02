import 'package:get/get.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class RecommendedProductRepo extends GetxService {
  final ApiClient apiClient;
  final HttpClient httpClient;
  RecommendedProductRepo({required this.apiClient, required this.httpClient});
  // Future<Response> getRecommendedProductList() async {
  //   return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI);
  // }
  Future<http.Response> getRecommendedProductList() async {
    return await httpClient.postData(AppConstants.GET_RECOMMENDED_URL, {"type_id": AppConstants.ALL_PRODUCT_TYPE_ID});
  }
}