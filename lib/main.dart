import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/food_type_controller.dart';
import 'package:lulu3/controllers/popular_product_controller.dart';
import 'package:lulu3/controllers/recommended_product_controller.dart';
import 'package:lulu3/controllers/system_controller.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'controllers/cart_controller.dart';
import 'helper/dependencies.dart' as dep;
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  Stripe.publishableKey = AppConstants.STRIPE_ID;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartList(); // this is to get cartlist from sharedpreference
    return GetBuilder<PopularProductController>(builder: (_) {
      return GetBuilder<RecommendedProductController>(builder: (_) {
        return GetBuilder<SystemController>(builder: (_) {
          return GetBuilder<FoodTypeController>(builder: (_) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              // home: PaymentPage(),
              initialRoute: RouteHelper.getSplashPage(),
              getPages: RouteHelper.routes,
              theme: ThemeData(
                primaryColor: AppColors.mainColor,
              ),
            );
          });
        });
      });
    },);
  }
}
