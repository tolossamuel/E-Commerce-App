

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';

abstract class HomeRepo{
  Future<Either<Failure, List<HomeEntity>>> getAllProduct();
  Future<Either<Failure, HomeEntity>> getSingleProduct(int id);
  Future<Either<Failure, List<HomeEntity>>> getProductByCatagory();
  Future<Either<Failure, List<HomeEntity>>> getWishList();
  Future<Either<Failure, Set<int>>> getWishListId();
  Future<Either<Failure, bool>> addToWishList(int productId);
  Future<Either<Failure, bool>> removeFromWishList(int productId);
}