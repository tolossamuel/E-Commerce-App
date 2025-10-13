



import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/home/data/model/home_model.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
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
  final http.Client client;
  final Box<WishListModel> wishBox;

  HomeDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
    required this.wishBox
  });
  @override
  Future<Either<Failure, bool>> addToWishList(HomeEntity product) async{
    try{
      await wishBox.put(product.id, WishListModel.fromEntity(product));
      return Right(true);
    } catch(e) {
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
            final HomeEntity homeEntity = homeModel.toEntity();
            product.add(homeEntity);
          }
          return Right(product);
          
        }
        else {
            return Left(NetworkFailure(message: "Please check your internet connection"));
          }
      }
      final String url = "https://fakestoreapi.com/products";
      final header = {"content-type": "application/json"};
      final result = await client.get(Uri.parse(url), headers: header);
      if (result.statusCode == 200) {
        await sharedPreferences.setString("product", result.body);
        final data = json.decode(result.body) as List;
        final List<HomeEntity> product = [];
        for (var element in data) {
          final HomeModel homeModel = HomeModel.fromJson(element);
          final HomeEntity homeEntity = homeModel.toEntity();
          product.add(homeEntity);
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
    // TODO: implement getProductByCatagory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, HomeEntity>> getSingleProduct(int id) {
    // TODO: implement getSingleProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getWishList() async{
    try{
      final List<HomeEntity> wishList = [];
      for (var element in wishBox.values){
        final HomeEntity entity = element.toEntity();
        wishList.add(entity);
      }
      return Right(wishList);
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }

  @override
  Future<Either<Failure, Set<int>>> getWishListId() async{
    try{
      final Set<int> wishListSets = {};
      for (var element in wishBox.values){
        wishListSets.add(element.id);
      }
      return Right(wishListSets);
    } catch (e) {
      return Left(ServerFailure(message: "Please try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromWishList(int productId) async{
    try{
      wishBox.delete(productId);
      return Future.value(Right(true));
    } catch (e) {
      return Future.value(Left(ServerFailure(message: "Please try again")));
    }
  }
  
}