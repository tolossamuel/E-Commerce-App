
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/show_password_cubit.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/remote_cart_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/with_list_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishlist_id_cubit.dart';
import 'package:ecommerce/injection.dart' as di;
import 'package:ecommerce/rout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.setUpLocator();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // background color of status bar
      statusBarIconBrightness: Brightness.dark, // icons: dark on light
      statusBarBrightness: Brightness.light, // for iOS
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers : [
        BlocProvider<AuthBloc>(
          create: (context) => di.locator<AuthBloc>(),
        ),
        BlocProvider<ShowPasswordCubit>(
          create: (context) => ShowPasswordCubit(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => di.locator<ProductBloc>(),
        ),
        BlocProvider<WithListBloc>(create: (context) => di.locator<WithListBloc>()),
        BlocProvider<WishlistIdCubit>(create: (context) => di.locator<WishlistIdCubit>()),
        BlocProvider<RemoteCartBloc>(create: (context) => di.locator<RemoteCartBloc>()),
        BlocProvider<CartBloc>(create: (context) => di.locator<CartBloc>()),
      ],
      child: MaterialApp.router(
        
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: router, // ← use your GoRouter instance here
      ),
    );
  }
}
