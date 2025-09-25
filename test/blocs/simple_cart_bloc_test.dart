import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/blocs/blocs.dart';
import '../../lib/repositories/repositories.dart';
import '../../lib/models/models.dart';

// Mock classes
class MockOrderRepository extends Mock implements IOrderRepository {}

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
      expect(cartBloc.state, equals(const CartInitial()));
    });

    group('AddToCart', () {
      final mockMenuItem = MenuItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
        price: 10.99,
        category: MenuCategory.mains,
        dietaryType: DietaryType.vegetarian,
        restaurantId: 'restaurant-1',
        imageUrl: 'test.jpg',
        isAvailable: true,
        preparationTimeMinutes: 15,
      );

      blocTest<CartBloc, CartState>(
        'adds item to empty cart',
        build: () => cartBloc,
        act: (bloc) => bloc.add(AddItemToCart(menuItem: mockMenuItem)),
        expect: () => [
          isA<CartUpdated>(),
        ],
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'clears all items from cart',
        build: () => cartBloc,
        act: (bloc) => bloc.add(ClearCart()),
        expect: () => [
          isA<CartInitial>()
        ],
      );
    });
  });
}