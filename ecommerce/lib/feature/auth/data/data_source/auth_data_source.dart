import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/model/auth_model.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDataSource {
  Future<Either<Failure, AuthEntity>> isLoggin();
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, AuthEntity>> logIn(String userName, String password);
  Future<bool> getUserId(String userName);
}

class AuthDataSourceImpl extends AuthDataSource {
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  final http.Client client;
  final Dio dio;
  AuthDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
    required this.dio,
  });
  @override
  Future<Either<Failure, AuthEntity>> isLoggin() async {
    // check if sharedPreferance save user info in string key of user
    try {
      final userData = sharedPreferences.getString("user");
      if (userData != null && userData.isNotEmpty) {
        return Right(AuthModel.fromJson(jsonDecode(userData)).toEntity());
      }
      return Left(UserNotFound(message: "user not found"));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> logIn(
    String userName,
    String password,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        // Use relative URL since Dio baseUrl is already set
        final response = await dio.post(
          '/auth/login',
          data: {"username": userName, "password": password},
          options: Options(headers: {"Content-Type": "application/json"}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Check if user exists
          if (!await getUserId(userName)) {
            return Left(UserNotFound(message: "User not found"));
          }

          final data = response.data;

          final userData = {"token": data["token"] ?? "", "userName": userName};

          final authModel = AuthModel.fromJson(userData);
          final authEntity = authModel.toEntity();

          await sharedPreferences.setString("user", jsonEncode(userData));
          return Right(authEntity);
        } else {
          return Left(UserNotFound(message: "User not found"));
        }
      } else {
        return Left(NetworkFailure(message: "No connection"));
      }
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data?["message"] ?? "Please try again",
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: "Please try again: $e"));
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

  @override
  Future<bool> getUserId(String userName) async {
    try {
      // Use relative URL since baseUrl is already set
      final response = await dio.get(
        '/users',
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> users = response.data;
        for (var user in users) {
          if (user["username"] == userName) {
            await sharedPreferences.setInt("userId", user["id"]);
            return true;
          }
        }
        return false;
      }
      return false;
    } on DioException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}
