


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';

abstract class CartRepo {
  Future<Either<Failure, bool>> addToCart(List<Map<String,int>> cartProducts);
  Future<Either<Failure, bool>> removeFromCart(int itemId);
  Future<Either<Failure, List<CartEntity>>> getCartItems();
  Future<Either<Failure, bool>> addToCartLocal(List<Map<String, int>> cartProducts);
  Future<Either<Failure, bool>> removeFromCartLocal(int itemId);
  Future<Either<Failure, List<CartEntity>>> getCartItemsLocal();
}