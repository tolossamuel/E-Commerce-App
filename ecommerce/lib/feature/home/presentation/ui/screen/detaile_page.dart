import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_event.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_state.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/with_list_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishlist_id_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class DetailePage extends StatelessWidget {
  final HomeEntity product;
  const DetailePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
   
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // background color of status bar
        statusBarIconBrightness: Brightness.dark, // icons: dark on light
        statusBarBrightness: Brightness.light, // for iOS
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Container(
                width: width,
                height: heightSize(height, 812, 550),
                decoration: BoxDecoration(color: ConstColor.whiteButton),
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: product.image,
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
              Positioned(
                top: heightSize(height, 812, 30),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthSize(width, 375, 10),
                  ),
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onTap: () {
                          context.pop();
                        },
                        width: widthSize(width, 375, 34),
                        color: ConstColor.white.withOpacity(0.4),
                        radies: widthSize(width, 375, 17),
                        topPadding: heightSize(height, 812, 6),
                        bottomPadding: heightSize(height, 812, 6),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: ConstColor.textDark,
                            size: widthSize(width, 375, 25),
                          ),
                        ),
                      ),
                      BlocBuilder<WishlistIdCubit, Set>(
                        builder: (context, sets) {
                          return BlocBuilder<WithListBloc, WishListState>(
                            builder: (context, wishState) {
                              return CustomButton(
                                onTap: () {
                                  if (wishState is WishListLoadingState) {
                                    return;
                                  }
                                  context.read<WithListBloc>().add(
                                    sets.contains(product.id)
                                        ? RemoveWishListEvent(
                                            productId: product.id,
                                          )
                                        : AddToWishListEvent(product: product),
                                  );
                                },
                                width: widthSize(width, 375, 34),
                                color: ConstColor.white.withOpacity(0.4),
                                radies: widthSize(width, 375, 17),
                                topPadding: heightSize(height, 812, 6),
                                bottomPadding: heightSize(height, 812, 6),
                                child: Center(
                                  child: Icon(
                                    sets.contains(product.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: sets.contains(product.id)
                                        ? ConstColor.red
                                        : ConstColor.textGrey,
                                    size: widthSize(width, 375, 25),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: heightSize(height, 812, 500),
                child: Container(
                  width: width,
                  height: heightSize(height, 812, 360),

                  decoration: BoxDecoration(
                    color: ConstColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widthSize(width, 375, 20)),
                      topRight: Radius.circular(widthSize(width, 375, 20)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widthSize(width, 375, 24),
                          vertical: heightSize(height, 812, 24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: widthSize(width, 375, 342),
                              child: CustomText(
                                color: ConstColor.textDark,
                                text: product.title,
                                size: widthSize(width, 375, 24),
                                fontWeight: FontWeight.w600,
                                maxLine: 2,
                              ),
                            ),
                            SizedBox(height: heightSize(height, 812, 10)),
                            SizedBox(
                              width: widthSize(width, 375, 342),
                              child: CustomText(
                                color: ConstColor.textDark.withOpacity(0.5),
                                text: product.category,
                                size: widthSize(width, 375, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: heightSize(height, 812, 10)),
                            SizedBox(
                              width: widthSize(width, 375, 342),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: widthSize(width, 375, 16),
                                    child: Icon(
                                      Icons.star,
                                      color: ConstColor.textDark,
                                      size: widthSize(width, 375, 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthSize(width, 375, 30),
                                    child: CustomText(
                                      color: ConstColor.textDark,
                                      text:
                                          product.rating["rate"]
                                              ?.toStringAsFixed(2) ??
                                          "0.00",
                                      size: widthSize(width, 375, 14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: widthSize(width, 375, 5)),
                                  CustomText(
                                    color: ConstColor.textDark.withOpacity(0.5),
                                    text:
                                        product.rating["count"]?.toString() ??
                                        "0",
                                    size: widthSize(width, 375, 14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(width: widthSize(width, 375, 3)),
                                  SizedBox(
                                    width: widthSize(width, 375, 55),
                                    child: CustomText(
                                      color: ConstColor.textDark.withOpacity(
                                        0.5,
                                      ),
                                      text: "Reviews",
                                      size: widthSize(width, 375, 14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
                        width: width,
                        height: heightSize(height, 812, 110),
                        decoration: BoxDecoration(color: Color(0xffFFE8B2)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: widthSize(width, 375, 110),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: widthSize(width, 375, 110),
                                    child: CustomText(
                                      color: Color(0xff616161),
                                      text: "Price",
                                      size: widthSize(width, 375, 12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widthSize(width, 375, 110),
                                    child: CustomText(
                                      color: ConstColor.textDark,
                                      text:
                                          "\$${product.price.toStringAsFixed(2)}",
                                      size:
                                          product.price
                                                  .toStringAsFixed(2)
                                                  .length <
                                              5
                                          ? widthSize(width, 375, 24)
                                          : widthSize(width, 375, 20),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: heightSize(height, 812, 50),
                              child: CustomButton(
                                onTap: (){
                                  context.read<CartBloc>().add(AddToCartEvent(product: [{
                                  "productId": product.id,
                                  "quantity": 1
                                }],
                                
                                
                                )
                        );
                                },
                                width: widthSize(width, 375, 214),

                                color: ConstColor.textDark,
                                radies: widthSize(width, 375, 6),
                                topPadding: heightSize(height, 812, 14),
                                bottomPadding: heightSize(height, 812, 14),
                                child: Center(
                                  child: SizedBox(
                                    width: widthSize(width, 375, 80),
                                    child: CustomText(
                                      color: ConstColor.white,
                                      text: "Add to cart",
                                      size: widthSize(width, 375, 14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
