

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthDataSource authDataSource;

  AuthRepoImpl({
    required this.authDataSource
  });

  @override
  Future<Either<Failure, AuthEntity>> isLoggin() async {
    return await authDataSource.isLoggin();
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    return await authDataSource.logOut();
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String userName, String password) async{
    return await authDataSource.logIn(userName, password);
  }
}