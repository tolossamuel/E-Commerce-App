

import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable{
  final int id;
  final String title;
  final String image;
  final double price;
  final String descr;
  final Map<String, dynamic> rating;
  final String category;

  const HomeEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.descr,
    required this.rating,
    required this.category,
  });
  @override
  List<Object> get props => [id, title, image, price, descr, rating, category];
}