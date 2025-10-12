


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

class InputEvent extends AuthEvent{
  final String input;
  final String type;
  InputEvent({required this.input, required this.type});
}

class ClearInputEvent extends AuthEvent{
  ClearInputEvent();
}