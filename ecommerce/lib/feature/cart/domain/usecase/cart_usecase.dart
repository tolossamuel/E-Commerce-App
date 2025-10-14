


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';

class CartUsecase {
  final CartRepo cartRepo;
  CartUsecase({required this.cartRepo});

  Future<Either<Failure, bool>> addToCart(CartEntity cartEntity) async{
    return await cartRepo.addToCart(cartEntity);
  }

  Future<Either<Failure, bool>> removeFromCart(int productId) async {
    return await cartRepo.removeFromCart(productId);
  }

  Future<Either<Failure, List<CartEntity>>> getCartItems() async {
    return await cartRepo.getCartItems();
  }
}