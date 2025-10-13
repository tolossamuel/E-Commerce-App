


import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';

abstract class WishListState{}

class WishListInitialState extends WishListState{}

class WishListLoadedState extends WishListState{
  final List<HomeEntity> wishList;
  WishListLoadedState({required this.wishList});
}

class WishListErrorState extends WishListState{
  final String message;
  WishListErrorState({required this.message});
}


class WishListLoadingState extends WishListState{}

class WishListSuccessMessage extends WishListState{
  final String message;
  WishListSuccessMessage({required this.message});
}