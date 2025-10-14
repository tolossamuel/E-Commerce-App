


import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';

class AuthModel extends AuthEntity{
  AuthModel({required super.token, required super.userName});
  

  factory AuthModel.fromJson(dynamic json) {
    return AuthModel(
      token: json['token'] as String,
      userName: json['userName'] as String,
    );
  }

  AuthEntity toEntity() => AuthEntity(token: token, userName: userName);

  
}