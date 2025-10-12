

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{}

class NetworkFailure extends Failure{
  final String message;
  NetworkFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure{
  final String message;
  ServerFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure{
  final String message;
  CacheFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class UserNotFound extends Failure{
  final String message;
  UserNotFound(this.message);
  @override
  List<Object?> get props => [message];
}