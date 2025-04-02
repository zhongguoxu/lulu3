import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lulu3/utils/dimensions.dart';

class OrderDetailItem extends StatelessWidget {
  final String itemName;
  final String itemValue;
  const OrderDetailItem({Key? key, required this.itemName, required this.itemValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height45,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.width10/2),
          height: Dimensions.height20*2.2,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[100]!),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.width45*2.5,
                child: Text(
                  itemName,
                  style: TextStyle(fontSize: Dimensions.font20, color: Theme.of(context).disabledColor),
                ),
              ),
              SizedBox(
                width: Dimensions.width10*3.5,
              ),
              Text(
                itemValue,
                style: TextStyle(fontSize: Dimensions.font16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
