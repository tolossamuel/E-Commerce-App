import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/model/auth_model.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDataSource {
  Future<Either<Failure, bool>> isLoggin();
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, AuthEntity>> logIn(String userName, String password);
}

class AuthDataSourceImpl extends AuthDataSource {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final http.Client client;
  AuthDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
  });
  @override
  Future<Either<Failure, bool>> isLoggin() async {
    // check if sharedPreferance save user info in string key of user
    try {
      final userData = sharedPreferences.getString("user");
      if (userData != null && userData.isNotEmpty) {
        return Right(true);
      }
      return Right(false);
    } on Exception catch (e) {
      return Left(ServerFailure(message:e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> logIn(
    String userName,
    String password,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final String url = "https://fakestoreapi.com/auth/login";
        final headers = {'Content-Type': 'application/json'};
        final body = jsonEncode({"username": userName, "password": password});
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = response.body;
          final jsonData = jsonDecode(result);
        
          final dynamic userData = {
            "token": jsonData["token"] ?? "",
            "userName": userName,
          };
          final AuthModel authModel = AuthModel.fromJson(userData);
          final AuthEntity authEntity = authModel.toEntity();
          await sharedPreferences.setString("user", jsonEncode(userData));
          return Right(authEntity);
        } else {
          return left(UserNotFound(message:"user not found"));
        }
      } else {
        return left(NetworkFailure(message:"no connection"));
      }
    } catch (e) {
      return left(ServerFailure(message:"please try again $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      await sharedPreferences.remove("user");
      return Right(true);
    } catch (e) {
      return left(ServerFailure(message: "please try again"));
    }
  }
}
