


import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';

abstract class CartState{}

class CartIntialState extends CartState{}

class CartLoadingState extends CartState{}

class CartLoadedState extends CartState{
  final List<CartEntity> cartItems;
  CartLoadedState({required this.cartItems});
}

class CartErrorState extends CartState{
  final String errorMesage;
  CartErrorState({required this.errorMesage});
}

class CartOperationMessage extends CartState{
  final String message;
  CartOperationMessage({required this.message});
}