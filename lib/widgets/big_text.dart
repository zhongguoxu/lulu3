import 'package:flutter/cupertino.dart';
import 'package:lulu3/utils/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  bool flexible;
  BigText({Key? key, this.color = const Color(0xFF332d2b), required this.text, this.size=0, this.overflow = TextOverflow.ellipsis, this.flexible=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (flexible) {
      return Flexible(
        child: Text(
          text,
          maxLines: 1,
          overflow: overflow,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w400,
            fontSize: size == 0 ? Dimensions.font20 : size,
          ),
        ),
      );
    } else {
      return Text(
        text,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: size == 0 ? Dimensions.font20 : size,
        ),
      );
    }
  }
}
