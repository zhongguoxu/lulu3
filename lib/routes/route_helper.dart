import 'package:get/get.dart';
import 'package:lulu3/pages/auth/signin_page.dart';
import 'package:lulu3/pages/cart/cart_page.dart';
import 'package:lulu3/pages/food/food_detail.dart';
import 'package:lulu3/pages/food/food_type.dart';
import 'package:lulu3/pages/food/popular_food_detail.dart';
import 'package:lulu3/pages/food/recommended_food_detail.dart';
import 'package:lulu3/pages/food/search_product.dart';
import 'package:lulu3/pages/home/home_page.dart';
import 'package:lulu3/pages/order/order_detail_page.dart';
import 'package:lulu3/pages/order/order_review_page.dart';
import 'package:lulu3/pages/payment/order_success_page.dart';
import 'package:lulu3/pages/payment/payment_page.dart';
import 'package:lulu3/pages/splash/splash_page.dart';

import '../pages/address/pick_new_address_map.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial="/";
  static const String popularFood="/popular-food";
  static const String recommendedFood="/recommended-food";
  static const String cartPage="/cart-page";
  static const String login="/login-page";
  static const String addAddress="/add-address";
  static const String pickAddressMap="/pick-address";
  static const String orderSuccess="/order-success";
  static const String orderDetail="/order-detail";
  static const String orderReview="/order-review";
  static const String paymentPage="/payment";
  static const String foodTypePage="/food-type";
  static const String foodDetail='/food-detail';
  static const String searchProduct='/search-product';

  static String getSplashPage()=>'$splashPage';
  static String getInitial()=>'$initial';
  static String getPopularFood(int pageId, String page)=>'$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage()=>'$cartPage';
  static String getLoginPage()=>'$login';
  // static String getAddressPage()=>'$addAddress';
  static String getPickAddressPage()=>'$pickAddressMap';
  static String getOrderSuccessPage(String orderID, String status)=>'$orderSuccess?id=$orderID&status=$status';
  static String getOrderDetailPage(int orderIndex, String isCurrent)=>'$orderDetail?orderIndex=$orderIndex&isCurrent=$isCurrent';
  static String getOrderReviewPage()=>'$orderReview';
  static String getPaymentPage()=>'$paymentPage';
  static String getFoodTypePage(int typeId)=>'$foodTypePage?&typeId=$typeId';
  static String getFoodDetail(int foodId, String page, int typeId)=>'$foodDetail?foodId=$foodId&page=$page&typeId=$typeId';
  static String getSearchProductPage()=>'$searchProduct';

  static List<GetPage> routes = [
    GetPage(name: login, page: ()=>SignInPage(), transition: Transition.fade),
    GetPage(name: splashPage, page: ()=>SplashPage()),
    GetPage(name: initial, page: ()=>HomePage()),
    GetPage(
        name: popularFood,
        page: (){
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return PopularFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn,
    ),
    GetPage(
        name: recommendedFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return RecommendedFoodDetail(pageId: int.parse(pageId!), page: page!,);
        },
        transition: Transition.fadeIn,
    ),
    GetPage(name: searchProduct, page: ()=>SearchProductPage()),
    GetPage(name: cartPage, page: () {return CartPage();}, transition: Transition.fadeIn),
    // GetPage(name: addAddress, page: () {return AddNewAddressPage();}, transition: Transition.fadeIn),
    // GetPage(name: pickAddressMap, page: () {return PickNewAddressMap();}, transition: Transition.fadeIn),
    GetPage(name: pickAddressMap, page: (){
      PickNewAddressMap _pickAddress = Get.arguments;
      return _pickAddress;
    }),
    GetPage(name: orderSuccess, page: ()=>OrderSuccessPage(
        orderId: Get.parameters['id']!,
        status: Get.parameters['status'].toString().contains("success")?1:0)),
    GetPage(name: orderDetail, page: ()=>OrderDetailPage(
      orderIndex: int.parse(Get.parameters['orderIndex']!),
      isCurrent: Get.parameters['isCurrent']!,
    )),
    GetPage(name: orderReview, page: () {return OrderReviewPage();}, transition: Transition.fadeIn),
    GetPage(name: paymentPage, page: ()=>PaymentPage()),
    GetPage(name: foodTypePage, page: ()=>FoodType(
      typeId: int.parse(Get.parameters['typeId']!),
    )),
    GetPage(name: foodDetail, page: ()=>FoodDetail(
      foodId: int.parse(Get.parameters['foodId']!),
      page: Get.parameters['page']!,
      typeId: int.parse(Get.parameters['typeId']!),
    )),
  ];
}