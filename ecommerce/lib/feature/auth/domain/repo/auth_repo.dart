


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthEntity>> login(String userName, String password);
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, AuthEntity>> isLoggin();
}