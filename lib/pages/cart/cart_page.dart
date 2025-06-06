import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/base/common_text_button.dart';
import 'package:lulu3/base/no_data_page.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/app_icon.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:lulu3/widgets/small_text.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          //header
          Positioned(
              top: Dimensions.height20*3,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: AppIcon(icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                    onTap: () => Get.back(),
                  ),
                  // SizedBox(width: Dimensions.width20*5,),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: AppIcon(icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  // AppIcon(icon: Icons.shopping_cart,
                  //   iconColor: Colors.white,
                  //   backgroundColor: AppColors.mainColor,
                  //   iconSize: Dimensions.iconSize24,
                  // )
                ],
              )
          ),
          //body
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getItems.length >0 ? Positioned(
              top: Dimensions.height20*5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              bottom: 0,
              child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height15),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GetBuilder<CartController>(builder: (cartController) {
                      var _cartList = cartController.getItems;
                      return ListView.builder(
                          itemCount: _cartList.length,
                          itemBuilder: (_, index) {
                            var hasExtraFee = _cartList[index].envFee! > 0 || _cartList[index].serviceFee! > 0;
                            var hasEnvFee = _cartList[index].envFee! > 0;
                            var hasServiceFee = _cartList[index].serviceFee! > 0;
                            return Container(
                              // height: 100,
                              // width: double.maxFinite,
                              // margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                    },
                                    child: Container(
                                      width: Dimensions.listViewImgSize * 0.9,
                                      height: Dimensions.listViewImgSize * 0.9,
                                      // margin: EdgeInsets.only(bottom: Dimensions.height10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                        color: Colors.white38,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            AppConstants.BASE_URL+AppConstants.UPLOAD_URL+_cartList[index].img!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewTextContainerSize*1.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius20), bottomRight: Radius.circular(Dimensions.radius20)),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BigText(text: _cartList[index].name!),
                                            SizedBox(height: hasExtraFee ? Dimensions.height10/5 : Dimensions.height10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BigText(text: 'x'+_cartList[index].quantity!.toString(), color: Theme.of(context).disabledColor,),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController.addItemFromCart(_cartList[index].id!, -1);
                                                        // popularProductController.setQuantity(false);
                                                      },
                                                      child: Icon(Icons.remove, color: AppColors.signColor,),
                                                    ),
                                                    SizedBox(width: Dimensions.width10,),
                                                    BigText(text: _cartList[index].quantity.toString()),//popularProductController.inCartItems.toString()
                                                    SizedBox(width: Dimensions.width10,),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController.addItemFromCart(_cartList[index].id!, 1);
                                                        // popularProductController.setQuantity(true);
                                                      },
                                                      child: Icon(Icons.add, color: AppColors.signColor,),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: hasExtraFee ? Dimensions.height10/5 : Dimensions.height10,),
                                            BigText(text: '\$'+_cartList[index].price!.toString()),
                                            hasExtraFee ? SizedBox(height: Dimensions.height10/5,) : Container(),
                                            hasExtraFee ?
                                              Row(
                                                children: [
                                                  hasEnvFee ? SmallText(text: 'Deposit: \$'+_cartList[index].envFee!.toStringAsFixed(2), size: Dimensions.font16/2*1.5,) : Container(),
                                                  hasEnvFee ? SizedBox(width: Dimensions.width10,) : Container(),
                                                  hasServiceFee ? SmallText(text: 'Service: \$'+(_cartList[index].price!*_cartList[index].serviceFee!).toStringAsFixed(2), size: Dimensions.font16/2*1.5,) : Container(),
                                                ],
                                              ) : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },),)
              ),
            ) : NoDataPage(text: "Cart is empty!");
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
        _noteController.text = cartController.orderNote;
        return GetBuilder<CartController>(builder: (cartController) {
          return Container(
              height: Dimensions.bottomHeightBar,
              padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: cartController.getItems.length > 0 ? AppColors.buttonBackgroundColor : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20*2),
                    topRight: Radius.circular(Dimensions.radius20*2),
                  )
              ),
              child: cartController.getItems.length > 0 ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: Dimensions.width10,),
                            BigText(text: "\$ "+cartController.totalAmout.toStringAsFixed(2)),
                            SizedBox(width: Dimensions.width10,),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartController.setLoading(true);
                          if(Get.find<UserController>().userHasLoggedIn()) {
                            if (Get.find<UserController>().userModel == null) {
                              Get.find<UserController>().getUserInfo().then((_) {
                                if (Get.find<UserController>().addressList.isEmpty) {
                                  Get.find<UserController>().getUserAddressList(Get.find<UserController>().userModel!.id).then((_) {
                                //     if (Get.find<UserController>().addressList.isEmpty) {
                                //       Get.toNamed(RouteHelper.getPickAddressPage());
                                //     } else {
                                //       print("zack this is true 1");
                                      Get.toNamed(RouteHelper.getOrderReviewPage());
                                      cartController.setLoading(false);
                                //     }
                                  });
                                } else {
                                  Get.toNamed(RouteHelper.getOrderReviewPage());
                                  cartController.setLoading(false);
                                }
                                // Get.toNamed(RouteHelper.getOrderReviewPage());
                              });
                            } else {
                              if (Get.find<UserController>().addressList.isEmpty) {
                                Get.find<UserController>().getUserAddressList(Get.find<UserController>().userModel!.id).then((_) {
                                  // if (Get.find<UserController>().addressList.isEmpty) {
                                  //   Get.toNamed(RouteHelper.getPickAddressPage());
                                  // } else {
                                  //   print("zack this is true 2");
                                    Get.toNamed(RouteHelper.getOrderReviewPage());
                                    cartController.setLoading(false);
                                  // }
                                });
                              } else {
                              //   print("zack this is true 3");
                                Get.toNamed(RouteHelper.getOrderReviewPage());
                                cartController.setLoading(false);
                              }
                              // Get.toNamed(RouteHelper.getOrderReviewPage());
                            }
                          } else {
                            Get.toNamed(RouteHelper.getLoginPage());
                            cartController.setLoading(false);
                          }
                        },
                        child: cartController.isLoading ? Container(
                          padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
                          child: Center(
                              child: CircularProgressIndicator(color: AppColors.mainColor,),
                          ),
                        ) : CommonTextButton(text: "checkout",),
                      )
                    ],
                  ) ,
                ],
              ) : Container()
          );
        },);
      })
    );
  }
}
