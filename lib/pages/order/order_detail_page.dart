import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/models/cart_model.dart';
import 'package:lulu3/models/place_order_model.dart';
import 'package:lulu3/pages/order/widgets/order_detail_item.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';
import 'package:lulu3/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:lulu3/widgets/small_text.dart';

class OrderDetailPage extends StatelessWidget {
  final int orderIndex;
  final String isCurrent;
  const OrderDetailPage({Key? key, required this.orderIndex, required this.isCurrent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Order Details", color: Colors.white,),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 4,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<OrderController>(builder: (orderController) {
          PlaceOrderBody thisOrder = isCurrent == "current" ? orderController.currentOrderList[orderIndex] : orderController.historyOrderList[orderIndex];
          List<CartModel> products = orderController.parseStringToProductList(thisOrder.products);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.height10,
                ),
                isCurrent == "current" ? Container(
                  padding: EdgeInsets.all(Dimensions.height10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    orderController.getOrderStatus(thisOrder.orderStatus),
                    style: TextStyle(fontSize: Dimensions.font20, color: Colors.green),
                    overflow: TextOverflow.ellipsis,
                  ),
                ) : SizedBox(),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var hasExtraFee = products[index].envFee! > 0 || products[index].serviceFee! > 0;
                    var hasEnvFee = products[index].envFee! > 0;
                    var hasServiceFee = products[index].serviceFee! > 0;
                    return GestureDetector(
                      onTap: () => null,
                      child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        padding: EdgeInsets.all(Dimensions.height10),
                        child: Row(
                          children: [
                            //Image section
                            Container(
                              width: Dimensions.listViewImgSize,
                              height: Dimensions.listViewImgSize,
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
                                height: Dimensions.listViewTextContainerSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius20)),
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
                OrderDetailItem(itemName: "Order ID", itemValue: thisOrder.orderId),
                OrderDetailItem(itemName: "Placed date", itemValue: thisOrder.createdTime),
                OrderDetailItem(itemName: "Payment", itemValue: thisOrder.paymentMethod),
                OrderDetailItem(itemName: "Subtotal", itemValue: '\$'+thisOrder.subTotal),
                OrderDetailItem(itemName: "Tax", itemValue: '\$'+thisOrder.tax),
                OrderDetailItem(itemName: "Tips", itemValue: '\$'+thisOrder.tips),
                OrderDetailItem(itemName: "Saving", itemValue: '\$'+thisOrder.saving),
                OrderDetailItem(itemName: "Total", itemValue: '\$'+thisOrder.total),
                OrderDetailItem(itemName: "Remarks", itemValue: thisOrder.remarks != "Temp" ? thisOrder.remarks : ""),
                SizedBox(height: Dimensions.height30,)
              ],
            ),
          );
        },),
      ),
    );
  }
}
