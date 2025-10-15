

import 'package:ecommerce/feature/cart/domain/usecase/cart_usecase.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_event.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteCartBloc extends Bloc<CartEvent, CartState>{
  final CartUsecase cartUsecase;
  RemoteCartBloc({required this.cartUsecase}) : super(CartIntialState()){


on<LoadCartEvent>(
  (event, emit) async {
    emit(CartLoadingState());
    final result = await cartUsecase.getCartItems();
    result.fold(
      (isLeft) {
        emit(CartErrorState(errorMesage: isLeft.message));
      }, (ifRight) {
        emit(CartLoadedState(cartItems: ifRight));
      }
    );
  }
);
on<AddToCartEvent>((event, emit) async {
   
      emit(CartLoadingState());
      final result = await cartUsecase.addToCart(event.product);
      result.fold(
        // The failure case
        (failure)  {
          emit(CartOperationMessage(message: "product not added to cart"));
        },
        // The success case
        (success) {
          // If addition was successful, THEN fetch the updated list
          emit(CartOperationMessage(message: "Product added to cart"));

        },
      );
    });

on<RemoveCartEvent>((event, emit) async {
      emit(CartLoadingState());

      // First, await the result of removing the item
      final removalResult = await cartUsecase.removeFromCart(
        event.productId,
      );

      // Now, handle the result of the removal
      removalResult.fold(
        // The failure case
        (failure)  {
          emit(CartOperationMessage(message: "product not removed from cart"));
        },
        // The success case
        (success) {
          // If removal was successful, THEN fetch the updated list
          emit(CartOperationMessage(message: "Product removed from cart"));
          
        },
      );
    });

  }
}