


import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithListBloc extends Bloc<WishListEvent, WishListState>{
  final HomeUsecase homeUsecase;

  WithListBloc({required this.homeUsecase}) : super(WishListInitialState()){

    // get wish list
    on<GetWishListEvent>(
      (event, emit) async {
        emit(WishListLoadingState());
        final result = await homeUsecase.getWishList();
        result.fold(
          (failure) {
            emit(WishListErrorState(message: failure.message));
          },
          (wishList) {
            emit(WishListLoadedState(wishList: wishList));
          },
        );
      },
    );

    // add to wish list
    on<AddToWishListEvent>(
      (event, emit) async {
        emit(WishListLoadingState());
        final result = await homeUsecase.addToWishList(event.product);
        result.fold(
          (failure) {
            emit(WishListErrorState(message: failure.message));
          },
          (wishList) async {
            emit(WishListSuccessMessage(message: "Added to wish list"));
            emit(WishListLoadingState());
            final wishListProduct = await homeUsecase.getWishList();
            wishListProduct.fold(
              (failure) {
                emit(WishListErrorState(message: failure.message));
              },
              (wishList) {
                emit(WishListLoadedState(wishList: wishList));
              },
            );
          },
        );
      },
    );

    // remove form wish list
    on<RemoveWishListEvent>(
      (event, emit) async {
        
        final result = await homeUsecase.removeFromWishList(event.productId);
        result.fold(
          (failure) {
            emit(WishListErrorState(message: failure.message));
          },
          (wishList) async {
            emit(WishListSuccessMessage(message: "Removed from wish list"));
            emit(WishListLoadingState());
            final wishListProduct = await homeUsecase.getWishList();
            wishListProduct.fold(
              (failure) {
                emit(WishListErrorState(message: failure.message));
              },
              (wishList) {
                emit(WishListLoadedState(wishList: wishList));
              },
            );
          },
        );
      }
    );

  }

}