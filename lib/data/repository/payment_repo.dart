import 'package:lulu3/data/api/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:lulu3/utils/app_constants.dart';

class PaymentRepo {
  final HttpClient httpClient;
  PaymentRepo({required this.httpClient});

  Future<http.Response> addCustomerToStripe(String name, String email, String phone) async {
    var newJson = {
      "email": email,
      "name": name,
      "phone": phone
    };
    return await httpClient.postData(AppConstants.ADD_STRIPE_CUSTOMER_URL, newJson);
  }
  Future<http.Response> attachPaymentMethodToCustomer(String customerId, String paymentMethodId) async {
    var newJson = {
      "customerId": customerId,
      "paymentMethodId": paymentMethodId
    };
    return await httpClient.postData(AppConstants.ATTACH_PAYMENT_URL, newJson);
  }
  Future<http.Response> chargeCustomer(int amount, String paymentMethodId, String customerId) async {
    var newJson = {
      "amount": 300,
      "paymentMethodId": paymentMethodId,
      "customerId": customerId
    };
    return await httpClient.postData(AppConstants.CHARGE_CUSTOMER_URL, newJson);
  }
}