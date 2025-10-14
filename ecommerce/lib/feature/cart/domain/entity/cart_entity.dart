


import 'package:equatable/equatable.dart';

class CartEntity extends Equatable{
  final int id;
  final String title;
  final String image;
  final String descr;
  final double price;
  final int quantity;
  final String catagory;
  final Map<String, dynamic> rating;

  const CartEntity({
    required this.catagory,
    required this.descr,
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.rating,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, title, image, descr, price, quantity, catagory, rating];
}