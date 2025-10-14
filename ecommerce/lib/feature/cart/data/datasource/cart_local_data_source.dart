


import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<Either<Failure, bool>> addToCart(List<Map<String,int>> cartProducts);
  Future<Either<Failure, bool>> removeFromCart(int itemId);
  Future<Either<Failure, List<CartEntity>>> getCartItems();
}


class CartLocalDataSourceImpl extends CartLocalDataSource{
  final SharedPreferences sharedPreferences;
  CartLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Either<Failure, bool>> addToCart(List<Map<String,int>> cartProducts) async{
    try{
      final cartItems = sharedPreferences.getString("cart_items") ?? "{}";
      final cartMap = jsonDecode(cartItems) as Map<String, dynamic>;
      for (var product in cartProducts){
        final productId = product["productId"]?? -1;
        final quantity = product["quantity"] ?? 0;
        if (productId != -1 && quantity > 0) {
          cartMap[productId.toString()] = cartMap.containsKey(productId.toString()) ? cartMap[productId.toString()]! + quantity : quantity;
        }
      }
      sharedPreferences.setString("cart_items", jsonEncode(cartMap));
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: "Failed to add to cart"));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCartItems() async{
    try{
      
      final List<CartEntity> cartItems = [];
      final cartJson = sharedPreferences.getString("cart_items") ?? "{}";
      final cartMap = jsonDecode(cartJson) as Map<String, dynamic>;
      final jsonProduct = sharedPreferences.getString("product");
      if(jsonProduct == null) {
        return Right(cartItems);
      }
      
      final productList = jsonDecode(jsonProduct) as List;
      print(productList);
      print(cartMap);
      for (var product in productList) {
        final productId = product["id"].toString();
        if(cartMap.containsKey(productId)){
          cartItems.add(
            CartEntity(
              id: product["id"],
              title: product["title"],
              price: product["price"].toDouble(),
              descr: product["description"],
              image: product["image"],
              quantity: cartMap[productId]??0,
              rating: product["rating"],
              catagory: product["category"]
            )

          );
        }
      }
      return Right(cartItems);
    } catch (e) {
      return Left(ServerFailure(message: "Failed to get cart items"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(int itemId) async {
    try {
      print(123);
      final cartJson = sharedPreferences.getString("cart_items") ?? "{}";
      final cartMap = jsonDecode(cartJson) as Map<String, dynamic>;
      if (cartMap.containsKey(itemId.toString())) {
        cartMap.remove(itemId.toString());
        sharedPreferences.setString("cart_items", jsonEncode(cartMap));
      }
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: "Failed to remove from cart"));
    }
  }
}