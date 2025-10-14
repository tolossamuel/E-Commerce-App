



import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main(){
  late AuthRepoImpl authRepoImpl;
  late MockAuthDataSource mockAuthDataSSource;

  setUp(() {
    mockAuthDataSSource = MockAuthDataSource();
    authRepoImpl = AuthRepoImpl(authDataSource: mockAuthDataSSource);
  });
  AuthEntity authEntity = AuthEntity(
    token: "token",
    userName:  "userName"
  );
  // test login 
  test(
    "should return AuthEntity when call login from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.logIn("email", "password")).thenAnswer((_) async => Right(authEntity));
      // act 
      final result = await authRepoImpl.login("email", "password");
      // assert
      expect(result, Right(authEntity));
    }
  );

  test(
    "should return Failure when call login from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.logIn("email", "password")).thenAnswer((_) async => Left(NetworkFailure(message:"Failure") as Failure));
      // act
      final result = await authRepoImpl.login("email", "password");
      // assert
   
      expect(result, Left(NetworkFailure(message:"Failure")));
    }
  );
  //  test logout
  test(
    "should return True when call logOut from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.logOut()).thenAnswer((_) async => Right(true));
      // act 
      final result = await authRepoImpl.logOut();
      // assert
      expect(result, Right(true));
    }
  );

  test(
    "should return Failure when call logout from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.logOut()).thenAnswer((_) async => Left(NetworkFailure(message:"Failure") as Failure));
      // act
      final result = await authRepoImpl.logOut();
      // assert
   
      expect(result, Left(NetworkFailure(message:"Failure")));
    }
  );
  //  test isLoggin
  test(
    "should return True when call isLoggin from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.isLoggin()).thenAnswer((_) async => Right(authEntity));
      // act 
      final result = await authRepoImpl.isLoggin();
      // assert
      expect(result, Right(authEntity));
    }
  );

  test(
    "should return Failure when call isLoggin from the datasource",
    () async {
      // arrange
      when(mockAuthDataSSource.isLoggin()).thenAnswer((_) async => Left(NetworkFailure(message:"Failure") as Failure));
      // act
      final result = await authRepoImpl.isLoggin();
      // assert
   
      expect(result, Left(NetworkFailure(message:"Failure")));
    }
  );

}