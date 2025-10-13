import 'package:hive/hive.dart';

part 'wishlist_model.g.dart';

@HiveType(typeId: 1)
class WishListModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String descr;

  @HiveField(5)
  final Map<String, dynamic> rating;

  @HiveField(6)
  final String category;

  WishListModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.descr,
    required this.rating,
    required this.category,
  });

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        price: (json['price'] as num).toDouble(),
        descr: json['description'],
        rating: Map<String, dynamic>.from(json['rating']),
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'price': price,
        'description': descr,
        'rating': rating,
        'category': category,
      };
}
