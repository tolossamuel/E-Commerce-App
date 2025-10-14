


abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final List<Map<String, int>> product;
  AddToCartEvent({required this.product});
}

class RemoveCartEvent extends CartEvent {
  final int productId;
  RemoveCartEvent({required this.productId});
}