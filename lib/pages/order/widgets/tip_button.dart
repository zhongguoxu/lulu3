import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/utils/dimensions.dart';

class TipButton extends StatelessWidget {
  final int index;
  final double tip;
  const TipButton({Key? key, required this.index, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      bool _selected = cartController.tipIndex == index;
      return InkWell(
        onTap: () {
          cartController.setTipIndex(index);
          cartController.setTipAmount(index: index);
        },
        child: Container(
          width: Dimensions.width20*3,
          height: Dimensions.width20*3,
          margin: EdgeInsets.only(right: Dimensions.width20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.width20*1.5),
            color: _selected ? AppColors.mainColor : Colors.white,
          ),
          child: Center(
            child: Text(
              tip.toString(),
              style: TextStyle(color: _selected ? Colors.white : Colors.black, fontSize: Dimensions.font16),
            ),
          ),
        ),
      );
    });
  }
}
