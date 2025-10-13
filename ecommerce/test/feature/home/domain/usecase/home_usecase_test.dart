





import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/domain/usecase/home_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main(){
  late HomeUsecase homeUsecase;
  late MockHomeRepo mockHomeRepo;

  setUp((){
    mockHomeRepo = MockHomeRepo();
    homeUsecase = HomeUsecase(homeRepo: mockHomeRepo);
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
  group (
    "home usecase test",
    (){
      test(
        "should get all product from the repository",
        () async {
          // arrange
          when(mockHomeRepo.getAllProduct()).thenAnswer((_) async => Right(homeEntityList));
          // act
          final result = await homeUsecase.getAllProduct();
          // assert
          expect(result, Right(homeEntityList));
        }
      );

      test(
        "should return failure when there is an error",
        () async {
          // arrange
          when(mockHomeRepo.getAllProduct()).thenAnswer((_) async => Left(ServerFailure(message: "Server Failure")));
          // act
          final result = await homeUsecase.getAllProduct();
          // assert
          expect(result, Left(ServerFailure(message: "Server Failure")));
        }
      );
      test(
        "should get single product from the repository",
        () async {
          // arrange
          when(mockHomeRepo.getSingleProduct(any)).thenAnswer((_) async => Right(homeEntity));
          // act
          final result = await homeUsecase.getSingleProduct(1);
          // assert
          expect(result, Right(homeEntity));
        }
      );

      test(
        "should return failure when there is an error",
        () async {
          // arrange
          when(mockHomeRepo.getSingleProduct(any)).thenAnswer((_) async => Left(ServerFailure(message: "Server Failure")));
          // act
          final result = await homeUsecase.getSingleProduct(1);
          // assert
          expect(result, Left(ServerFailure(message: "Server Failure")));
        }
      );
    }
  );

  // with list
  group (
    "test wish list",
    () {
      test(
        "test get with list from repository",
        () async {
          // arrange
          when(mockHomeRepo.getWishList()).thenAnswer((_) async => Right(homeEntityList));
          // act
          final result = await homeUsecase.getWishList();
          // assert
          expect(result, Right(homeEntityList));
        }
      );

      test(
        "test add wishList to repository",
        () async {
          // arrange
          when(mockHomeRepo.addToWishList(homeEntity)).thenAnswer((_) async => Right(true));
          // act
          final result = await homeUsecase.addToWishList(homeEntity);
          // assert
          expect(result, Right(true));
        }
      );

      test(
        "test remove wishList to repository",
        () async {
          // arrange
          when(mockHomeRepo.removeFromWishList(1)).thenAnswer((_) async => Right(true));
          // act
          final result = await homeUsecase.removeFromWishList(1);
          // assert
          expect(result, Right(true));
        }
      );

      test(
        "test get with list Id from repository",
        () async {
          // arrange
          when(mockHomeRepo.getWishListId()).thenAnswer((_) async  => Right({1,2,3}));
          // act
          final result = await homeUsecase.getWishListId();
          // assert
          expect(result, isA<Right>());
        }
      );
    }
  );

}