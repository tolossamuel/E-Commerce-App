


import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/failure/failure.dart';

import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main(){
  late AuthDataSourceImpl authDataSourceImpl;
  late MockClient mockClient;
  late MockNetworkInfoImpl networkInfoImpl;
  late MockSharedPreferences sharedPreferences;

  setUp((){
    mockClient = MockClient();
    networkInfoImpl = MockNetworkInfoImpl();
    sharedPreferences = MockSharedPreferences();
    authDataSourceImpl = AuthDataSourceImpl(
      sharedPreferences: sharedPreferences,
      networkInfo: networkInfoImpl,
      client: mockClient,
    );
  });


   
   group(
    "AuthDataSourceImpl Login",
    () {
      test(
        "should return authorized data when call login from the backend",
        () async {
          // arrange
          when(networkInfoImpl.isConnected).thenAnswer((_) async => true);
          when(
            mockClient.post(
              Uri.parse("https://fakestoreapi.com/auth/login"),
              headers: {'Content-Type': 'application/json'},
              body: {"username": "johnd", "password": "m38rmF\$"}
            )
          ).thenAnswer((_) async => http.Response('{"token":"token"}', 200));
          when(sharedPreferences.setString(any, any)).thenAnswer((_) async => true);
          // act
          final result = await authDataSourceImpl.logIn("johnd", "m38rmF\$");

          // assert
          expect(result,isA<Right<Failure, AuthEntity>>());
        }
      );
    
   
      test(
        "should return Failure when call login from the backend",
        () async {
          // arrange
          when(networkInfoImpl.isConnected).thenAnswer((_) async => true);
          when(
            mockClient.post(
              Uri.parse("https://fakestoreapi.com/auth/login"),
              headers: {'Content-Type': 'application/json'},
              body: {"username": "john@gmail.com", "password": "m38rmF\$"}
            )
          ).thenAnswer((_) async => http.Response('{"error":"Failure"}', 400));
          // act
          final result = await authDataSourceImpl.logIn("john@gmail.com", "m38rmF\$");

          // assert
          expect(result, Left(UserNotFound("user not found")));
        }
      );
    }
   );
  
}