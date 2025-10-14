import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';

import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/test_helper.mocks.dart';



@GenerateMocks([http.Client, SharedPreferences, NetworkInfo])
void main() {
  late CartRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  late MockSharedPreferences mockSharedPreferences;

  late MockNetworkInfoImpl mockNetworkInfo;

  setUp(() {
    mockClient = MockClient();
    mockSharedPreferences = MockSharedPreferences();
    mockNetworkInfo = MockNetworkInfoImpl();
    dataSource = CartRemoteDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      networkInfo: mockNetworkInfo,
      client: mockClient,
    );
  });

  group('addToCart', () {
    final cartItems = [
      {"productId": 1, "quantity": 2}
    ];

    test('should return Right(true) when API call succeeds', () async {
      when(mockSharedPreferences.getString("userId"))
          .thenReturn("1");

      when(mockClient.post(
        Uri.parse("https://fakestoreapi.com/carts"),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{}', 200));

      final result = await dataSource.addToCart(cartItems);

      expect(result, const Right(true));
      verify(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    test('should return Left(ServerFailure) when response is not 200', () async {
      when(mockSharedPreferences.getString("userId"))
          .thenReturn("1");

      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{}', 400));

      final result = await dataSource.addToCart(cartItems);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test('should return Left(UserNotFound) when userId not found', () async {
      when(mockSharedPreferences.getString("userId")).thenReturn(null);

      final result = await dataSource.addToCart(cartItems);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<UserNotFound>());
    });
  });

  group('removeFromCart', () {
    test('should return Right(true) when delete is successful', () async {
      when(mockClient.delete(
        Uri.parse("https://fakestoreapi.com/carts/1"),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('{}', 200));

      final result = await dataSource.removeFromCart(1);

      expect(result, const Right(true));
    });

    test('should return Left(ServerFailure) when delete fails', () async {
      when(mockClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{}', 400));

      final result = await dataSource.removeFromCart(1);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });

  group('getCartItems', () {
    final cartResponse = jsonEncode([
      {
        "id": 1,
        "userId": 1,
        "date": "2020-03-02T00:00:00.000Z",
        "products": [
          {"productId": 1, "quantity": 4},
          {"productId": 2, "quantity": 1},
          {"productId": 3, "quantity": 6}
        ]
      },
      {
        "id": 2,
        "userId": 1,
        "date": "2020-01-02T00:00:00.000Z",
        "products": [
          {"productId": 2, "quantity": 4},
          {"productId": 1, "quantity": 10},
          {"productId": 5, "quantity": 2}
        ]
      }
    ]);

    final productsResponse = jsonEncode([
      {
        "id": 1,
        "title": "Test Product 1",
        "price": 10.0,
        "description": "desc",
        "image": "img",
        "category": "cat",
        "rating": {"rate": 4.5, "count": 10}
      },
      {
        "id": 2,
        "title": "Test Product 2",
        "price": 20.0,
        "description": "desc",
        "image": "img",
        "category": "cat",
        "rating": {"rate": 4.2, "count": 5}
      },
      {
        "id": 5,
        "title": "Test Product 5",
        "price": 50.0,
        "description": "desc",
        "image": "img",
        "category": "cat",
        "rating": {"rate": 3.8, "count": 8}
      }
    ]);

    test('should return Right(List<CartEntity>) when successful', () async {
      when(mockSharedPreferences.getString("userId")).thenReturn("1");
      when(mockSharedPreferences.getString("product")).thenReturn(null);

      when(mockClient.get(
        Uri.parse("https://fakestoreapi.com/carts/user/1"),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(cartResponse, 200));

      when(mockClient.get(
        Uri.parse("https://fakestoreapi.com/products"),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(productsResponse, 200));

      final result = await dataSource.getCartItems();

      expect(result.isRight(), true);
      final items = result.getOrElse(() => []);
      expect(items, isA<List<CartEntity>>());
      expect(items.first.id, 1);
    });

    test('should return Left(UserNotFound) when userId not found', () async {
      when(mockSharedPreferences.getString("userId")).thenReturn(null);

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<UserNotFound>());
    });

    test('should return Left(ServerFailure) when response fails', () async {
      when(mockSharedPreferences.getString("userId")).thenReturn("1");

      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{}', 400));

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });
}
