import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishListLoading extends StatelessWidget {
  const WishListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: widthSize(width, 375, 342),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widthSize(width, 375, 10)),
        color: ConstColor.greyButton,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: ConstColor.textGrey,
            blurRadius: 1,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ===== Image Shimmer =====
            Container(
              width: widthSize(width, 375, 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widthSize(width, 375, 10)),
                  bottomLeft: Radius.circular(widthSize(width, 375, 10)),
                ),
                color: ConstColor.whiteButton,
              ),
              child: Shimmer.fromColors(
                baseColor: ConstColor.textGrey,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: ConstColor.textGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widthSize(width, 375, 10)),
                      bottomLeft: Radius.circular(widthSize(width, 375, 10)),
                    ),
                  ),
                ),
              ),
            ),

            // ===== Details Shimmer =====
            Container(
              width: widthSize(width, 375, 227),
              padding: EdgeInsets.symmetric(
                horizontal: widthSize(width, 375, 16),
                vertical: heightSize(height, 812, 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Favorite Icon
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: ConstColor.textGrey,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: widthSize(width, 375, 160),
                          height: heightSize(height, 812, 16),
                          decoration: BoxDecoration(
                            color: ConstColor.textGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Shimmer.fromColors(
                        baseColor: ConstColor.textGrey,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: widthSize(width, 375, 20),
                          height: widthSize(width, 375, 19.27),
                          decoration: BoxDecoration(
                            color: ConstColor.textGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: heightSize(height, 812, 6)),

                  // Price
                  Shimmer.fromColors(
                    baseColor: ConstColor.textGrey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: widthSize(width, 375, 70),
                      height: heightSize(height, 812, 14),
                      color: ConstColor.textGrey,
                    ),
                  ),
                  SizedBox(height: heightSize(height, 812, 10)),

                  // Add to Cart button
                  Shimmer.fromColors(
                    baseColor: ConstColor.textGrey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: widthSize(width, 375, 214),
                      height: heightSize(height, 812, 44),
                      decoration: BoxDecoration(
                        color: ConstColor.textGrey,
                        borderRadius: BorderRadius.circular(widthSize(width, 375, 6)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
