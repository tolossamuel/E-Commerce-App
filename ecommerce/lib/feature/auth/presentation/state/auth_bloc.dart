

import 'package:ecommerce/feature/auth/domain/usercase/auth_usercase.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_event.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthUsercase authUsercase;
  AuthBloc({required this.authUsercase}):super(AuthIntialState()){
    String userName = "";
    String password = "";
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
            userName = "";
            password = "";
            emit(AuthLogInState());
          });
      }
    );

    on<LoginAuthEvent>(
      (event, emit) async {
        
        
        if (userName.isEmpty){
          emit(AuthInputError(message: "Username is required", type: "username"));
          return;
        }
        if (password.isEmpty){
          emit(AuthInputError(message: "Password is required", type: "password"));
          return;
        }
        emit(AuthLoaddingState());
       
        final result = await authUsercase.login(userName, password);
       
        result.fold(
          (isLeft){
            
            emit(AuthErrorState(message: isLeft.message));
          }, (isRight){
            emit(AuthLogInState());
          });
      }
    );

    on<InputEvent>(
      (event, emit){
     
        if (event.type == "username") {
          userName = event.input;
        } else if (event.type == "password"){
          password = event.input;
        }
      }
    );
    on<ClearInputEvent>(
      (event, emit){
        userName = "";
        password = "";
      }
    );
  }

  
}