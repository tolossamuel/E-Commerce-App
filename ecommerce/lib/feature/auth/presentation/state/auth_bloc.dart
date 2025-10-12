

import 'package:ecommerce/feature/auth/domain/usercase/auth_usercase.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthUsercase authUsercase;
  AuthBloc({required this.authUsercase}):super(AuthIntialState()){

    on<LogOutAuthEvent>(
      (event,emit) async {
        emit(AuthLoaddingState());
        final result = await authUsercase.logOut();
        result.fold(
          (failure){
            emit(AuthErrorState(message: failure.message));
          }, 
          (right){
            emit(AuthLogOutState());
          }
          );
      }
    );
    on<IsLoginAuthEvent>(
      (event, emit) async {
        emit(AuthLoaddingState());
        final result = await authUsercase.isLoggin();

        result.fold(
          (ifLeft){
            emit(AuthErrorState(message: ifLeft.message));
          }, (ifRight) {
            emit(AuthLogInState());
          });
      }
    );

    on<LoginAuthEvent>(
      (event, emit) async {
        emit(AuthLoaddingState());
        final result = await authUsercase.login(event.userName, event.password);
        result.fold(
          (isLeft){
            emit(AuthErrorState(message: isLeft.message));
          }, (isRight){
            emit(AuthLogInState());
          });
      }
    );
  }

  
}