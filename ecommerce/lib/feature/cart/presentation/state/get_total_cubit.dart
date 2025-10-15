


import 'package:ecommerce/feature/cart/domain/usecase/cart_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTotalCubit extends Cubit<double> {
  final CartUsecase cartUsecase;

  GetTotalCubit({required this.cartUsecase}) : super(0.0);

  Future<void> fetchTotalPrice() async {
    final result = await cartUsecase.getTotalPrice();
    emit(result);
  }
}