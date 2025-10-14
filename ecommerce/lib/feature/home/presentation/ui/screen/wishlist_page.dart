import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_state.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/with_list_bloc.dart';
import 'package:ecommerce/feature/home/presentation/ui/widget/wish_list_display.dart';
import 'package:ecommerce/feature/home/presentation/ui/widget/wishlist_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override 
  void initState() {
    super.initState();
    final wishListBloc = context.read<WithListBloc>();



    // Fetch products if the state is initial
    if (wishListBloc.state is WishListInitialState) {
      wishListBloc.add(GetWishListEvent());
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstColor.white,
        // 1. Use CustomScrollView to make the entire body scrollable.
        body: CustomScrollView(
          // Add padding here instead of on a Container
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                      left: widthSize(width, 375, 24),
                      right: widthSize(width, 375, 24),
                      top: heightSize(height, 812, 25),
                      bottom: heightSize(height, 812, 20),
                    ),
              // 2. Use SliverToBoxAdapter for single, non-scrollable widgets like the header.
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                  children: [
                    SizedBox(
                      width: widthSize(width, 375, 87),
                      child: CustomText(
                        color: ConstColor.textDark,
                        text: 'Wishlist',
                        size: widthSize(width, 375, 24),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        CustomButton(
                          onTap: () {
                            context.read<AuthBloc>().add(LogOutAuthEvent());
                            context.go("/");
                          },
                          width: widthSize(width, 375, 32),
                          color: ConstColor.lightYellow.withOpacity(0.6),
                          topPadding: widthSize(width, 375, 4),
                          bottomPadding: widthSize(width, 375, 4),
                          radies: widthSize(width, 375, 16),
                          child: Center(
                            child: Icon(
                              Icons.logout,
                              color: ConstColor.blackButton,
                              size: widthSize(width, 375, 24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          color: ConstColor.textDark,
                          text: 'Log out',
                          fontFamily: "Lato",
                          size: widthSize(width, 375, 12),
                          fontWeight: FontWeight.w700,
                          maxLine: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // 3. The BlocBuilder now returns different types of slivers.
            BlocBuilder<WithListBloc, WishListState>(
              builder: (context, state) {
                print(state);
                if (state is WishListErrorState) {
                  // Use SliverFillRemaining to center content in the available space.
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ... your error state widgets
                        ],
                      ),
                    ),
                  );
                }
      
                if (state is WishListLoadingState || state is WishListInitialState) {
                  // Use SliverList for a scrollable list of items.
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: widthSize(width, 375, 24)),
                    sliver: SliverList.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => SizedBox(height: heightSize(height, 812, 20)),
                      itemBuilder: (_, __) => const WishListLoading(),
                    ),
                  );
                }
      
                if (state is WishListLoadedState) {
                  if (state.wishList.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CustomText(
                          text: 'It is empty. No wishlist yet.',
                          color: ConstColor.textDark,
                          size: widthSize(width, 375, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  
                  // Show loaded wishlist items in a SliverList.
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: widthSize(width, 375, 24)),
                    sliver: SliverList.separated(
                      itemCount: state.wishList.length,
                      separatorBuilder: (_, __) => SizedBox(height: heightSize(height, 812, 20)),
                      itemBuilder: (context, index) => WishListDisplay(
                        product: state.wishList[index],
                      ),
                    ),
                  );
                }
      
                // Fallback for any other state
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}