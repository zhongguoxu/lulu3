import 'dart:convert';
import 'package:get/get.dart';
import 'package:lulu3/data/repository/order_repo.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/models/cart_model.dart';
import 'package:lulu3/models/order_model.dart';
import 'package:lulu3/models/place_order_model.dart';
import 'package:lulu3/models/products_model.dart';

import '../models/response_model.dart';

class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;
  OrderController({
    required this.orderRepo,
  });

  bool _isLoading = false;
  bool get isLoading=>_isLoading;

  List<PlaceOrderBody> _currentOrderList = [];
  List<PlaceOrderBody> _historyOrderList = [];
  List<PlaceOrderBody> get currentOrderList=>_currentOrderList;
  List<PlaceOrderBody> get historyOrderList=>_historyOrderList;

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    update();
    http.Response response = await orderRepo.placeOrder(placeOrderBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String message = jsonDecode(response.body)['message'];
      String orderId = jsonDecode(response.body)['order_id'];
      callback(true, message, orderId, placeOrderBody.total);
      // authRepo.saveUserAccount(UserModel.fromJson(jsonDecode(response.body)));
      // responseModel = ResponseModel(true, "Login successfully");
      // print("login successfully");
    } else {
      callback(false, "Place order fails", "-1", placeOrderBody.total);
      // responseModel = ResponseModel(false, "Login fails");
      // print("login fails");
    }
    _isLoading = false;
    update();
    // return responseModel;
  }

  Future<void> getOrderList(String phone) async {
    _isLoading = true;
    update();
    http.Response response = await orderRepo.getOrderList(phone);
    if (response.statusCode == 200) {
      print("zack got order list");
      _historyOrderList = [];
      _currentOrderList = [];
      var orderList = PlaceOrderList.fromJson(jsonDecode(response.body)).placeOrders;
      print("zack order length is " + orderList.length.toString());
      _historyOrderList.addAll(orderList.where((element) => element.orderStatus=="Completed"));
      _currentOrderList.addAll(orderList.where((element) => element.orderStatus!="Completed"));
    } else {
      _historyOrderList = [];
      _currentOrderList = [];
    }

    _isLoading = false;
    update();
  }

  List<CartModel> parseStringToProductList(String productListStr) {
    print(productListStr);
    List<CartModel> productList = [];
    productListStr.split(";").forEach((element) {
      List<String> str = element.replaceAll("{","").replaceAll("}","").split(",");
      Map<String,dynamic> result = {};
      for(int i=0;i<str.length;i++){
        List<String> s = str[i].split(":");
        result.putIfAbsent(s[0].trim(), () => s[1].trim());
      }
      productList.add(CartModel.fromJson(result));
    });
    return productList;
  }

  // CartModel parseStringToProduct(String productStr) {
  //   List<String> infoList = productStr.split(',');
  //   return CartModel(
  //     name: infoList[0],
  //     price: double.parse(infoList[1]),
  //     quantity: int.parse(infoList[2]),
  //     img: infoList[3],
  //     envFee: double.parse(infoList[3]),
  //     serviceFee: double.parse(infoList[4]),
  //   );
  // }

  String getOrderStatus(String status) {
    if (status == "New") {
      return "Waiting for merchant to process";
    }
    if (status == "Processing") {
      return "Merchant is processing";
    }
    if (status == "Ready") {
      return "This order is ready for pick up / delivery";
    }
    if (status == "Delivery") {
      return "This order is in delivery";
    }
    return status;
  }
}