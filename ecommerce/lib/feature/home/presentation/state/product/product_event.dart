



import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent{}

class AddProductEvent extends ProductEvent{
  final HomeEntity product;
  AddProductEvent({required this.product});
}


