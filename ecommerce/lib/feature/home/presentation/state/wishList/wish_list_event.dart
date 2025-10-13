


import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';

abstract class WishListEvent {}

class AddToWishListEvent extends WishListEvent{
  final HomeEntity product;
  AddToWishListEvent({required this.product});
}

class RemoveWishListEvent extends WishListEvent{
  final int productId;
  RemoveWishListEvent({required this.productId});
}


class GetWishListEvent extends WishListEvent{}

