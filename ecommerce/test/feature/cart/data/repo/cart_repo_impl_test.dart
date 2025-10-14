import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecommerce/feature/cart/data/datasource/cart_remote_data_source.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/domain/repo/cart_repo.dart';
import 'package:ecommerce/feature/cart/data/repo/cart_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

@GenerateMocks([NetworkInfo, CartRemoteDataSource, CartLocalDataSource])
void main() {
  late CartRepoImpl repo;
  late MockNetworkInfoImpl mockNetworkInfo;
  late MockCartRemoteDataSource mockRemote;
  late MockCartLocalDataSource mockLocal;

  setUp(() {
    mockNetworkInfo = MockNetworkInfoImpl();
    mockRemote = MockCartRemoteDataSource();
    mockLocal = MockCartLocalDataSource();
    repo = CartRepoImpl(
      networkInfo: mockNetworkInfo,
      cartRemoteDataSource: mockRemote,
      cartLocalDataSource: mockLocal,
    );
  });

  final cartProducts = [
    {"productId": 1, "quantity": 2},
    {"productId": 2, "quantity": 3},
  ];

  final cartEntities = [
    CartEntity(
      id: 1,
      title: "Product 1",
      price: 10.0,
      descr: "desc1",
      image: "img1",
      catagory: "cat1",
      quantity: 2,
      rating: {"rate": 4.5, "count": 10},
    )
  ];

  group('addToCart', () {
    test('should call remote when device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.addToCart(cartProducts))
          .thenAnswer((_) async => const Right(true));

      final result = await repo.addToCart(cartProducts);

      expect(result, const Right(true));
      verify(mockRemote.addToCart(cartProducts)).called(1);
      verifyNever(mockLocal.addToCart(cartProducts));
    });

    test('should call local when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.addToCart(cartProducts))
          .thenAnswer((_) async => const Right(true));

      final result = await repo.addToCart(cartProducts);

      expect(result, const Right(true));
      verify(mockLocal.addToCart(cartProducts)).called(1);
      verifyNever(mockRemote.addToCart(cartProducts));
    });
  });

  group('getCartItems', () {
    test('should call remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCartItems()).thenAnswer((_) async => Right(cartEntities));

      final result = await repo.getCartItems();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), cartEntities);
      verify(mockRemote.getCartItems()).called(1);
      verifyNever(mockLocal.getCartItems());
    });

    test('should call local when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCartItems()).thenAnswer((_) async => Right(cartEntities));

      final result = await repo.getCartItems();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), cartEntities);
      verify(mockLocal.getCartItems()).called(1);
      verifyNever(mockRemote.getCartItems());
    });
  });

  group('removeFromCart', () {
    const itemId = 1;

    test('should call remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.removeFromCart(itemId))
          .thenAnswer((_) async => const Right(true));

      final result = await repo.removeFromCart(itemId);

      expect(result, const Right(true));
      verify(mockRemote.removeFromCart(itemId)).called(1);
      verifyNever(mockLocal.removeFromCart(itemId));
    });

    test('should call local when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.removeFromCart(itemId))
          .thenAnswer((_) async => const Right(true));

      final result = await repo.removeFromCart(itemId);

      expect(result, const Right(true));
      verify(mockLocal.removeFromCart(itemId)).called(1);
      verifyNever(mockRemote.removeFromCart(itemId));
    });
  });

  group('local only methods', () {
    test('addToCartLocal calls local datasource', () async {
      when(mockLocal.addToCart(cartProducts))
          .thenAnswer((_) async => const Right(true));

      final result = await repo.addToCartLocal(cartProducts);

      expect(result, const Right(true));
      verify(mockLocal.addToCart(cartProducts)).called(1);
    });

    test('getCartItemsLocal calls local datasource', () async {
      when(mockLocal.getCartItems()).thenAnswer((_) async => Right(cartEntities));

      final result = await repo.getCartItemsLocal();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), cartEntities);
      verify(mockLocal.getCartItems()).called(1);
    });

    test('removeFromCartLocal calls local datasource', () async {
      when(mockLocal.removeFromCart(1)).thenAnswer((_) async => const Right(true));

      final result = await repo.removeFromCartLocal(1);

      expect(result, const Right(true));
      verify(mockLocal.removeFromCart(1)).called(1);
    });
  });
}
