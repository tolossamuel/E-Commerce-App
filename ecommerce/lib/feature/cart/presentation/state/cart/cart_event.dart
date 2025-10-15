


abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final List<Map<String, int>> product;
  final bool remove;
  AddToCartEvent({required this.product, this.remove = false});
}

class RemoveCartEvent extends CartEvent {
  final int productId;
  RemoveCartEvent({required this.productId});
}