


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';

class CartUsecase {
  final CartRepo cartRepo;
  CartUsecase({required this.cartRepo});

  Future<Either<Failure, bool>> addToCart(List<Map<String,int>> cartProducts) async{
    return await cartRepo.addToCart(cartProducts);
  }

  Future<Either<Failure, bool>> removeFromCart(int productId) async {
    return await cartRepo.removeFromCart(productId);
  }

  Future<Either<Failure, List<CartEntity>>> getCartItems() async {
    return await cartRepo.getCartItems();
  }

  Future<Either<Failure, bool>> addToCartLocal(List<Map<String, int>> cartProducts) async {
    return await cartRepo.addToCartLocal(cartProducts);
  }

  Future<Either<Failure, bool>> removeFromCartLocal(int productId) async {
    return await cartRepo.removeFromCartLocal(productId);
  }

  Future<Either<Failure, List<CartEntity>>> getCartItemsLocal() async {
    return await cartRepo.getCartItemsLocal();
  }
  Future<double> getTotalPrice() async {
    return await cartRepo.getTotalPrice();
  }
}