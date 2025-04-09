import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';

class CashOrOnlineButton extends StatelessWidget {
  final String title;
  final int index;
  final VoidCallback onPressed;
  const CashOrOnlineButton({Key? key, required this.title, required this.index, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      bool _selected = cartController.paymentIndex == index;
      String last4 = Get.find<UserController>().userModel?.last4 ?? "Temp";
      bool _hasPaymentmethod = (last4 != "Temp");

      return SizedBox(
        width: Dimensions.width10*14,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _selected ? AppColors.mainColor : Colors.grey,
            backgroundColor: _selected ? AppColors.mainColor : Colors.grey,
            // padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
              side: BorderSide(color: _selected ? AppColors.mainColor : Colors.grey, width: 2),
            ),
          ),
          child: Text(
            index == 0 ? (_hasPaymentmethod ? "..."+last4 : AppConstants.ADD_CREDIT) : title,
            style: TextStyle(
              fontSize: Dimensions.font20,
              color: Colors.white,
              overflow: TextOverflow.ellipsis
            ),
          ),
        ),
      );
    });
  }
}
