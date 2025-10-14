import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/color/const_color.dart';
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

class ProductDisplayComponet extends StatelessWidget {
  final HomeEntity product;
  final bool isWishlist;
  const ProductDisplayComponet({
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
        print(state);
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
                            width: widthSize(width, 375, 170),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: widthSize(width, 375, 170),
                                  child: CustomText(
                                    color: ConstColor.textDark,
                                    text: product.title,
                                    size: widthSize(width, 375, 16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: widthSize(width, 375, 170),
                                  child: CustomText(
                                    color: ConstColor.textDark.withOpacity(0.5),
                                    text: product.category,
                                    size: widthSize(width, 375, 12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          BlocBuilder<WishlistIdCubit, Set>(
                            builder: (context, sets) {
                        
                              return SizedBox(
                                width: widthSize(width, 375, 20),
                                child: BlocBuilder<WithListBloc, WishListState>(
                                  builder: (context, state) {
                                    print(sets);
                                    return IconButton(
                                      onPressed: () {
                                 
                                        if (state is WishListLoadingState){
                                          return;
                                        }
                                        context.read<WithListBloc>().add(
                                          sets.contains(product.id)
                                              ? RemoveWishListEvent(
                                                  productId: product.id,
                                                )
                                              : AddToWishListEvent(
                                                  product: product,
                                                ),
                                        );
                                      },
                                      splashRadius: 0.00001,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      mouseCursor: SystemMouseCursors.click,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(
                                        sets.contains(product.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: widthSize(width, 375, 19.27),
                                        color: sets.contains(product.id)
                                            ? ConstColor.red
                                            : ConstColor.textGrey,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: heightSize(height, 812, 10)),
                    SizedBox(
                      width: widthSize(width, 375, 37),
                      child: Row(
                        children: [
                          SizedBox(
                            width: widthSize(width, 375, 10),
                            child: Icon(
                              Icons.star,
                              size: widthSize(width, 375, 9.58),
                              color: ConstColor.textDark,
                            ),
                          ),
                          SizedBox(
                            width: widthSize(width, 375, 23),
                            child: CustomText(
                              color: ConstColor.textDark,
                              text: '4.25',
                              size: widthSize(width, 375, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightSize(height, 812, 15)),
                    SizedBox(
                      width: widthSize(width, 375, 198),
                      child: CustomText(
                        color: ConstColor.textDark,
                        text: '\$${product.price.toStringAsFixed(2)}',
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
      ),
    );
  }
}
