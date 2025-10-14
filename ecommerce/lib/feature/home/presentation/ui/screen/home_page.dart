import 'package:ecommerce/core/color/const_color.dart';
import 'package:ecommerce/core/component/custom_button.dart';
import 'package:ecommerce/core/component/custom_text.dart';
import 'package:ecommerce/core/size/responsive_size.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_state.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_event.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_state.dart';
import 'package:ecommerce/feature/home/presentation/state/wishlist_id_cubit.dart';
import 'package:ecommerce/feature/home/presentation/ui/widget/product_display_componet.dart';
import 'package:ecommerce/feature/home/presentation/ui/widget/product_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final productBloc = context.read<ProductBloc>();

    context.read<WishlistIdCubit>().fetchAllId();

    // Fetch products if the state is initial
    if (productBloc.state is ProductInitialState) {
      productBloc.add(GetProductsEvent());
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore) {
        _loadMoreProducts();
      }
    });
  }

  Future<void> _loadMoreProducts() async {
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, auth) {
        if (auth is AuthLogOutState) {
          context.go("/");
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
          List<HomeEntity> products = [];
          bool isError = false;
          String errorMessage = '';

          if (productState is ProductLoadedState) {
            products = productState.products;
          } else if (productState is ProductErrorState) {
            products = List.generate(
              1,
              (_) => HomeEntity(
                id: 0,
                title: '',
                image: '',
                price: 0.0,
                descr: '',
                rating: {},
                category: '',
              ),
            );
            isError = true;
            errorMessage = productState.message;
          } else {
            // Loading or initial
            products = List.generate(
              6,
              (_) => HomeEntity(
                id: 0,
                title: '',
                image: '',
                price: 0.0,
                descr: '',
                rating: {},
                category: '',
              ),
            );
          }
          return SafeArea(
            child: Scaffold(
              backgroundColor: ConstColor.white,
              body: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false, // removes the scroll indicator
                  overscroll: false, // removes the glow effect on overscroll
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    left: widthSize(width, 375, 24),
                    right: widthSize(width, 375, 24),
                    top: heightSize(height, 812, 25),
                    bottom: heightSize(height, 812, 20),
                  ),
                  itemCount: products.length + 2, // +2 for header & title
                  itemBuilder: (context, index) {
                    // ===== Header =====
                    if (index == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: widthSize(width, 375, 180),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final String username = state is AuthLogInState
                                    ? state.userName
                                    : "";
                                return CustomText(
                                  color: ConstColor.textDark,
                                  text: 'Welcome, $username',
                                  size: widthSize(width, 375, 24),
                                  fontWeight: FontWeight.w600,
                                  maxLine: 2,
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              CustomButton(
                                onTap: () {
                                  context.read<AuthBloc>().add(
                                    LogOutAuthEvent(),
                                  );
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
                      );
                    }

                    // ===== Title =====
                    if (index == 1) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: heightSize(height, 812, 25),
                        ),
                        child: CustomText(
                          color: ConstColor.textDark,
                          text: 'Fake Store',
                          fontWeight: FontWeight.w600,
                          size: widthSize(width, 375, 28),
                        ),
                      );
                    }

                    // ===== List Items =====
                    final product = products[index - 2];

                    if (isError) {
                      // Show Try Again only in the list part

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: heightSize(height, 812, 20),
                        ),
                        child: Column(
                          children: [
                            CustomText(
                              color: ConstColor.textDark,
                              text: errorMessage,
                              size: widthSize(width, 375, 16),
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: heightSize(height, 812, 20)),
                            CustomButton(
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
                                context.read<ProductBloc>().add(
                                  GetProductsEvent(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return productState is ProductLoadedState
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: heightSize(
                                height,
                                812,
                                20,
                              ), // space between items
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.push('/detail', extra: product);
                              },
                              child: ProductDisplayComponet(product: product),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              top: heightSize(
                                height,
                                812,
                                20,
                              ), // space between items
                            ),
                            child: ProductLoadingDisplay(),
                          );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
