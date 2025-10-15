import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CartDisplayWidget extends StatelessWidget {
  final CartEntity cartEntity;
  const CartDisplayWidget({super.key, required this.cartEntity});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: widthSize(width, 375, 24)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: widthSize(width, 375, 60),

              decoration: BoxDecoration(color: ConstColor.whiteButton),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: cartEntity.image,
                  fit: BoxFit.fill,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: ConstColor.textGrey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(color: ConstColor.textGrey),
                    ),
                  ),
                  errorWidget: (context, url, error) => Shimmer.fromColors(
                    baseColor: ConstColor.textGrey,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(color: ConstColor.textGrey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: widthSize(width, 375, 10)),
            SizedBox(
              width: widthSize(width, 375, 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: widthSize(width, 375, 200),
                    child: CustomText(
                      color: ConstColor.textDark,
                      text: cartEntity.title,
                      size: widthSize(width, 375, 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: heightSize(width, 375, 10)),
                  SizedBox(
                    width: widthSize(width, 375, 125),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                                context.read<CartBloc>().add(AddToCartEvent(product: [{
                                  "productId": cartEntity.id,
                                  "quantity": -1
                                }],
                                remove: true
                                
                                )
                                
                                );
                                
                              },
                          child: Container(
                            width: widthSize(width, 375, 40),
                            height: widthSize(width, 375, 30),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ConstColor.textGrey..withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: widthSize(width, 375, 20),
                                height: widthSize(width, 375, 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstColor.textDark,
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: widthSize(width, 375, 18),
                                  color: ConstColor.textDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: widthSize(width, 375, 40),
                          height: widthSize(width, 375, 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ConstColor.textGrey.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Center(
                              child: CustomText(
                                color: ConstColor.textDark,
                                text: cartEntity.quantity.toString(),
                                size: widthSize(width, 375, 12),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                                context.read<CartBloc>().add(AddToCartEvent(product: [{
                                  "productId": cartEntity.id,
                                  "quantity": 1
                                }]));
                                
                              },
                          child: Container(
                            width: widthSize(width, 375, 40),
                            height: widthSize(width, 375, 30),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ConstColor.textGrey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: widthSize(width, 375, 20),
                                height: widthSize(width, 375, 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstColor.textDark,
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: widthSize(width, 375, 18),
                                  color: ConstColor.textDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: widthSize(width, 375, 57),
              child: Center(
                child: CustomText(
                  color: ConstColor.textDark,
                  text: "\$${cartEntity.price.toString()}",
                  size: widthSize(width, 375, 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
