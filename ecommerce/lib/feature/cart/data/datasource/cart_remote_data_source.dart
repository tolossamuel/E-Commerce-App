


import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, bool>> addToCart(List<Map<String, int>> cartItem);
  Future<Either<Failure, bool>> removeFromCart(int itemId);
  Future<Either<Failure, List<CartEntity>>> getCartItems();
}


class CartRemoteDataSourceImpl extends CartRemoteDataSource{
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final http.Client client;
  CartRemoteDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
  });
  @override
  Future<Either<Failure, bool>> addToCart(List<Map<String, int>> cartItem) async{
    try{
      final String url = "https://fakestoreapi.com/carts";
      final header = {"content-type": "application/json"};
      final String userId = sharedPreferences.getString("userId") ?? "-1";
      if (userId != "-1"){
        final body = {
          "userId" : userId,
          "date" : DateTime.now().toIso8601String(),
          "products" : cartItem
        };
        final response = await client.post(
          Uri.parse(url),
          headers: header,
          body: jsonEncode(body)
        );
        if (response.statusCode == 200 || response.statusCode == 201){
          return const Right(true);
        }
        else {
          return Left(ServerFailure(message: "Failed to add to cart"));
        }
      }
      return Left(UserNotFound(message: "User not found"));
    } catch (e) {
      return Left(ServerFailure(message: "Failed to add to cart"));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCartItems() async{
    try{
      
      final userId =  sharedPreferences.getString("userId")?? "1";
      if (userId == "-1"){
        return Left(UserNotFound(message: "User not found"));
      }
      final String url = "https://fakestoreapi.com/carts/user/$userId";
      final header = {"content-type": "application/json"};
      final response = await client.get(
        Uri.parse(url),
        headers: header,
      );
     
      if(response.statusCode == 200 || response.statusCode == 201){
        final result = response.body;
        final List<dynamic> jsonData = jsonDecode(result);
        final Map<String, int> cartCount = {};
        for (var cart in jsonData){
          final List<dynamic> products = cart["products"]??[];
          for (var product in products){
            final productId = product["productId"];
            final quantity = product["quantity"];
            cartCount[productId.toString()] = cartCount.containsKey(productId.toString()) ? cartCount[productId.toString()]! + quantity : quantity;
          }
        }
        
        final List<CartEntity> carItems = [];
        // check if product in local storage
        // save cartcount to local storage
        sharedPreferences.setString("cart_items", jsonEncode(cartCount));
        final jsonProduct =  sharedPreferences.getString("product");
        List<dynamic> products = [];
        if (jsonProduct == null){
          final productUrl = "https://fakestoreapi.com/products";
          final productResponse = await client.get(
            Uri.parse(productUrl),
            headers: header,
          );
      
          if (productResponse.statusCode == 200 || productResponse.statusCode == 201){
            final productResult = productResponse.body;
            products = jsonDecode(productResult) as List;
          }
          else {
            return Left(ServerFailure(message: "Failed to get cart items"));
          }
          
        } else {
          products = jsonDecode(jsonProduct) as List;
        }
        for (var product in products){
          final productId = product["id"];
          if (cartCount.containsKey(product["id"].toString())){
            carItems.add(
              CartEntity(
                id: productId,
                title: product["title"],
                price: product["price"].toDouble(),
                descr: product["description"],
                image: product["image"],
                catagory: product["category"],
                quantity: cartCount[productId]??1,
                rating: product["rating"]
              )
            );
          }
        }
    
        return Right(carItems);
      }
      else {
        return left(ServerFailure(message: "Failed to get cart items"));
      }
    } catch (e) {
      return Left(ServerFailure(message: "Failed to get cart items"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(int itemId) async {
    try {
      final url = "https://fakestoreapi.com/carts/$itemId";
      final header = {"content-type": "application/json"};
      final result = await client.delete(
        Uri.parse(url),
        headers: header,
      );
      if(result.statusCode == 200 || result.statusCode == 201){
        return const Right(true);
      } else {
        return Left(ServerFailure(message: "Failed to remove from cart"));
      }
      
    } catch (e) {
      return Left(ServerFailure(message: "Failed to remove from cart"));
    }
  }
  
}