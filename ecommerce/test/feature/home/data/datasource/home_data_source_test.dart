import 'dart:convert';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/data/datasource/home_data_source.dart';
import 'package:ecommerce/feature/home/data/model/home_model.dart';
import 'package:ecommerce/feature/home/data/model/wishlist_model.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import '../../../../helper/test_helper.mocks.dart';

void main() {
  late HomeDataSourceImpl dataSource;
  late MockDio dio;
  late MockNetworkInfoImpl mockNetworkInfo;
  late MockSharedPreferences mockSharedPreferences;
  late MockBox<WishListModel> mockWishBox;

  setUp(() {
    dio = MockDio();
    mockNetworkInfo = MockNetworkInfoImpl();
    mockSharedPreferences = MockSharedPreferences();
    mockWishBox = MockBox<WishListModel>();

    dataSource = HomeDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      networkInfo: mockNetworkInfo,
      dio: dio,
      wishBox: mockWishBox,
    );
  });

  group("🧡 Wishlist Operations", () {
    final testProduct = HomeModel(
      id: 1,
      title: "Test Product",
      image: "test.png",
      price: 10.0,
      descr: "Description",
      rating: {"rate": 4.5, "count": 10},
      category: "test",
    );

    test("✅ should add product to wishlist", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenReturn(["2"]);
      when(mockWishBox.put(any, any)).thenAnswer((_) async {});
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.addToWishList(testProduct.toEntity());

      expect(result.isRight(), true);
      verify(mockWishBox.put(testProduct.id, any)).called(1);
      verify(mockSharedPreferences.setStringList("wishListId", any)).called(1);
    });

    test("❌ should return ServerFailure when adding fails", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenThrow(Exception("error"));

      final result = await dataSource.addToWishList(testProduct.toEntity());

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test("✅ should remove product from wishlist", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenReturn(["1", "2"]);
      when(mockWishBox.delete(any)).thenAnswer((_) async {});
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.removeFromWishList(testProduct.id);

      expect(result.isRight(), true);
      verify(mockWishBox.delete(testProduct.id)).called(1);
      verify(mockSharedPreferences.setStringList("wishListId", any)).called(1);
    });

    test("❌ should return ServerFailure when remove fails", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenThrow(Exception("error"));

      final result = await dataSource.removeFromWishList(testProduct.id);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test("✅ should get wishlist products", () async {
      when(mockWishBox.values)
          .thenReturn([WishListModel.fromEntity(testProduct.toEntity())]);

      final result = await dataSource.getWishList();

      expect(result.isRight(), true);
      final products = result.getOrElse(() => []);
      expect(products, isA<List<HomeEntity>>());
      expect(products.first.id, testProduct.id);
    });

    test("❌ should return ServerFailure when get wishlist fails", () async {
      when(mockWishBox.values).thenThrow(Exception("error"));

      final result = await dataSource.getWishList();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });

    test("✅ should get wishlist IDs", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenReturn(["1", "2"]);

      final result = await dataSource.getWishListId();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), {1, 2});
    });

    test("❌ should return ServerFailure when wishlist ID fails", () async {
      when(mockSharedPreferences.getStringList("wishListId"))
          .thenThrow(Exception("error"));

      final result = await dataSource.getWishListId();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });

  group("🛒 Get All Products", () {
    final jsonResponse = [
      {
        "id": 1,
        "title": "Backpack",
        "price": 109.95,
        "description": "A nice backpack",
        "category": "men's clothing",
        "image": "https://example.com/img.png",
        "rating": {"rate": 3.9, "count": 120},
      },
    ];

    test("✅ should return products when online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(dio.get(any,
              options: anyNamed("options")))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ""),
                statusCode: 200,
                data: jsonResponse,
              ));

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      final result = await dataSource.getAllProduct();

      expect(result.isRight(), true);
      final products = result.getOrElse(() => []);
      expect(products.first.id, 1);
      verify(mockSharedPreferences.setString("product", jsonEncode(jsonResponse)))
          .called(1);
    });

    test("✅ should return cached products when offline", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockSharedPreferences.getString("product"))
          .thenReturn(jsonEncode(jsonResponse));

      final result = await dataSource.getAllProduct();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => [])[0].id, 1);
    });

    test("❌ should return NetworkFailure when offline & no cache", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockSharedPreferences.getString("product")).thenReturn(null);

      final result = await dataSource.getAllProduct();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<NetworkFailure>());
    });

    test("❌ should return ServerFailure when Dio fails", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(dio.get(any, options: anyNamed("options")))
          .thenThrow(DioError(
        requestOptions: RequestOptions(path: ""),
        response: Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 500,
          data: "error",
        ),
      ));

      final result = await dataSource.getAllProduct();

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (_) => null), isA<ServerFailure>());
    });
  });
}
