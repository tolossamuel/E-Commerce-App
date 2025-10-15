import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_event.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_state.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/remote_cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/get_total_cubit.dart';
import 'package:ecommerce/feature/cart/presentation/ui/wedget/cart_display_widget.dart';
import 'package:ecommerce/feature/cart/presentation/ui/wedget/cart_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartEntity> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = [];
    final cartLocalBloc = context.read<CartBloc>();
    if (cartLocalBloc.state is CartIntialState) {
      context.read<CartBloc>().add(LoadCartEvent());
    }
    final cartRemotBloc = context.read<RemoteCartBloc>();
    if (cartRemotBloc.state is CartIntialState) {
      context.read<RemoteCartBloc>().add(LoadCartEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocListener<CartBloc, CartState>(
      listener: (context, locarCartBloc) {
        if (locarCartBloc is CartLoadedState) {
          cartItems = locarCartBloc.cartItems;
          context.read<GetTotalCubit>().fetchTotalPrice();
        }
        if (locarCartBloc is CartOperationMessage){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(locarCartBloc.message))
          );
          context.read<CartBloc>().add(LoadCartEvent());
        }
      },
      child: BlocListener<RemoteCartBloc, CartState>(
        listener: (context, remoteCart) {
          if (remoteCart is CartLoadedState) {
            cartItems = remoteCart.cartItems;
            context.read<GetTotalCubit>().fetchTotalPrice();
          }
          if (remoteCart is CartOperationMessage){
          
          context.read<RemoteCartBloc>().add(LoadCartEvent());
        }
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              width: width,
              height: height,
              color: Colors.white,
              padding: EdgeInsets.only(
                top: heightSize(height, 812, 25),
                bottom: heightSize(height, 812, 20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: widthSize(width, 375, 24),
                        right: widthSize(width, 375, 24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align to top
                        children: [
                          SizedBox(
                            width: widthSize(width, 375, 87),
                            child: CustomText(
                              color: ConstColor.textDark,
                              text: 'Cart',
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
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, localCartState) {
                        return BlocBuilder<RemoteCartBloc, CartState>(
                          builder: (context, remoteCartState) {
                            return (localCartState is CartLoadedState &&
                                    remoteCartState is CartLoadedState &&
                                    localCartState.cartItems.isEmpty &&
                                    remoteCartState.cartItems.isEmpty &&
                                    cartItems.isEmpty)
                                ? Center(
                                    child: CustomText(
                                      color: ConstColor.textDark,
                                      text: 'Your cart is empty',
                                      size: 16,
                                    ),
                                  )
                                : (localCartState is CartErrorState &&
                                      remoteCartState is CartErrorState &&
                                      cartItems.isEmpty)
                                ? CustomButton(
                                    width: widthSize(width, 375, 150),
                                    color: ConstColor.lightYellow,
                                    topPadding: 12,
                                    bottomPadding: 12,
                                    radies: 8,
                                    child: Center(
                                      child: CustomText(
                                        color: ConstColor.textDark,
                                        text: 'Try Again',
                                        size: widthSize(width, 375, 14),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onTap: () {
                                      context.read<CartBloc>().add(
                                        LoadCartEvent(),
                                      );
                                      context.read<RemoteCartBloc>().add(
                                        LoadCartEvent(),
                                      );
                                    },
                                  )
                                : Column(
                                    children: List.generate(
                                      cartItems.isEmpty ? 9 : cartItems.length,
                                      (index) {
                                        return Container(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: cartItems.isEmpty
                                              ? SizedBox(
                                                  child: CartDisplayShimmer(),
                                                )
                                              : Dismissible(
                                                  key: Key(
                                                    cartItems[index %
                                                            cartItems.length]
                                                        .id
                                                        .toString(),
                                                  ),
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  background: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.85),
                                                      
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onDismissed: (direction) {
                                                    context.read<CartBloc>().add(
                                                      RemoveCartEvent(
                                                        productId:
                                                            cartItems[index %
                                                                    cartItems
                                                                        .length]
                                                                .id,
                                                      ),
                                                    );
                                                    
                               
                                                    
                                                  },
                                                  child: CartDisplayWidget(
                                                    cartEntity:
                                                        cartItems[index %
                                                            cartItems.length],
                                                  ),
                                                ),
                                        );
                                      },
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
            bottomNavigationBar: BlocBuilder<GetTotalCubit, double>(
              builder: (context, totalPrice) {
                return Container(
                  width: width,
                  height: heightSize(height, 812, 110),
                  decoration: BoxDecoration(
                    color: ConstColor.white,
                    border: Border.all(
                      color: ConstColor.textGrey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
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
                                text: "Cart Total",
                                size: widthSize(width, 375, 12),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: widthSize(width, 375, 110),
                              child: CustomText(
                                color: ConstColor.textDark,
                                text: "\$$totalPrice",
                                size: () {
                                  final len = "\$$totalPrice".length;
                                  if (len <= 4) {
                                    return widthSize(width, 375, 24);
                                  }
                                  if (len == 5) {
                                    return widthSize(width, 375, 22);
                                  }
                                  if (len == 6) {
                                    return widthSize(width, 375, 20);
                                  }
                                  if (len == 7) {
                                    return widthSize(width, 375, 18);
                                  }
                                  if (len == 8) {
                                    return widthSize(width, 375, 16);
                                  }
                                  return widthSize(width, 375, 15);
                                }(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: heightSize(height, 812, 50),
                        child: CustomButton(
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
                                text: "Checkout",
                                size: widthSize(width, 375, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
