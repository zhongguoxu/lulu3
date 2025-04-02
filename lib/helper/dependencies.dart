import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lulu3/controllers/auth_controller.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/food_type_controller.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/controllers/popular_product_controller.dart';
import 'package:lulu3/controllers/system_controller.dart';
import 'package:lulu3/data/api/api_client.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/data/repository/auth_repo.dart';
import 'package:lulu3/data/repository/cart_repo.dart';
import 'package:lulu3/data/repository/food_type_repo.dart';
import 'package:lulu3/data/repository/location_repo.dart';
import 'package:lulu3/data/repository/order_repo.dart';
import 'package:lulu3/data/repository/popular_product_repo.dart';
import 'package:lulu3/data/repository/system_repo.dart';
import 'package:lulu3/data/repository/user_repo.dart';
import 'package:lulu3/utils/app_constants.dart';

import '../controllers/location_controller.dart';
import '../controllers/recommended_product_controller.dart';
import '../controllers/user_controller.dart';
import '../data/repository/recommended_product_repo.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  //api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(() => HttpClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(() => SystemRepo(httpClient: Get.find()));
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find(), httpClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find(), httpClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  // Get.lazyPut(() => AuthRepo(apiClient: Get.find(), httpClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find(), httpClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), httpClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(httpClient: Get.find()));
  Get.lazyPut(() => FoodTypeRepo(httpClient: Get.find()));

  //controllers
  Get.lazyPut(() => SystemController(systemRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  // Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  // Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => FoodTypeController(foodTypeRepo: Get.find()));
}