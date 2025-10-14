import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_state.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/with_list_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishlist_id_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WishListDisplay extends StatelessWidget {
  final HomeEntity product;
  final bool isWishlist;
  const WishListDisplay({
    super.key,
    required this.product,
    this.isWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocListener<WithListBloc, WishListState>(
      listener: (context, state) {
        if (state is WishListSuccessMessage) {
          context.read<WishlistIdCubit>().fetchAllId();
        }
      },
      child: Container(
        width: widthSize(width, 375, 342),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widthSize(width, 375, 10)),
          color: ConstColor.greyButton,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              color: ConstColor.textGrey,
              blurRadius: 1,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: widthSize(width, 375, 100),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widthSize(width, 375, 10)),
                    bottomLeft: Radius.circular(widthSize(width, 375, 10)),
                  ),
                  color: ConstColor.whiteButton,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widthSize(width, 375, 10)),
                    bottomLeft: Radius.circular(widthSize(width, 375, 10)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.fill,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widthSize(width, 375, 10)),
                          bottomLeft: Radius.circular(
                            widthSize(width, 375, 10),
                          ),
                        ),
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
                        decoration: BoxDecoration(
                          color: ConstColor.textGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Shimmer.fromColors(
                      baseColor: ConstColor.textGrey,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ConstColor.textGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: widthSize(width, 375, 227),
                padding: EdgeInsets.symmetric(
                  horizontal: widthSize(width, 375, 16),
                  vertical: heightSize(height, 812, 12),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(widthSize(width, 375, 10)),
                    bottomRight: Radius.circular(widthSize(width, 375, 10)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: widthSize(width, 375, 198),

                      child: Row(
                        children: [
                          SizedBox(
                            width: widthSize(width, 375, 160),
                            child: CustomText(
                              color: ConstColor.textDark,
                              text: product.title,
                              size: widthSize(width, 375, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          BlocBuilder<WishlistIdCubit, Set>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<WithListBloc>().add(
                                        RemoveWishListEvent(productId: product.id),
                                      );
                                },
                                child: SizedBox(
                                  width: widthSize(width, 375, 20),
                                  child: Center(
                                    child: Icon(
                                      Icons.favorite,
                                      size: widthSize(width, 375, 19.27),
                                      color: ConstColor.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightSize(height, 812, 5)),
                    SizedBox(
                      width: widthSize(width, 375, 198),
                      child: CustomText(
                        color: ConstColor.textDark.withOpacity(0.75),
                        text: '\$${product.price.toStringAsFixed(2)}',
                        size: widthSize(width, 375, 14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: heightSize(height, 812, 10)),
                    CustomButton(
                      width: widthSize(width, 375, 214),
                      color: ConstColor.white,
                      radies: widthSize(width, 375, 6),
                      topPadding: heightSize(height, 812, 14),
                      bottomPadding: heightSize(height, 812, 14),
                      child: Center(
                        child: SizedBox(
                          width: widthSize(width, 375, 80),
                          child: CustomText(
                            color: ConstColor.textDark,
                            text: "Add to cart",
                            size: widthSize(width, 375, 14),
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
