import 'dart:math';

import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              "lib/assets/images/backGround.png",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: heightSize(height, 812, 448),
           
            child: SizedBox(
              width: width,
              child: Center(
                child: Container(
                  width: min(widthSize(width, 735, 58), heightSize(height, 735, 58)),
                  height: min(widthSize(width, 735, 58), heightSize(height, 735, 58)),
                  decoration: BoxDecoration(
                    color: ConstColor.white,
                    border: Border.all(color: ConstColor.lightYellow, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: min(widthSize(width, 735, 52), heightSize(height, 735, 52)),
                      height: min(widthSize(width, 735, 52), heightSize(height, 735, 52)),
                      decoration: BoxDecoration(
                        color: ConstColor.lightYellow,
                
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Center(
                          child: Image.asset(
                            "lib/assets/images/logo.png",
                            width: widthSize(
                              width,
                              735,
                              30,
                            ), // match parent container size
                            height: widthSize(width, 735, 40),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: heightSize(height, 812, 523),
         
            child: SizedBox(
              width: width,
              child: Center(
                child: CustomButton(
                  width: widthSize(width, 375, 133) , 
                  
                  color: Colors.transparent,
                
                  child: Center(
                    child: CustomText(
                      color: ConstColor.textDark, 
                      text: "Fake Store", 
                      size: min(widthSize(width, 375, 28), heightSize(height, 812, 28)),
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.w600,
                      
                      ),
                  )),
              ),
            ),
          ),
          Positioned(
            top: heightSize(height, 812, 598),
           
            child: SizedBox(
              width: width,
              child: Center(
                child: CustomButton(
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
