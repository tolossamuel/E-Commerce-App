import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class defining remote data source methods
abstract class CartRemoteDataSource {
  Future<Either<Failure, bool>> addToCart(List<Map<String, int>> cartItem);
  Future<Either<Failure, bool>> removeFromCart(int itemId);
  Future<Either<Failure, List<CartEntity>>> getCartItems();
}

/// Implementation of CartRemoteDataSource using Dio
class CartRemoteDataSourceImpl extends CartRemoteDataSource {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final Dio dio;

  CartRemoteDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.dio,
  });

  static const _headers = {"Content-Type": "application/json"};

  @override
  Future<Either<Failure, bool>> addToCart(List<Map<String, int>> cartItem) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: "No connection"));
      }

      final int userId = sharedPreferences.getInt("userId") ?? -1;
      if (userId == -1) {
        return Left(UserNotFound(message: "User not found"));
      }
      final body = {
        "userId": userId,
        "date": DateTime.now().toIso8601String(),
        "products": cartItem,
      };


      final response = await dio.post(
        '/carts',
        data: body,
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
     
        return const Right(true);
      } else {
        return Left(ServerFailure(message: "Failed to add to cart"));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.response?.data?["message"] ?? e.message ?? "Failed to add to cart",
      ));
    } catch (_) {
      return Left(ServerFailure(message: "Failed to add to cart"));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCartItems() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: "No connection"));
      }

      final userId = sharedPreferences.getInt("userId") ?? -1;
      if (userId == -1) {
        return Left(UserNotFound(message: "User not found"));
      }
      final response = await dio.get(
        '/carts/user/$userId',
        options: Options(headers: _headers),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(ServerFailure(message: "Failed to get cart items"));
      }

      final List<dynamic> jsonData = response.data;
      final Map<String, int> cartCount = {};

      for (var cart in jsonData) {
        final List<dynamic> products = cart["products"] ?? [];
        for (var product in products) {
          final productId = product["productId"];
          final quantity = product["quantity"];
          cartCount[productId.toString()] =
              (cartCount[productId.toString()] ?? 0) + (quantity as int);
        }
      }

      // Save locally
      sharedPreferences.setString("cart_items", jsonEncode(cartCount));

      final jsonProduct = sharedPreferences.getString("product");
      List<dynamic> products = [];

      if (jsonProduct == null) {
        final productResponse = await dio.get(
          '/products',
          options: Options(headers: _headers),
        );

        if (productResponse.statusCode == 200 ||
            productResponse.statusCode == 201) {
          products = productResponse.data as List<dynamic>;
        } else {
          return Left(ServerFailure(message: "Failed to get cart items"));
        }
      } else {
        products = jsonDecode(jsonProduct) as List<dynamic>;
      }

      double totalPrice = 0.0;
      final List<CartEntity> cartItems = [];

      for (var product in products) {
        final productId = product["id"];
        if (cartCount.containsKey(productId.toString())) {
          totalPrice += product["price"].toDouble() *
              (cartCount[productId.toString()] ?? 1);

          cartItems.add(
            CartEntity(
              id: productId,
              title: product["title"],
              price: product["price"].toDouble(),
              descr: product["description"],
              image: product["image"],
              catagory: product["category"],
              quantity: cartCount[productId.toString()] ?? 1,
              rating: product["rating"],
            ),
          );
        }
      }

      sharedPreferences.setDouble("total_price", totalPrice);
      return Right(cartItems);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.response?.data?["message"] ?? e.message ?? "Failed to get cart items",
      ));
    } catch (_) {
      return Left(ServerFailure(message: "Failed to get cart items"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(int itemId) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: "No connection"));
      }

      final response = await dio.delete(
        '/carts/$itemId',
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(ServerFailure(message: "Failed to remove from cart"));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.response?.data?["message"] ?? e.message ?? "Failed to remove from cart",
      ));
    } catch (_) {
      return Left(ServerFailure(message: "Failed to remove from cart"));
    }
  }
}
