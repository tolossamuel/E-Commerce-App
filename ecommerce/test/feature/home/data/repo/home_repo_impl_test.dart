




import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/data/repo/home_repo_impl.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late HomeRepoImpl homeRepoImpl;
  late MockHomeDataSource mockHomeDataSource;

  setUp((){
    mockHomeDataSource = MockHomeDataSource();
    homeRepoImpl = HomeRepoImpl(homeDataSource: mockHomeDataSource);
  });

  final HomeEntity homeEntity = const HomeEntity(
    id: 1,
    title: "title",
    image: "image",
    price: 120.0,
    descr: "user",
    rating: {"rate": 4.5, "count": 120},
    category: "category",
  );
  final List<HomeEntity> homeEntityList = [homeEntity];
  group("getAllProduct", () {
    test("should return a list of products", () async {
      // Arrange
      when(mockHomeDataSource.getAllProduct())
          .thenAnswer((_) async => Right(homeEntityList));

      // Act
      final result = await homeRepoImpl.getAllProduct();

      // Assert
      expect(result, Right(homeEntityList));
    });

    test("should return a server failure when an error occurs", () async {
      // Arrange
      when(mockHomeDataSource.getAllProduct())
          .thenAnswer((_) async => Left(ServerFailure(message: "Error")));

      // Act
      final result = await homeRepoImpl.getAllProduct();

      // Assert
      expect(result, Left(ServerFailure(message: "Error")));
    });

    test("should return a server failure when an error occurs", () async {
      // Arrange
      when(mockHomeDataSource.getAllProduct())
          .thenAnswer((_) async => Left(ServerFailure(message: "Error")));

      // Act
      final result = await homeRepoImpl.getAllProduct();

      // Assert
      expect(result, Left(ServerFailure(message: "Error")));
    });

    // with list
    test(
      "get wishlist",
      () async {
        // arrange
        when(mockHomeDataSource.getWishList()).thenAnswer((_) async => Right(homeEntityList));
        // act
      final result = await homeRepoImpl.getWishList();
      // assert
      expect(result, Right(homeEntityList));
      });
    test(
      "add wishlist",
      () async {
        // arrange
        when(mockHomeDataSource.addToWishList(homeEntity)).thenAnswer((_) async => Right(true));
        // act
        final result = await homeRepoImpl.addToWishList(homeEntity);
        // assert
        expect(result, Right(true));
      },
    );

    test(
      "remove from wishlist",
      () async {
        // arrange
        when(mockHomeDataSource.removeFromWishList(1)).thenAnswer((_) async => Right(true));
        // act
        final result = await homeRepoImpl.removeFromWishList(1);
        // assert
        expect(result, Right(true));
      }
    );
  });
}