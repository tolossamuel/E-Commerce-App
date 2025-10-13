


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/data/datasource/home_data_source.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/domain/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo{
  final HomeDataSource homeDataSource;

  HomeRepoImpl({required this.homeDataSource});

  @override
  Future<Either<Failure, bool>> addToWishList(HomeEntity product) async {
    return await homeDataSource.addToWishList(product);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllProduct() async {
    return await homeDataSource.getAllProduct();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getProductByCatagory() async {
    return await homeDataSource.getProductByCatagory();
  }

  @override
  Future<Either<Failure, HomeEntity>> getSingleProduct(int id) async {
    return await homeDataSource.getSingleProduct(id);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getWishList() async {
    return await homeDataSource.getWishList();
  }

  @override
  Future<Either<Failure, Set<int>>> getWishListId() async {
    return await homeDataSource.getWishListId();
  }

  @override
  Future<Either<Failure, bool>> removeFromWishList(int productId) async {
    return await homeDataSource.removeFromWishList(productId);
  }
}