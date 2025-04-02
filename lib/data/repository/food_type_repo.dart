import 'package:get/get.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class FoodTypeRepo extends GetxService {
  final HttpClient httpClient;
  FoodTypeRepo({ required this.httpClient});

  Future<http.Response> getFoodProductListPerType(int typeId) async {
    return await httpClient.postData(AppConstants.GET_FoodPerType_URL, {"type_id": typeId});
  }
}