import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/custom_app_bar.dart';
import 'package:lulu3/base/custom_loader.dart';
import 'package:lulu3/controllers/auth_controller.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/location_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/account_widget.dart';
import 'package:lulu3/widgets/app_icon.dart';
import 'package:lulu3/widgets/big_text.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<UserController>().userHasLoggedIn();
    // print("user logged in?: "+_userLoggedIn.toString());
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo().then((_) {
        Get.find<UserController>().getUserAddressList(Get.find<UserController>().userModel!.id);
      });
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        return _userLoggedIn ? (userController.isLoading & userController.finishLoadingAddressList ?
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimensions.height20),
          child: Column(
            children: [
              AppIcon(icon: Icons.person, backgroundColor: AppColors.mainColor,iconColor: Colors.white, iconSize: Dimensions.height15*5, size: Dimensions.height15*10,),
              SizedBox(height: Dimensions.height30,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //name
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.person, backgroundColor: AppColors.mainColor,iconColor: Colors.white, iconSize: Dimensions.height10*2.5, size: Dimensions.height10*5,),
                        bigText: BigText(text: userController.userModel!.name),
                      ),
                      SizedBox(height: Dimensions.height20,),
                      //phone
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.phone, backgroundColor: AppColors.yellowColor,iconColor: Colors.white, iconSize: Dimensions.height10*2.5, size: Dimensions.height10*5,),
                        bigText: BigText(text: userController.userModel!.phone),
                      ),
                      SizedBox(height: Dimensions.height20,),
                      //email
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.email, backgroundColor: AppColors.yellowColor,iconColor: Colors.white, iconSize: Dimensions.height10*2.5, size: Dimensions.height10*5,),
                        bigText: BigText(text: userController.userModel!.email),
                      ),
                      SizedBox(height: Dimensions.height20,),
                      GetBuilder<UserController>(builder: (userController) {
                        return GestureDetector(
                          onTap: () {
                            Get.offNamed(RouteHelper.getPickAddressPage());
                          },
                          child: AccountWidget(
                            appIcon: AppIcon(icon: Icons.location_on, backgroundColor: AppColors.yellowColor,iconColor: Colors.white, iconSize: Dimensions.height10*2.5, size: Dimensions.height10*5,),
                            bigText: BigText(text: userController.addressList.isEmpty ? "Fill in your address":Get.find<UserController>().addressList.last.address, flexible: true,),
                          ),
                        );
                      }),
                      SizedBox(height: Dimensions.height20,),
                      //message
                      GestureDetector(
                        onTap: () {
                          if (Get.find<UserController>().userHasLoggedIn()) {
                            Get.find<UserController>().clearSharedData();
                            Get.find<CartController>().clearCartAndHistory(true, true);
                            Get.toNamed(RouteHelper.getLoginPage());
                          }
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(icon: Icons.logout, backgroundColor: Colors.redAccent,iconColor: Colors.white, iconSize: Dimensions.height10*2.5, size: Dimensions.height10*5,),
                          bigText: BigText(text: "Logout"),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ): CustomLoader()) : Container(child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              child: AspectRatio(aspectRatio: 1),
              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
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
                margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Center(child: BigText(text: "Sign in", color: Colors.white, size: Dimensions.font26,)),
              ),
            ),
          ],
        ),),);
      },),
    );
  }
}
