import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';


class HomeModel extends HomeEntity {
  const HomeModel({
    required super.id,
    required super.title,
    required super.image,
    required super.price,
    required super.descr,
    required super.rating,
    required super.category,
  });

  /// Create HomeModel from JSON
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      descr: json['description'],
      rating: Map<String, dynamic>.from(json['rating']),
      category: json['category'],
    );
  }

  /// Convert HomeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'description': descr,
      'rating': rating,
      'category': category,
    };
  }

  /// Convert to entity (optional, here already a HomeEntity)
  HomeEntity toEntity() {
    return HomeEntity(
      id: id,
      title: title,
      image: image,
      price: price,
      descr: descr,
      rating: rating,
      category: category,
    );
  }
}