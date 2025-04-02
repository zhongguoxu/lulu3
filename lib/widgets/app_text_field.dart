import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final bool maxLines;
  const AppTextField({Key? key, required this.textController, required this.hintText, required this.icon, this.maxLines=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 7,
              offset: Offset(1,10),
              color: Colors.grey.withOpacity(0.2),
            )
          ]
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          //hintText, //prefixIcon //focusedBorder //enabledBorder // border
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.yellowColor,),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.white,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.white,
              )
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10*2.5),
        ),
        style: TextStyle(
          fontSize: Dimensions.font16,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: maxLines ? 3:1,
      ),
    );
  }
}
