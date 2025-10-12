

abstract class AuthState{}

class AuthLoaddingState extends AuthState{}

class AuthLogInState extends AuthState{}

class AuthLogOutState extends AuthState{}

class AuthIntialState extends AuthState{}

class AuthErrorState extends AuthState{
  final String message;
  AuthErrorState({required this.message});
}

class AuthInputError extends AuthState{
  final String message;
  final String type;
  AuthInputError({required this.message, required this.type});
}