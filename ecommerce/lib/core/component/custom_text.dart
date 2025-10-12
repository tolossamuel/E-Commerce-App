


import 'package:flutter/widgets.dart';

class CustomText extends StatelessWidget{
  final String text;
  final Color color;
  final double size;
  final String fontFamily;
  final int maxLine;
  final FontWeight fontWeight;

  const CustomText({
    super.key,
    required this.color,
    required this.text,
    required this.size,
    this.fontFamily = "Urbanist",
    this.maxLine = 1,
    this.fontWeight = FontWeight.normal,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: color
      ),
    );
  }
}