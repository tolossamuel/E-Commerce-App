


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';

class CartRepoImpl extends CartRepo {
  final NetworkInfo networkInfo;
  final CartRemoteDataSource cartRemoteDataSource;
  final CartLocalDataSource cartLocalDataSource;

  CartRepoImpl({
    required this.networkInfo,
    required this.cartRemoteDataSource,
    required this.cartLocalDataSource
  });

  @override
  Future<Either<Failure, bool>> addToCart(List<Map<String, int>> cartProducts) async{
    if (await networkInfo.isConnected) {
      return await cartRemoteDataSource.addToCart(cartProducts);
    } else {
      return await cartLocalDataSource.addToCart(cartProducts);
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCartItems() async {
    if (await networkInfo.isConnected) {
      return await cartRemoteDataSource.getCartItems();
    } else {
      return await cartLocalDataSource.getCartItems();
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(int itemId) async {
    if (await networkInfo.isConnected) {
      return await cartRemoteDataSource.removeFromCart(itemId);
    } else {
      return await cartLocalDataSource.removeFromCart(itemId);
    }
  }
  
  @override
  Future<Either<Failure, bool>> addToCartLocal(List<Map<String, int>> cartProducts) async {
    return await cartLocalDataSource.addToCart(cartProducts);
  }
  
  @override
  Future<Either<Failure, List<CartEntity>>> getCartItemsLocal() async {
    return await cartLocalDataSource.getCartItems();
  }
  
  @override
  Future<Either<Failure, bool>> removeFromCartLocal(int itemId) async {
    return await cartLocalDataSource.removeFromCart(itemId);
  }


}