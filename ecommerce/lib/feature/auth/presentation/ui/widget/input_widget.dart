import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:flutter/material.dart';


class InputWidget extends StatelessWidget {
  final double width; // Width of the input box
  final double height; // Height of the input box
  final double radius; // Corner radius
  final String hintText; // Placeholder text
  final bool isPassword; // Whether to obscure text
  final Color backgroundColor; // Background color
  final Color borderColor; // Border color
  final Color hintColor; // Hint text color// Optional text controller

  const InputWidget({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.hintText,
    this.isPassword = false,
    this.backgroundColor = const Color(0xFFF9FAFB),
    this.borderColor = const Color(0xFFE5E7EB),
    this.hintColor = const Color(0xFF9CA3AF),

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: TextField(
            
            obscureText: isPassword,
            style:  TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: isPassword?
                 Icon(Icons.visibility_outlined, color: ConstColor.blackButton, size: widthSize(width, 375, 22)
                 ): null,
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
