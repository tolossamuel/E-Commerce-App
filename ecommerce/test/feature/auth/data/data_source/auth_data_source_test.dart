import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/failure/failure.dart';
import 'package:ecommerce/core/network_checker/network_checker.dart';
import 'package:ecommerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce/feature/auth/domain/entity/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main() {
  late AuthDataSourceImpl authDataSourceImpl;
  late MockNetworkInfoImpl mockNetworkInfo;
  late MockSharedPreferences mockSharedPreferences;
  late MockDio mockDio;
  late MockClient mockClient;

  setUp(() {
    mockNetworkInfo = MockNetworkInfoImpl();
    mockSharedPreferences = MockSharedPreferences();
    mockDio = MockDio();
    mockClient = MockClient();

    authDataSourceImpl = AuthDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      networkInfo: mockNetworkInfo,
      client: mockClient, // unused
      dio: mockDio,
    );
  });

  const tUsername = 'johnd';
  const tPassword = 'm38rmF\$';

  group('logIn', () {
    test('should return AuthEntity when login is successful', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDio.post(
        '/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 200,
            data: {'token': 'token'},
          ));

      when(mockDio.get(
        '/users',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 200,
            data: [
              {'id': 2, 'username': tUsername}
            ],
          ));

      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // act
      final result = await authDataSourceImpl.logIn(tUsername, tPassword);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right<AuthEntity>'),
        (auth) {
          expect(auth.userName, tUsername);
          expect(auth.token, 'token');
        },
      );
    });

    test('should return UserNotFound when user does not exist', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockDio.post(
        '/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 200,
            data: {'token': 'token'},
          ));

      when(mockDio.get(
        '/users',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 200,
            data: [],
          ));

      final result = await authDataSourceImpl.logIn(tUsername, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UserNotFound>());
          expect(failure.message, 'User not found');
        },
        (_) => fail('Expected Left<UserNotFound>'),
      );
    });

    test('should return UserNotFound when login status code is not 200/201', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockDio.post(
        '/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 400,
            data: {'error': 'failure'},
          ));

      final result = await authDataSourceImpl.logIn(tUsername, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UserNotFound>());
          expect(failure.message, 'User not found');
        },
        (_) => fail('Expected Left<UserNotFound>'),
      );
    });

    test('should return NetworkFailure when there is no connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await authDataSourceImpl.logIn(tUsername, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'No connection');
        },
        (_) => fail('Expected Left<NetworkFailure>'),
      );
    });

    test('should return ServerFailure when Dio throws exception', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockDio.post(
        '/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/login')));

      final result = await authDataSourceImpl.logIn(tUsername, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left<ServerFailure>'),
      );
    });
  });

  group('getUserId', () {
    test('should return true when user exists', () async {
      when(mockDio.get(
        '/users',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 200,
            data: [
              {'id': 2, 'username': tUsername}
            ],
          ));

      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

      final result = await authDataSourceImpl.getUserId(tUsername);
      expect(result, true);
    });

    test('should return false when user does not exist', () async {
      when(mockDio.get(
        '/users',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 200,
            data: [],
          ));

      final result = await authDataSourceImpl.getUserId(tUsername);
      expect(result, false);
    });

    test('should return false when Dio throws exception', () async {
      when(mockDio.get(
        '/users',
        options: anyNamed('options'),
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '/users')));

      final result = await authDataSourceImpl.getUserId(tUsername);
      expect(result, false);
    });
  });

  group('logOut', () {
    test('should return true when logOut succeeds', () async {
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      final result = await authDataSourceImpl.logOut();
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right<bool>'),
        (value) => expect(value, true),
      );
    });

    test('should return ServerFailure when logOut fails', () async {
      when(mockSharedPreferences.remove(any)).thenThrow(Exception());

      final result = await authDataSourceImpl.logOut();
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left<ServerFailure>'),
      );
    });
  });

  group('isLoggin', () {
    test('should return AuthEntity when user is logged in', () async {
      final userData = jsonEncode({'token': 'token', 'userName': tUsername});
      when(mockSharedPreferences.getString('user')).thenReturn(userData);

      final result = await authDataSourceImpl.isLoggin();
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right<AuthEntity>'),
        (auth) {
          expect(auth.userName, tUsername);
          expect(auth.token, 'token');
        },
      );
    });

    test('should return UserNotFound when no user saved', () async {
      when(mockSharedPreferences.getString('user')).thenReturn(null);

      final result = await authDataSourceImpl.isLoggin();
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UserNotFound>());
          expect(failure.message, 'user not found');
        },
        (_) => fail('Expected Left<UserNotFound>'),
      );
    });
  });
}
