import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nestafar/blocs/blocs.dart';
import 'package:nestafar/repositories/repositories.dart';
import 'package:nestafar/models/models.dart';

// Mock classes
class MockOrderRepository extends Mock implements IOrderRepository {}
class MockCartItem extends Mock implements CartItem {}

void main() {
  group('CartBloc', () {
    late MockOrderRepository mockRepository;
    late CartBloc cartBloc;

    setUp(() {
      mockRepository = MockOrderRepository();
      cartBloc = CartBloc(orderRepository: mockRepository);
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is CartInitial', () {
      expect(cartBloc.state, const CartInitial());
    });

    group('AddItemToCart', () {
      final mockMenuItem = MenuItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
        price: 10.99,
        category: MenuCategory.mains,
        imageUrl: 'test.jpg',
        isAvailable: true,
        dietaryTypes: const [DietaryType.vegetarian],
        preparationTime: 15,
      );

      blocTest<CartBloc, CartState>(
        'adds item to empty cart',
        build: () => cartBloc,
        act: (bloc) => bloc.add(AddItemToCart(
          menuItem: mockMenuItem,
          restaurantId: 'restaurant-1',
        )),
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 1)
              .having((state) => state.items.first.quantity, 'quantity', 1)
              .having((state) => state.restaurantId, 'restaurant id', 'restaurant-1'),
        ],
      );

      blocTest<CartBloc, CartState>(
        'increases quantity when same item is added',
        build: () => cartBloc,
        seed: () => CartUpdated(
          items: [
            CartItem(
              menuItem: mockMenuItem,
              quantity: 1,
            )
          ],
          restaurantId: 'restaurant-1',
        ),
        act: (bloc) => bloc.add(AddItemToCart(
          menuItem: mockMenuItem,
          restaurantId: 'restaurant-1',
        )),
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 1)
              .having((state) => state.items.first.quantity, 'quantity', 2),
        ],
      );
    });

    group('RemoveItemFromCart', () {
      final mockMenuItem = MenuItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
        price: 10.99,
        category: MenuCategory.mains,
        imageUrl: 'test.jpg',
        isAvailable: true,
        dietaryTypes: const [DietaryType.vegetarian],
        preparationTime: 15,
      );

      blocTest<CartBloc, CartState>(
        'removes item completely when quantity is 1',
        build: () => cartBloc,
        seed: () => CartUpdated(
          items: [
            CartItem(
              menuItem: mockMenuItem,
              quantity: 1,
            )
          ],
          restaurantId: 'restaurant-1',
        ),
        act: (bloc) => bloc.add(RemoveItemFromCart(menuItem: mockMenuItem)),
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 0),
        ],
      );

      blocTest<CartBloc, CartState>(
        'decreases quantity when quantity is greater than 1',
        build: () => cartBloc,
        seed: () => CartUpdated(
          items: [
            CartItem(
              menuItem: mockMenuItem,
              quantity: 2,
            )
          ],
          restaurantId: 'restaurant-1',
        ),
        act: (bloc) => bloc.add(RemoveItemFromCart(menuItem: mockMenuItem)),
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 1)
              .having((state) => state.items.first.quantity, 'quantity', 1),
        ],
      );
    });

    group('ClearCart', () {
      final mockMenuItem = MenuItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
        price: 10.99,
        category: MenuCategory.mains,
        imageUrl: 'test.jpg',
        isAvailable: true,
        dietaryTypes: const [DietaryType.vegetarian],
        preparationTime: 15,
      );

      blocTest<CartBloc, CartState>(
        'clears all items from cart',
        build: () => cartBloc,
        seed: () => CartUpdated(
          items: [
            CartItem(
              menuItem: mockMenuItem,
              quantity: 2,
            )
          ],
          restaurantId: 'restaurant-1',
        ),
        act: (bloc) => bloc.add(ClearCart()),
        expect: () => [
          isA<CartUpdated>()
              .having((state) => state.items.length, 'items length', 0)
              .having((state) => state.restaurantId, 'restaurant id', null),
        ],
      );
    });
  });
}