


abstract class AuthEvent {}

class LoginAuthEvent extends AuthEvent {

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