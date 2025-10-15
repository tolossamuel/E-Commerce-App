
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/test_helper.mocks.dart';
import '../repo/cart_repo_impl_test.mocks.dart';

@GenerateMocks([Dio, SharedPreferences, NetworkInfo])
void main() {
  late CartRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPreferences;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDio = MockDio();
    mockSharedPreferences = MockSharedPreferences();
    mockNetworkInfo = MockNetworkInfo();

    dataSource = CartRemoteDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      networkInfo: mockNetworkInfo,
      dio: mockDio,
    );
  });

  // =================== ADD TO CART =======================
  group('🛒 addToCart', () {
    final cartItems = [
      {"productId": 1, "quantity": 2}
    ];

    test('✅ should return Right(true) when Dio post succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(1);

      when(mockDio.post(
        '/carts',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts'),
          statusCode: 200,
          data: {},
        ),
      );

      final result = await dataSource.addToCart(cartItems);

      expect(result, const Right(true));

      verify(mockDio.post(
        '/carts',
        data: argThat(
          allOf(
            containsPair('userId', 1),
            contains('products'),
          ),
          named: 'data',
        ),
        options: anyNamed('options'),
      )).called(1);
    });

    test('❌ should return Left(ServerFailure) when Dio response is not 200', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(1);

      when(mockDio.post(
        '/carts',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts'),
          statusCode: 400,
          data: {},
        ),
      );

      final result = await dataSource.addToCart(cartItems);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test('❌ should return Left(UserNotFound) when userId not found', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(null);

      final result = await dataSource.addToCart(cartItems);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<UserNotFound>());
    });

    test('❌ should return Left(NetworkFailure) when not connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await dataSource.addToCart(cartItems);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<NetworkFailure>());
    });
  });

  // =================== REMOVE FROM CART =======================
  group('🗑 removeFromCart', () {
    test('✅ should return Right(true) when Dio delete succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockDio.delete(
        '/carts/1',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/1'),
          statusCode: 200,
          data: {},
        ),
      );

      final result = await dataSource.removeFromCart(1);

      expect(result, const Right(true));

      verify(mockDio.delete(
        '/carts/1',
        options: anyNamed('options'),
      )).called(1);
    });

    test('❌ should return Left(ServerFailure) when Dio delete fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockDio.delete(
        '/carts/1',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/1'),
          statusCode: 400,
          data: {},
        ),
      );

      final result = await dataSource.removeFromCart(1);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test('❌ should return Left(NetworkFailure) when not connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await dataSource.removeFromCart(1);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<NetworkFailure>());
    });
  });

  // =================== GET CART ITEMS =======================
  group('📦 getCartItems', () {
    final cartResponse = [
      {
        "id": 1,
        "userId": 1,
        "date": "2020-03-02T00:00:00.000Z",
        "products": [
          {"productId": 1, "quantity": 4},
          {"productId": 2, "quantity": 1},
        ]
      }
    ];

    final productsResponse = [
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
        "price": 15.0,
        "description": "desc2",
        "image": "img2",
        "category": "cat2",
        "rating": {"rate": 4.0, "count": 5}
      }
    ];

    test('✅ should return Right(List<CartEntity>) when Dio get succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(1);
      when(mockSharedPreferences.getString("product")).thenReturn(null);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setDouble(any, any))
          .thenAnswer((_) async => true);

      when(mockDio.get(
        '/carts/user/1',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/user/1'),
          statusCode: 200,
          data: cartResponse,
        ),
      );

      when(mockDio.get(
        '/products',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/products'),
          statusCode: 200,
          data: productsResponse,
        ),
      );

      final result = await dataSource.getCartItems();

      expect(result.isRight(), true);
      final items = result.getOrElse(() => []);
      expect(items, isA<List<CartEntity>>());
      expect(items.first.id, 1);
    });

    test('❌ should return Left(UserNotFound) when userId not found', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(null);

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<UserNotFound>());
    });

    test('❌ should return Left(ServerFailure) when Dio fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockSharedPreferences.getInt("userId")).thenReturn(1);

      when(mockDio.get(
        '/carts/user/1',
        options: anyNamed('options'),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/carts/user/1'),
          statusCode: 400,
          data: {},
        ),
      );

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test('❌ should return Left(NetworkFailure) when no connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await dataSource.getCartItems();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<NetworkFailure>());
    });
  });
}
