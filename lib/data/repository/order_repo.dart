import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/models/place_order_model.dart';

import '../../utils/app_constants.dart';

class OrderRepo {
  final HttpClient httpClient;
  OrderRepo({required this.httpClient});

  Future<http.Response> placeOrder(PlaceOrderBody placeOrderBody) async {
    var newJson = placeOrderBody.toJson();
    return await httpClient.postData(AppConstants.PLACE_ORDER_URL, newJson);
  }

  Future <http.Response> getOrderList(String phone) async {
    return await httpClient.postData(AppConstants.GET_ORDER_LIST_URL, {"phone": phone});
  }
}