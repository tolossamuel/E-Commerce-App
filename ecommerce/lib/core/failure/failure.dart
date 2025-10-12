

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure({
    required this.message
  });
  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure{
  const  NetworkFailure({required super.message});
  
}

class ServerFailure extends Failure{
  const ServerFailure({required super.message});
  
}

class CacheFailure extends Failure{
  const CacheFailure({required super.message});
  
}

class UserNotFound extends Failure{
  const UserNotFound({required super.message});
  
}