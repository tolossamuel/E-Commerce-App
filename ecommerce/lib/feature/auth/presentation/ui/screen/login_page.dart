import 'dart:math' show max;

import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/auth/presentation/ui/widget/input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: widthSize(width, 375, 22),
          vertical: heightSize(height, 812, 16),
        ),
        color: ConstColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(
              onTap: (){
                context.pop();
              },
              width: widthSize(width, 375, 41),
              topPadding: heightSize(height, 812, 8),
              bottomPadding: heightSize(height, 812, 8),
              color: Colors.transparent,
              borderColor: ConstColor.greyButton,
              borderWidth: 1,
              radies: widthSize(width, 352, 12),
              child: Center(
                child:Icon(
                  Icons.arrow_back_ios_rounded,
                  size: widthSize(width, 352, 19),
                  color: ConstColor.blackButton,
      
                ),
              ),
            ),
            SizedBox(height: heightSize(height, 812, 31),),
            SizedBox(
              width: widthSize(width, 375, 280),
              child: CustomText(
                color: ConstColor.textDark, 
                text: 'Welcome back! Glad to see you, Again!', 
                size: widthSize(width, 374, 30),
                fontWeight: FontWeight.w700,
                maxLine: 2,
                ),
            ),
            SizedBox(height: heightSize(height, 812, 32),),
            InputWidget(
              width: widthSize(width, 375, 331),
              height: max(widthSize(width, 812, 56),heightSize(height, 812, 56),),
              radius: widthSize(width, 375, 8,),
              hintText: "Enter your username",
              isPassword: false,
             
            ),
            SizedBox(height: heightSize(height, 812, 15),),
            InputWidget(
              width: widthSize(width, 375, 331),
              height: max(widthSize(width, 812, 56),heightSize(height, 812, 56),),
              radius: widthSize(width, 375, 8,),
              hintText: "Enter your password",
              isPassword: true,
             
            ),
            SizedBox(height: heightSize(height, 812, 30),),
            CustomButton(
                    width: widthSize(width, 375, 342) , 
                    topPadding: heightSize(height, 812, 14),
                    bottomPadding: heightSize(height, 812, 14),
                    leftPadding: widthSize(width, 375, 24),
                    rightPadding: widthSize(width, 375, 24),
                    color: ConstColor.blackButton, 
                    radies: widthSize(width, 375, 6),
                   
                    child: Center(
                      child: CustomText(
                        color: ConstColor.white, 
                        text: "Login", 
                        size: widthSize(width, 375, 16),
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.w600,
                        
                        ),
                    )),
          ],
        ),
      ),
    );
  }
}
