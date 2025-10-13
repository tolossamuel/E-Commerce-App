


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/domain/repo/home_repo.dart';

class HomeUsecase {
  final HomeRepo homeRepo;

  HomeUsecase({required this.homeRepo});

  Future<Either<Failure, List<HomeEntity>>> getAllProduct() async {
    return await homeRepo.getAllProduct();
  }

  Future<Either<Failure, HomeEntity>> getSingleProduct(int id) async {
    return await homeRepo.getSingleProduct(id);
  }
  Future<Either<Failure, List<HomeEntity>>> getProductByCatagory() async {
    return await homeRepo.getProductByCatagory();
  }

  Future<Either<Failure, List<HomeEntity>>> getWishList() async {
    return await homeRepo.getWishList();
  }

  Future<Either<Failure, Set<int>>> getWishListId() async {
    return await homeRepo.getWishListId();
  }

  Future<Either<Failure, bool>> addToWishList(int productId) async {
    return await homeRepo.addToWishList(productId);
  }

  Future<Either<Failure, bool>> removeFromWishList(int productId) async {
    return await homeRepo.removeFromWishList(productId);
  }
}