import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartDisplayShimmer extends StatelessWidget {
  const CartDisplayShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: ConstColor.textGrey.withOpacity(0.4),
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: widthSize(width, 375, 24)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              /// Image placeholder (same as actual image container)
              Container(
                width: widthSize(width, 375, 60),
                height: widthSize(width, 375, 60),
                decoration: BoxDecoration(
                  color: ConstColor.textGrey.withOpacity(0.5),
                ),
              ),

              SizedBox(width: widthSize(width, 375, 10)),

              /// Text + Quantity buttons
              SizedBox(
                width: widthSize(width, 375, 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title placeholder
                    Container(
                      width: widthSize(width, 375, 200),
                      height: widthSize(width, 375, 16),
                      decoration: BoxDecoration(
                        color: ConstColor.textGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: heightSize(width, 375, 10)),

                    /// Quantity buttons (exact same layout as real one)
                    SizedBox(
                      width: widthSize(width, 375, 125),
                      child: Row(
                        children: [
                          Container(
                            width: widthSize(width, 375, 40),
                            height: widthSize(width, 375, 30),
                            decoration: BoxDecoration(
                              color: ConstColor.textGrey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: widthSize(width, 375, 2)),
                          Container(
                            width: widthSize(width, 375, 40),
                            height: widthSize(width, 375, 30),
                            decoration: BoxDecoration(
                              color: ConstColor.textGrey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: widthSize(width, 375, 2)),
                          Container(
                            width: widthSize(width, 375, 40),
                            height: widthSize(width, 375, 30),
                            decoration: BoxDecoration(
                              color: ConstColor.textGrey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Space between column and price
              SizedBox(width: widthSize(width, 375, 10)),

              
            ],
          ),
        ),
      ),
    );
  }
}
