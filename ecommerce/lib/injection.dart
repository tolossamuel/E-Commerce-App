

import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';
import 'package:ecommerce/feature/auth/domain/usercase/auth_usercase.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:get_it/get_it.dart';
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

  //  ================ Auth =======================
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sharedPreferences: locator(), networkInfo: locator(), client: locator()));
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(authDataSource: locator()));
  locator.registerLazySingleton(()=> AuthUsercase(authRepo: locator()));
  locator.registerLazySingleton( () => AuthBloc(authUsercase: locator()));

}
