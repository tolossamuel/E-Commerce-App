






import 'package:dartz/dartz.dart';
import 'package:ecommerce/feature/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce/feature/cart/domain/usecase/cart_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/test_helper.mocks.dart';

void main(){
  late CartUsecase cartUsecase;
  late MockCartRepo mockCartRepo;

  setUp((){
    mockCartRepo = MockCartRepo();
    cartUsecase = CartUsecase(cartRepo: mockCartRepo);
  });

  CartEntity cartEntity = const CartEntity(catagory: 'Electronics', descr: 'Smartphone', id: 1, title: 'iPhone 13', image: 'image_url', price: 999.99, quantity: 1, rating: {"rate" : 4.5, "count": 100});
  List<CartEntity> cartEntityList = [cartEntity];
  List<Map<String, int>> cartProduct = [
    {
      "productId": cartEntity.id,
      "quantity": cartEntity.quantity
    }
  ];

  group(
    "test cart functionality",
    () {

      test(
        "get cart items", 
        () async {
          // arrenge
          when(mockCartRepo.getCartItems()).thenAnswer((_) async => Right(cartEntityList));

          // act
          final result  = await cartUsecase.getCartItems();

          // assert
          expect(result, Right(cartEntityList));
        }
        );

      test(
        "test add to cart",
        () async {
          when(mockCartRepo.addToCart(cartProduct)).thenAnswer((_) async => Right(true) );
          // act
          final result = await cartUsecase.addToCart(cartProduct);
          // assert
          expect(result, Right(true));
        }
      );
      test(
        "test remove from cart",
        () async {
          when(mockCartRepo.removeFromCart(1)).thenAnswer((_) async => Right(true));
          // act
          final result = await cartUsecase.removeFromCart(1);
          // assert
          expect(result, Right(true));
        }
      );
    }
  );
}