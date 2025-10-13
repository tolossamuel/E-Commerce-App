


import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistIdCubit extends Cubit<Set>{
  final HomeUsecase homeUsecase;
  WishlistIdCubit({required this.homeUsecase}) : super({});
  void fetchAllId() async {
    final result = await homeUsecase.getWishListId();
    result.fold(
      (ifLeft) {
        emit(state);
      }, (ifRight) {
        emit(ifRight);
      }
    );
  }
}