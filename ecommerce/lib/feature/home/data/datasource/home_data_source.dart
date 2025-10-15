import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/home/data/model/home_model.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeDataSource {
  Future<Either<Failure, List<HomeEntity>>> getAllProduct();
  Future<Either<Failure, HomeEntity>> getSingleProduct(int id);
  Future<Either<Failure, List<HomeEntity>>> getProductByCatagory();
  Future<Either<Failure, List<HomeEntity>>> getWishList();
  Future<Either<Failure, Set<int>>> getWishListId();
  Future<Either<Failure, bool>> addToWishList(HomeEntity product);
  Future<Either<Failure, bool>> removeFromWishList(int productId);
}

class HomeDataSourceImpl extends HomeDataSource {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final Box<WishListModel> wishBox;
  final Dio dio;

  HomeDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.wishBox,
    required this.dio,
  });

  @override
  Future<Either<Failure, bool>> addToWishList(HomeEntity product) async {
    try {
      final existingList = sharedPreferences.getStringList("wishListId") ?? [];
      final existingSet = existingList.toSet();
      existingSet.add(product.id.toString());
      await wishBox.put(product.id, WishListModel.fromEntity(product));
      await sharedPreferences.setStringList("wishListId", existingSet.toList());
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(message: "product not added to wishlist"));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllProduct() async {
    try {
      if (!await networkInfo.isConnected) {
        final cacheData = sharedPreferences.getString("product");
        if (cacheData != null) {
          final data = json.decode(cacheData) as List;
          final List<HomeEntity> product = [];
          for (var element in data) {
            final HomeModel homeModel = HomeModel.fromJson(element);
            product.add(homeModel.toEntity());
          }
          return Right(product);
        } else {
          return Left(NetworkFailure(message: "Please check your internet connection"));
        }
      }

      final String url = "https://fakestoreapi.com/products";
      final result = await dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (result.statusCode == 200) {
        final data = result.data as List;
        await sharedPreferences.setString("product", jsonEncode(data));

        final List<HomeEntity> product = [];
        for (var element in data) {
          final HomeModel homeModel = HomeModel.fromJson(element);
          product.add(homeModel.toEntity());
        }
        return Right(product);
      } else {
        return Left(ServerFailure(message: "Please try again later"));
      }
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getProductByCatagory() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, HomeEntity>> getSingleProduct(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getWishList() async {
    try {
      final List<HomeEntity> wishList = [];
      for (var element in wishBox.values) {
        wishList.add(element.toEntity());
      }
      return Right(wishList);
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }

  @override
  Future<Either<Failure, Set<int>>> getWishListId() async {
    try {
      final List<String> storedList = sharedPreferences.getStringList("wishListId") ?? [];
      final Set<int> wishListSets = storedList.map((e) => int.parse(e)).toSet();
      return Right(wishListSets);
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromWishList(int productId) async {
    try {
      final List<String> storedList = sharedPreferences.getStringList("wishListId") ?? [];
      wishBox.delete(productId);
      storedList.remove(productId.toString());
      await sharedPreferences.setStringList("wishListId", storedList);
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }
}
