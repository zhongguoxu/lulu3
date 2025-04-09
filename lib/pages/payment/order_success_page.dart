import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lulu3/base/custom_button.dart';
import 'package:lulu3/routes/route_helper.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final int status;
  OrderSuccessPage({required this.orderId, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {

      });
    }
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(status == 1 ? Icons.check_circle_outline : Icons.warning_amber_outlined, size: 100, color: AppColors.mainColor,),
              SizedBox(height: Dimensions.height45,),

              Text(
                status == 1 ? "You placed order successfully" : "Your order failed",
                style: TextStyle(fontSize: Dimensions.font26),
              ),
              SizedBox(height: Dimensions.height20,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.height10),
                child: Text(
                  status == 1 ? "Successful order" : "Failed order",
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    color: Theme.of(context).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.height10,),

              Padding(
                padding: EdgeInsets.all(Dimensions.height10),
                child: CustomButton(
                  buttonText: status == 1 ? "Back to Home" : "Try Again",
                  onPressed: () => status == 1 ? Get.offAllNamed(RouteHelper.getInitial()) : Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}