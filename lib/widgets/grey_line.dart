import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lulu3/utils/dimensions.dart';

class GreyLine extends StatelessWidget {
  const GreyLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth,
      height: Dimensions.height10/40,
      color: Colors.grey,
    );
  }
}
