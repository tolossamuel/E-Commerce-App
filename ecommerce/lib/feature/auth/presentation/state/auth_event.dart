


abstract class AuthEvent {}

class LoginAuthEvent extends AuthEvent {
  final String userName;
  final String password;

  LoginAuthEvent({
    required this.password,
    required this.userName
  });
}

class LogOutAuthEvent extends AuthEvent {}

class IsLoginAuthEvent extends AuthEvent{}