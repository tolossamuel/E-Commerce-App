


import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<HomeEntity> products;
  ProductLoadedState({required this.products});
}


class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState({required this.message});
}


class ProductLoadingState extends ProductState {}
