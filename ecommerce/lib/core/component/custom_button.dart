

import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget{
  final double width;
  final double height;
  final Color color;
  final double radies;
  final double borderWidth;
  final Color? borderColor;
  final Widget child;
  final VoidCallback? onTap;

  const CustomButton({
    super.key, 
    required this.width,
    required this.height,
    required this.color,
    required this.child,
    this.onTap,
    this.borderWidth = 0,
    this.borderColor,
    this.radies = 0
  });
  
  @override
  Widget build(Object context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: width,
        height:  height,
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