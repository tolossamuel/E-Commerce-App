import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_local_data_source.dart';

import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/test_helper.mocks.dart';


@GenerateMocks([SharedPreferences])
void main() {
  late CartLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CartLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('addToCart', () {
    final cartProducts = [
      {"productId": 1, "quantity": 2},
      {"productId": 2, "quantity": 3},
    ];

    test('should add products successfully to cart', () async {
      // Arrange
      when(mockSharedPreferences.getString("cart_items"))
          .thenReturn(jsonEncode({}));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await dataSource.addToCart(cartProducts);

      // Assert
      expect(result, const Right(true));
      verify(mockSharedPreferences.setString("cart_items", any)).called(1);
    });

    test('should return Left(ServerFailure) when exception occurs', () async {
      when(mockSharedPreferences.getString("cart_items"))
          .thenThrow(Exception("error"));

      final result = await dataSource.addToCart(cartProducts);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });

  group('getCartItems', () {
    final cartItemsMap = {"1": 2, "2": 3};
    final productsList = [
      {
        "id": 1,
        "title": "Product 1",
        "price": 10.0,
        "description": "desc1",
        "image": "img1",
        "category": "cat1",
        "rating": {"rate": 4.5, "count": 10}
      },
      {
        "id": 2,
        "title": "Product 2",
        "price": 20.0,
        "description": "desc2",
        "image": "img2",
        "category": "cat2",
        "rating": {"rate": 4.2, "count": 8}
      }
    ];

    test('should return Right(List<CartEntity>) when data found', () async {
      // Arrange
      when(mockSharedPreferences.getString("cart_items"))
          .thenReturn(jsonEncode(cartItemsMap));
      when(mockSharedPreferences.getString("product"))
          .thenReturn(jsonEncode(productsList));

      // Act
      final result = await dataSource.getCartItems();

      // Assert
      expect(result.isRight(), true);
      final items = result.getOrElse(() => []);
      expect(items, isA<List<CartEntity>>());
      expect(items.length, 2);
      expect(items.first.title, "Product 1");
      expect(items.first.quantity, 2);
    });

    test('should return empty list when no products stored', () async {
      when(mockSharedPreferences.getString("cart_items"))
          .thenReturn(jsonEncode(cartItemsMap));
      when(mockSharedPreferences.getString("product")).thenReturn(null);

      final result = await dataSource.getCartItems();

      expect(result.isRight(), true);
      final items = result.getOrElse(() => []);
      expect(items, isEmpty);
    });

    test('should return Left(ServerFailure) when decoding fails', () async {
      when(mockSharedPreferences.getString("cart_items"))
          .thenReturn("invalid_json");

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });

  group('removeFromCart', () {
    final cartItems = {"1": 2, "2": 3};

    test('should remove item successfully', () async {
      when(mockSharedPreferences.getString("cart_items"))
          .thenReturn(jsonEncode(cartItems));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.removeFromCart(1);

      expect(result, const Right(true));
      verify(mockSharedPreferences.setString("cart_items", any)).called(1);
    });

    test('should return Left(ServerFailure) when exception occurs', () async {
      when(mockSharedPreferences.getString("cart_items"))
          .thenThrow(Exception("error"));

      final result = await dataSource.removeFromCart(1);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });
}
