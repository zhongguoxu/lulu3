import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/utils/dimensions.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final double amount;
  final bool isFree;
  const DeliveryOptions({Key? key,
    required this.value,
    required this.title,
    required this.amount,
    required this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Row(
        children: [
          Radio(
            value: value,
            groupValue: cartController.deliveryType,
            onChanged: (String? value) {
              cartController.setDeliveryType(value!);
              print(value.toString());
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: Dimensions.width10/2,
          ),
          Text(
            title,
            style: TextStyle(fontSize: Dimensions.font20),
          ),
          SizedBox(
            width: Dimensions.width10/2,
          ),
          Text(isFree ? '(Free)':'(\$${(amount*0.05).toStringAsFixed(2)})', style: TextStyle(fontSize: Dimensions.font20),),
        ],
      );
    });
  }
}
