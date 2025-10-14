


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';

class AuthUsercase {
  final AuthRepo authRepo;
  AuthUsercase({ 
    required this.authRepo
  });

  Future<Either<Failure, AuthEntity>> login(String userName, String password) async {
    return await authRepo.login(userName, password);
  }

  Future<Either<Failure, bool>> logOut() async {
    return await authRepo.logOut();
  }

  Future<Either<Failure, AuthEntity>> isLoggin() async {
    return await authRepo.isLoggin();
  }
}