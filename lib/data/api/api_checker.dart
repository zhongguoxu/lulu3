import 'package:get/get.dart';
import 'package:lulu3/base/show_custom_snackbar.dart';
import 'package:lulu3/routes/route_helper.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.offNamed(RouteHelper.getLoginPage());
    } else {
      showCustomSnackBar(response.statusText!);
    }
  } 
}