import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lulu3/base/show_custom_snackbar.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/controllers/system_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/pages/order/widgets/order_detail_item.dart';
import 'package:lulu3/pages/order/widgets/tip_button.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:lulu3/widgets/grey_line.dart';
import 'package:lulu3/widgets/small_text.dart';

import '../../base/common_text_button.dart';
import '../../models/place_order_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../widgets/app_text_field.dart';

class OrderReviewPage extends StatelessWidget {
  const OrderReviewPage({Key? key}) : super(key: key);

  void _placeOrder() {
    print("zack can place order");
    var location = Get.find<UserController>().addressList.last;
    var cart = Get.find<CartController>().getItems;
    var user = Get.find<UserController>().userModel;
    // var products = Get.find<CartController>().compressCartIntoString(cart);
    var products = Get.find<CartController>().compressCartIntoString(cart);
    var subTotal = Get.find<CartController>().calculateSubtotal(cart);
    var saving = Get.find<CartController>().calculateSaving(cart);
    // var now = DateTime.now();
    // var formatter = DateFormat('yyyy-MM-dd');
    // String formattedDate = formatter.format(now);
    // print(formattedDate);
    var time = DateTime.now().toString().substring(0, 19);
    PlaceOrderBody placeOrder = PlaceOrderBody(
        products: products,
        subTotal: subTotal.toStringAsFixed(2),
        tax: (subTotal*AppConstants.TAX).toStringAsFixed(2),
        total: (subTotal*(1+AppConstants.TAX)+Get.find<CartController>().tipAmount).toStringAsFixed(2),
        createdTime: time,
        paymentMethod: Get.find<CartController>().paymentIndex==0 ? "Cash":"Card",
        customerAddress: location.address,
        customerName: user!.name,
        customerPhone: user.phone,
        orderId: time.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")+user!.phone.substring(user!.phone.length-4, user!.phone.length),
        orderStatus: 'New',
        tips: Get.find<CartController>().tipAmount.toStringAsFixed(2),
        remarks: Get.find<CartController>().orderNote.isNotEmpty ? Get.find<CartController>().orderNote : AppConstants.EMPTY_STRING,
        orderType: Get.find<CartController>().deliveryType,
        saving: saving.toStringAsFixed(2),
    );
    // print(user!.phone);
    if (Get.find<CartController>().submitOrderSuccess == false) {
      Get.find<OrderController>().placeOrder(
          placeOrder,
          _callBack
      );
    } else {
      int inputTotal = (double.parse(placeOrder.total)*100).round();
      Get.offNamed(RouteHelper.getPaymentPage(inputTotal));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _tipController = TextEditingController();
    var subTotal = 0.0;
    var saving = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Order Review", color: Colors.white,),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<CartController>(builder: (cartController) {
          return GetBuilder<SystemController>(builder: (systemController) {
            var deliveryTitle = cartController.deliveryType == "delivery" ? "delivery" : "caryy out";
            var products = Get.find<CartController>().getItems;
            subTotal = Get.find<CartController>().calculateSubtotal(products);
            saving = Get.find<CartController>().calculateSaving(products);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Your " + deliveryTitle,
                    style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),
                  ),
                  cartController.deliveryType == "delivery" ? SizedBox(height: Dimensions.height10/2,) : Container(),
                  cartController.deliveryType == "delivery" ? Row(
                    children: [
                      Icon(Icons.lock_clock),
                      SizedBox(width: Dimensions.width10,),
                      systemController.systemInfo == null ? Text("ASAP") : Container(
                        width: Dimensions.width45*7,
                        child: Text(
                            systemController.systemInfo.where((element) => element.key == "delivery_time").first.value!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: Dimensions.font16),
                        ),
                      ),
                    ],
                  ) : Container(), // Set time
                  SizedBox(height: Dimensions.height10/2,),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: Dimensions.width10,),
                      Container(
                        width: Dimensions.width45*7,
                        child: Text(
                            cartController.deliveryType == "delivery" ? Get.find<UserController>().addressList.last.address : AppConstants.STORE_ADDRESS,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: Dimensions.font16),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10,),
                  GreyLine(),
                  SizedBox(height: Dimensions.height20,),
                  cartController.deliveryType == "delivery" ? Text("Tip your courier", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold)) : Container(),
                  cartController.deliveryType == "delivery" ? Text("The 100% of your tip goes to your courier") : Container(),
                  cartController.deliveryType == "delivery" ? SizedBox(height: Dimensions.height10,) : Container(),
                  cartController.deliveryType == "delivery" ? Row(
                    children: [
                      TipButton(index: 0, tip: 3.00),
                      TipButton(index: 1, tip: 5.00),
                      TipButton(index: 2, tip: 10.00),
                      SizedBox(
                        width: Dimensions.width45*2,
                        child: TextField(
                          controller: _tipController,
                          decoration: InputDecoration(
                            //hintText, //prefixIcon //focusedBorder //enabledBorder // border
                            hintText: "0.00",
                            prefixIcon: null,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.black38,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.radius30/2),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.black38,
                                )
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                            ),
                            // contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10*2.5),
                          ),
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (tipString) {
                            cartController.setTipIndex(-1);
                            if (tipString.isNotEmpty) {
                              if (cartController.isNumeric(tipString)) {
                                if (double.parse(tipString) >= 0) {
                                  cartController.setTipAmount(customTip: double.parse(tipString));
                                } else {
                                  showCustomSnackBar("Please input valid tip", title: "Invalid tip");
                                }
                              } else {
                                showCustomSnackBar("Please input valid tip", title: "Invalid tip");
                              }
                            } else {
                              cartController.setTipAmount(customTip: 0.0);
                            }
                          },
                        ),
                      ),
                    ],
                  ) : Container(), // Tip button
                  cartController.deliveryType == "delivery" ? SizedBox(height: Dimensions.height10,) : Container(),
                  cartController.deliveryType == "delivery" ? GreyLine() : Container(),
                  cartController.deliveryType == "delivery" ? SizedBox(height: Dimensions.height20,) : Container(),
                  InkWell(
                    onTap: () {
                      if (cartController.paymentIndex == 1) {

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartController.paymentIndex == 0 ? "Cash pay" : "Digital pay",
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                          ),
                        ),
                        cartController.paymentIndex == 0 ? SizedBox() : Icon(Icons.more_horiz_outlined),
                      ],
                    ),
                  ), //Payment
                  SizedBox(height: Dimensions.height20,),
                  GreyLine(),
                  SizedBox(height: Dimensions.height20,),
                  Text("View your order", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold)),
                  SizedBox(height: Dimensions.height10/2,),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var hasExtraFee = products[index].envFee! > 0 || products[index].serviceFee! > 0;
                      var hasEnvFee = products[index].envFee! > 0;
                      var hasServiceFee = products[index].serviceFee! > 0;
                      return GestureDetector(
                        onTap: () => null,
                        child: Container(
                          margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                          child: Row(
                            children: [
                              //Image section
                              Container(
                                width: Dimensions.listViewImgSize * 0.75,
                                height: Dimensions.listViewImgSize * 0.75,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                                    color: Colors.white38,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          AppConstants.BASE_URL+AppConstants.UPLOAD_URL+products[index].img!,
                                        )
                                    )
                                ),
                              ),
                              //text container
                              Expanded(
                                child: Container(
                                  height: Dimensions.listViewTextContainerSize*1.15,
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
                                        BigText(text: products[index].name!),
                                        SizedBox(height: hasExtraFee ? Dimensions.height10/4 : Dimensions.height10,),
                                        BigText(text: 'x'+products[index].quantity!.toString(), color: Theme.of(context).disabledColor,),
                                        SizedBox(height: hasExtraFee ? Dimensions.height10/4 : Dimensions.height10,),
                                        BigText(text: '\$'+products[index].price!.toString()),
                                        hasExtraFee ? SizedBox(height: Dimensions.height10/4,) : Container(),
                                        hasExtraFee ? Row(
                                          children: [
                                            hasEnvFee ? SmallText(text: 'Deposit: \$'+products[index].envFee!.toStringAsFixed(2), size: Dimensions.font16/2*1.5,) : Container(),
                                            hasEnvFee ? SizedBox(width: Dimensions.width10,) : Container(),
                                            hasServiceFee ? SmallText(text: 'Service: \$'+(products[index].price!*products[index].serviceFee!).toStringAsFixed(2), size: Dimensions.font16/2*1.5,) : Container(),
                                          ],
                                        ) : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }),
                  OrderDetailItem(itemName: "Subtotal", itemValue: '\$'+subTotal.toStringAsFixed(2)),
                  OrderDetailItem(itemName: "Tax", itemValue: '\$'+(subTotal*AppConstants.TAX).toStringAsFixed(2)),
                  OrderDetailItem(itemName: "Tips", itemValue: '\$'+cartController.tipAmount.toStringAsFixed(2)),
                  OrderDetailItem(itemName: "Saving", itemValue: '\$'+saving.toStringAsFixed(2)),
                  OrderDetailItem(itemName: "Total", itemValue: '\$'+(subTotal*(1+AppConstants.TAX)+cartController.tipAmount).toStringAsFixed(2)),
                  SizedBox(height: Dimensions.height10,),
                  InkWell(
                    onTap: () {
                      _placeOrder();
                    },
                    child: CommonTextButton(text: 'Place order',),
                  )
                ],
              ),
            );
          },);
        },),
      ),
    );
  }
  void _callBack(bool isSuccessful, String message, String orderId, String total) {
    if (isSuccessful) {
      print("zack successful callback");
      if (Get.find<CartController>().paymentIndex == 0) { // cash order
        Get.offNamed(RouteHelper.getOrderSuccessPage(orderId, 'success'));
        clearCartMemory();
      } else { // card order
        Get.find<CartController>().setSubmitStatus(true);
        int inputTotal = (double.parse(total)*100).round();
        Get.offNamed(RouteHelper.getPaymentPage(inputTotal));
        //接下来， 直接在payment page上进行定向 1。success 2. fail
      }
    } else {
      print("zack fails callback");
      Get.find<CartController>().setSubmitStatus(false);
      Get.offNamed(RouteHelper.getOrderSuccessPage(orderId, 'fail'));
    }
  }

  void clearCartMemory() {
    Get.find<CartController>().addToCartHistory();
    Get.find<CartController>().clearCartAndHistory(true, false);
  }
}
