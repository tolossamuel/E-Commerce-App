import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_event.dart';
import 'package:ecommerce/feature/home/presentation/state/wishList/wish_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithListBloc extends Bloc<WishListEvent, WishListState> {
  final HomeUsecase homeUsecase;

  WithListBloc({required this.homeUsecase}) : super(WishListInitialState()) {
    
    // Helper function to fetch wishlist
    Future<void> _fetchWishList(Emitter<WishListState> emit) async {
      emit(WishListLoadingState());
      final result = await homeUsecase.getWishList();
      result.fold(
        (failure) => emit(WishListErrorState(message: failure.message)),
        (wishList) => emit(WishListLoadedState(wishList: wishList)),
      );
    }

    // Get wish list
    on<GetWishListEvent>((event, emit) async {
      await _fetchWishList(emit);
    });

    // Add to wish list
    on<AddToWishListEvent>((event, emit) async {
     
      emit(WishListLoadingState());

      final result = await homeUsecase.addToWishList(event.product);

      if (result.isLeft()) {
        emit(WishListErrorState(message: "Product not added to wishlist"));
      
      }

      // Successfully added
      emit(WishListSuccessMessage(message: "Added to wish list"));

      // Fetch updated wishlist
      await _fetchWishList(emit);
    });

    // Remove from wish list
    on<RemoveWishListEvent>((event, emit) async {
      emit(WishListLoadingState());

      final result = await homeUsecase.removeFromWishList(event.productId);

      if (result.isLeft()) {
        emit(WishListErrorState(message: "Product not removed from wishlist"));
  
      }

      // Successfully removed
      emit(WishListSuccessMessage(message: "Removed from wish list"));

      // Fetch updated wishlist
      await _fetchWishList(emit);
    });
  }
}
