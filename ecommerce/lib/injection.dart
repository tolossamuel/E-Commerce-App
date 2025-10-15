

import 'package:dio/dio.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';
import 'package:ecommerce/feature/auth/domain/usercase/auth_usercase.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';
import 'package:ecommerce/feature/cart/data/repo/cart_repo_impl.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';
import 'package:ecommerce/feature/cart/domain/usecase/cart_usecase.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/remote_cart_bloc.dart';
import 'package:ecommerce/feature/cart/presentation/state/get_total_cubit.dart';
import 'package:ecommerce/feature/home/data/datasource/home_data_source.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/data/repo/home_repo_impl.dart';
import 'package:ecommerce/feature/home/domain/repo/home_repo.dart';
import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/with_list_bloc.dart';
import 'package:ecommerce/feature/home/presentation/state/wishlist_id_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;



Future<void> setUpLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final InternetConnectionChecker connectionChecker = InternetConnectionChecker.createInstance();
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => connectionChecker);
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: locator()));
  final dio = Dio(
  BaseOptions(
    baseUrl: 'https://fakestoreapi.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Content-Type': 'application/json',
    },
  ),
);
locator.registerLazySingleton(() => dio);
  //  ================ Auth =======================
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(
    sharedPreferences: locator(), networkInfo: locator(), client: locator(), dio: locator()));
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(authDataSource: locator()));
  locator.registerLazySingleton(()=> AuthUsercase(authRepo: locator()));
  locator.registerLazySingleton( () => AuthBloc(authUsercase: locator()));

  // product and wishlist

  await Hive.initFlutter();
  Hive.registerAdapter(WishListModelAdapter());
  final wishBox = await Hive.openBox<WishListModel>('wishlist');


locator.registerLazySingleton<Box<WishListModel>>(() => wishBox);

  locator.registerLazySingleton<HomeDataSource>(() => HomeDataSourceImpl(sharedPreferences: locator(), networkInfo: locator(), dio: locator(), wishBox: locator()));
  locator.registerLazySingleton<HomeRepo>(()=> HomeRepoImpl(homeDataSource: locator()));
  locator.registerLazySingleton(() => HomeUsecase(homeRepo: locator()));
  locator.registerLazySingleton(() => ProductBloc(homeUsecase: locator()));
  locator.registerLazySingleton(() => WithListBloc(homeUsecase: locator()));
  locator.registerLazySingleton(() => WishlistIdCubit(homeUsecase: locator()));


  // cart
  locator.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(sharedPreferences: locator()));
  locator.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(sharedPreferences: locator(), networkInfo: locator(), dio: locator()));
  locator.registerLazySingleton<CartRepo>(() => CartRepoImpl(networkInfo: locator(),cartLocalDataSource: locator(), cartRemoteDataSource: locator()));
  locator.registerLazySingleton(() => CartUsecase(cartRepo: locator()));
  locator.registerLazySingleton(() => CartBloc(cartUsecase: locator()));
  locator.registerLazySingleton(() => RemoteCartBloc(cartUsecase: locator()));
  locator.registerLazySingleton(() => GetTotalCubit(cartUsecase: locator()));

}
