import 'dart:convert';

import 'package:ecommerce/feature/home/data/datasource/home_data_source.dart';
import 'package:ecommerce/feature/home/data/model/home_model.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../../../helper/test_helper.mocks.dart';

void main() {
  late HomeDataSourceImpl homeDataSourceImpl;
  late MockClient mockClient;
  late MockNetworkInfoImpl networkInfoImpl;
  late MockSharedPreferences sharedPreferences;
  late MockBox<WishListModel> wishList;

  setUp(() {
    mockClient = MockClient();
    networkInfoImpl = MockNetworkInfoImpl();
    sharedPreferences = MockSharedPreferences();
    wishList = MockBox<WishListModel>();

    homeDataSourceImpl = HomeDataSourceImpl(
      client: mockClient,
      networkInfo: networkInfoImpl,
      sharedPreferences: sharedPreferences,
      wishBox: wishList,
    );
  });

  group("Wishlist Operations", () {
    final testProduct = HomeModel(
      id: 1,
      title: "Test Product",
      image: "test.png",
      price: 10.0,
      descr: "Description",
      rating: {"rate": 4.5, "count": 10},
      category: "test",
    );

    test("should add product to wishlist", () async {
      // Arrange
      when(wishList.put(any, any)).thenAnswer((_) async => Future.value());

      // Act
      final result = await homeDataSourceImpl.addToWishList(testProduct);

      // Assert
      expect(result.isRight(), true);
      verify(wishList.put(testProduct.id, any)).called(1);
    });

    test("should remove product from wishlist", () async {
      // Arrange
      when(wishList.delete(any)).thenAnswer((_) async => Future.value());

      // Act
      final result = await homeDataSourceImpl.removeFromWishList(
        testProduct.id,
      );

      // Assert
      expect(result.isRight(), true);
      verify(wishList.delete(testProduct.id)).called(1);
    });

    test("should get wishlist products", () async {
      // Arrange
      when(wishList.values).thenReturn([WishListModel.fromEntity(testProduct)]);

      // Act
      final result = await homeDataSourceImpl.getWishList();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<HomeEntity>>());
      expect(result.getOrElse(() => [])[0].id, testProduct.id);
    });

    test("should get wishlist IDs", () async {
      // Arrange
      when(wishList.values).thenReturn([WishListModel.fromEntity(testProduct)]);

      // Act
      final result = await homeDataSourceImpl.getWishListId();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), {testProduct.id});
    });
  });

  group("Get All Product", () {
    final jsonResponse = jsonEncode([
      {
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description":
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png",
        "rating": {"rate": 3.9, "count": 120},
      },
    ]);

    test("should return list of products when network is connected", () async {
      // Arrange
      when(networkInfoImpl.isConnected).thenAnswer((_) async => true);
      when(
        mockClient.get(any, headers: anyNamed("headers")),
      ).thenAnswer((_) async => http.Response(jsonResponse, 200));
      when(sharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // Act
      final result = await homeDataSourceImpl.getAllProduct();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => [])[0].id, 1);
    });

    test(
      "should return cached products when network is disconnected",
      () async {
        // Arrange
        when(networkInfoImpl.isConnected).thenAnswer((_) async => false);
        when(sharedPreferences.getString("product")).thenReturn(jsonResponse);

        // Act
        final result = await homeDataSourceImpl.getAllProduct();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => [])[0].id, 1);
      },
    );

    test(
      "should return network failure when no cache and disconnected",
      () async {
        // Arrange
        when(networkInfoImpl.isConnected).thenAnswer((_) async => false);
        when(sharedPreferences.getString("product")).thenReturn(null);

        // Act
        final result = await homeDataSourceImpl.getAllProduct();

        // Assert
        expect(result.isLeft(), true);
      },
    );
  });
}
