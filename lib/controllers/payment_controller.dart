import 'dart:convert';
import 'dart:ffi';
import 'package:lulu3/data/repository/payment_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/response_model.dart';

class PaymentController extends GetxController implements GetxService {
  PaymentRepo paymentRepo;
  PaymentController({
    required this.paymentRepo,
  });

  Future<ResponseModel> addStripeCustomer(String name, String email, String phone) async {
    http.Response response = await paymentRepo.addCustomerToStripe(name, email, phone);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String message = jsonDecode(response.body)['result'];
      if (message == "succeed") {
        responseModel = ResponseModel(true, jsonDecode(response.body)['value']);
      } else {
        responseModel = ResponseModel(false, "Fails to activate your online payment option");
      }
    } else {
      responseModel = ResponseModel(false, "Fails to activate your online payment option");
    }
    return responseModel;
  }

  Future<ResponseModel> attachPaymentMethodToCustomer(String customerId, String paymentMethodId) async {
    http.Response response = await paymentRepo.attachPaymentMethodToCustomer(customerId, paymentMethodId);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String message = jsonDecode(response.body)['result'];
      if (message == "succeed") {
        responseModel = ResponseModel(true, "Add your payment card successfully");
      } else {
        responseModel = ResponseModel(false, "Fails to add your card");
      }
    } else {
      responseModel = ResponseModel(false, "Fails to add your card");
    }
    return responseModel;
  }

  Future<ResponseModel> chargeCustomer(int amount, String paymentMethodId, String customerId) async {
    http.Response response = await paymentRepo.chargeCustomer(amount, paymentMethodId, customerId);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String message = jsonDecode(response.body)['result'];
      if (message == "succeed") {
        responseModel = ResponseModel(true, "Charge the customer successfully");
      } else {
        responseModel = ResponseModel(false, "Fails to charge the customer");
      }
    } else {
      responseModel = ResponseModel(false, "Fails to charge the customer");
    }
    return responseModel;
  }
}