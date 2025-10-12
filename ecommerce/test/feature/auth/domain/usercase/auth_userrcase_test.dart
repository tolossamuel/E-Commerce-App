



import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:ecommerce/feature/auth/domain/usercase/auth_usercase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main(){
  late AuthUsercase authUsercase;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    authUsercase = AuthUsercase(authRepo: mockAuthRepo);
  });

  AuthEntity authEntity = AuthEntity(
    token: "token",
    userName: "userName"
  );
  // test login 
  test(
    "should return AuthEntity when call login from the repository",
    () async {
      // arrange
      when(mockAuthRepo.login("email", "password")).thenAnswer((_) async => Right(authEntity));
      // act 
      final result = await authUsercase.login("email", "password");
      // assert
      expect(result, Right(authEntity));
    }
  );

  test(
    "should return Failure when call login from the repository",
    () async {
      // arrange
      when(mockAuthRepo.login("email", "password")).thenAnswer((_) async => Left(NetworkFailure("Failure") as Failure));
      // act
      final result = await authUsercase.login("email", "password");
      // assert
   
      expect(result, Left(NetworkFailure("Failure")));
    }
  );
  //  test logout
  test(
    "should return True when call logOut from the repository",
    () async {
      // arrange
      when(mockAuthRepo.logOut()).thenAnswer((_) async => Right(true));
      // act 
      final result = await authUsercase.logOut();
      // assert
      expect(result, Right(true));
    }
  );

  test(
    "should return Failure when call logout from the repository",
    () async {
      // arrange
      when(mockAuthRepo.logOut()).thenAnswer((_) async => Left(NetworkFailure("Failure") as Failure));
      // act
      final result = await authUsercase.logOut();
      // assert
   
      expect(result, Left(NetworkFailure("Failure")));
    }
  );
  //  test isLoggin
  test(
    "should return True when call isLoggin from the repository",
    () async {
      // arrange
      when(mockAuthRepo.isLoggin()).thenAnswer((_) async => Right(true));
      // act 
      final result = await authUsercase.isLoggin();
      // assert
      expect(result, Right(true));
    }
  );

  test(
    "should return Failure when call isLoggin from the repository",
    () async {
      // arrange
      when(mockAuthRepo.isLoggin()).thenAnswer((_) async => Left(NetworkFailure("Failure") as Failure));
      // act
      final result = await authUsercase.isLoggin();
      // assert
   
      expect(result, Left(NetworkFailure("Failure")));
    }
  );
}