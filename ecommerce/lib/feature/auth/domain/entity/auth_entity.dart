
import 'package:equatable/equatable.dart';

class AuthEntity  extends Equatable{
  final String token;
  final String userName;
  
  AuthEntity({
    required this.token,
    required this.userName,
   
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [token,userName];
  
}