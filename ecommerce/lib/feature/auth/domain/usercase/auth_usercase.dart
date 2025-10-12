


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:ecommerce/feature/auth/domain/repo/auth_repo.dart';

class AuthUsercase {
  final AuthRepo authRepo;
  AuthUsercase({ 
    required this.authRepo
  });

  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    return await authRepo.login(email, password);
  }

  Future<Either<Failure, bool>> logOut() async {
    return await authRepo.logOut();
  }

  Future<Either<Failure, bool>> isLoggin() async {
    return await authRepo.isLoggin();
  }
}