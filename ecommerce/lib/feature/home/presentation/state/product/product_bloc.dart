



import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_event.dart';
import 'package:ecommerce/feature/home/presentation/state/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final HomeUsecase homeUsecase;
  ProductBloc({required this.homeUsecase}): super(ProductInitialState()){

    on<GetProductsEvent>(
      (event, emit) async {
        emit(ProductLoadingState());
        final result = await homeUsecase.getAllProduct();
        result.fold(
          (failure) {
            emit(ProductErrorState(message: failure.message));
          },
          (products) {
            emit(ProductLoadedState(products: products));
          },
        );
      }
    );
  }
}