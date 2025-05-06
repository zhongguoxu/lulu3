import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lulu3/base/custom_app_bar.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/pages/order/view_order.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/widgets/big_text.dart';

import '../../utils/dimensions.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<UserController>().userHasLoggedIn();
    _tabController = TabController(length: 2, vsync: this);
    if (_isLoggedIn) {
      if (Get.find<UserController>().userModel == null) {
        Get.find<UserController>().getUserInfo().then((_) {
          Get.find<OrderController>().getOrderList(Get.find<UserController>().userModel!.phone);
        });
      } else {
        Get.find<OrderController>().getOrderList(Get.find<UserController>().userModel!.phone);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Orders",
      ),
      body: Get.find<UserController>().userHasLoggedIn() ? Column(
        children: [
          Container(
            width: Dimensions.screenWidth,
            padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              unselectedLabelColor: Theme.of(context).disabledColor,
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: "Current Orders",),
                Tab(text: "Order History",)
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ViewOrder(isCurrent: true),
                ViewOrder(isCurrent: false)
              ],
            ),
          )
        ],
      ) : Container(child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            child: AspectRatio(aspectRatio: 1),
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        "assets/image/splash.png"
                    )
                )
            ),
          ),
          SizedBox(height: Dimensions.height30,),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getLoginPage());
            },
            child: Container(
              width: double.maxFinite,
              height: Dimensions.height20*5,
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [AppColors.mainColor, AppColors.signColor],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  )
                ],
              ),
              child: Center(
                  child: BigText(text: "Sign in", color: Colors.white, size: Dimensions.font26,)),
            ),
          ),
        ],
      ),),),
    );
  }
}

