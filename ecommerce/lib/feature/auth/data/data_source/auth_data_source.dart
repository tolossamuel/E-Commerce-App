


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthDataSource{
  Future<Either< Failure, bool>> isLoggin();
  Future<Either< Failure, bool>> logOut();
  Future<Either< Failure, AuthEntity>> logIn(String email, String password);
}