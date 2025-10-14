

import 'package:ecommerce/feature/cart/domain/usecase/cart_usecase.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_event.dart';
import 'package:ecommerce/feature/cart/presentation/state/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState>{
  final CartUsecase cartUsecase;
  CartBloc({required this.cartUsecase}) : super(CartIntialState()){


on<LoadCartEvent>(
  (event, emit) async {
    emit(CartLoadingState());
    final result = await cartUsecase.getCartItemsLocal();
    result.fold(
      (isLeft) {
        emit(CartErrorState(errorMesage: isLeft.message));
      }, (ifRight) {
        emit(CartLoadedState(cartItems: ifRight));
      }
    );
  }
);

on<AddToCartEvent>(
  (event, emit) async {
    emit(CartLoadingState());
    final result = await cartUsecase.addToCartLocal(event.product);
    result.fold(
      (isLeft) {
        emit(CartErrorState(errorMesage: isLeft.message));
      }, (ifRight) async{
        // get cart
        final result = await cartUsecase.getCartItemsLocal();
        result.fold(
          (isLeft) {
            emit(CartErrorState(errorMesage: isLeft.message));
          }, (ifRight) {
            emit(CartLoadedState(cartItems: ifRight));
          }
        );
      }
    );
  }
);

on<RemoveCartEvent>(
  (event, emit) async {
    emit(CartLoadingState());
    final result = await cartUsecase.removeFromCartLocal(event.productId);
    result.fold(
      (isLeft) {
        emit(CartErrorState(errorMesage: isLeft.message));
      }, (ifRight) async {
         final result = await cartUsecase.getCartItemsLocal();
         result.fold(
           (isLeft) {
             emit(CartErrorState(errorMesage: isLeft.message));
           }, (ifRight) {
             emit(CartLoadedState(cartItems: ifRight));
           }
         );
      }
    );
  }
);

  }
}