import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/cart_controller.dart';
import 'package:lulu3/controllers/order_controller.dart';
import 'package:lulu3/utils/dimensions.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;
  const PaymentOptionButton({Key? key, required this.icon, required this.title, required this.subTitle, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      bool _selected = cartController.paymentIndex == index;
      return InkWell(
        onTap: (){
          cartController.setPaymentIndex(index);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: Dimensions.height10/2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1,
                )
              ]
          ),
          child: ListTile(
            leading: Icon(icon, size: 40, color: _selected ? Theme.of(context).primaryColor:Theme.of(context).disabledColor,),
            title: Text(title, style: TextStyle(fontSize: Dimensions.font20),),
            subtitle: Text(subTitle, style: TextStyle(fontSize: Dimensions.font16), maxLines: 1, overflow: TextOverflow.ellipsis,),
            trailing: _selected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor,) : null,
          ),
        ),
      );
    });
  }
}
