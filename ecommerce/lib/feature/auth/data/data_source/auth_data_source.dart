import 'dart:convert';

import 'package:dartz/dartz.dart';
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
  AuthDataSourceImpl({
    required this.sharedPreferences,
    required this.networkInfo,
    required this.client,
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
          if (!await getUserId(userName)){
            return left(UserNotFound(message: "user not found"));
          }
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
  
  @override
  Future<bool> getUserId(String userName) async {
    try{
      final String url = "https://fakestoreapi.com/users";
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201){
        final result = response.body;
        final List<dynamic> jsonData = jsonDecode(result);
        for (var user in jsonData){
          if (user["username"] == userName){
            await sharedPreferences.setInt("userId", user["id"]);
            return true;
          }
        }
        return false;
      }
      return false;
    } catch (e){
      return false;
    }
  }
}
