import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';
import 'package:ecommerce/feature/home/data/datasource/home_data_source.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/domain/repo/home_repo.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
@GenerateMocks(
  [
    AuthRepo,
    AuthDataSource,
    NetworkInfoImpl,
    SharedPreferences,
    // home
    HomeRepo,
    Box<WishListModel>,
    HomeDataSource,
    CartRepo,
    CartLocalDataSource,
    CartRemoteDataSource
  ]
)
@GenerateMocks([
  http.Client
])
void main() {}