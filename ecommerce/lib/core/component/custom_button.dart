

import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget{
  final double width;

  final Color color;
  final double radies;
  final double borderWidth;
  final Color? borderColor;
  final Widget child;
  final VoidCallback? onTap;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;
 
  const CustomButton({
    super.key, 
    required this.width,
 
    required this.color,
    required this.child,
    this.onTap,
    this.borderWidth = 0,
    this.borderColor,
    this.radies = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });
  
  @override
  Widget build(Object context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: width,
      
        padding: EdgeInsets.only(top: topPadding, left: leftPadding, right: rightPadding, bottom: bottomPadding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radies),
          border: Border.all(width: borderWidth,color: borderColor??color),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
  
}