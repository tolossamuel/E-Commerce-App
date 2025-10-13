import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/auth/presentation/state/show_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InputWidget extends StatelessWidget {
  final double width; // Width of the input box
  final double height; // Height of the input box
  final double radius; // Corner radius
  final String hintText; // Placeholder text
  final bool isPassword; // Whether to obscure text
  final Color backgroundColor; // Background color
  final Color borderColor; // Border color
  final Color hintColor; // Hint text color// Optional text controller
  final bool isVisible;
  final String errorMessage;
  
 
  const InputWidget({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.hintText,
    this.isVisible = true,
    this.isPassword = false,
    this.backgroundColor = const Color(0xFFF9FAFB),
    this.borderColor = const Color(0xFFE5E7EB),
    this.hintColor = const Color(0xFF9CA3AF),
    this.errorMessage = ""
   
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: errorMessage.isNotEmpty? Colors.red: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: TextField(
            
            onChanged: (value) {
              // Replace with your AuthEvent, e.g. AuthTextChanged(value)
              context.read<AuthBloc>().add(InputEvent(input: value.toString(), type: isPassword? "password" : "username"));
            },
            obscureText: isPassword?!isVisible: false,
            keyboardType: isPassword? TextInputType.visiblePassword: TextInputType.text,
            
            style:  TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: isPassword?
                 IconButton(
                   icon: Icon(
                     isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                     color: ConstColor.blackButton,
                     size: widthSize(width, 375, 22),
                   ),
                   onPressed: () {
                     context.read<ShowPasswordCubit>().togglePassword();
                   },
                 ) : null,
                 errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                 ),
              
              
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
