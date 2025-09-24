import 'package:flutter_test/flutter_test.dart';
import 'package:nestafar/models/restaurant.dart';
import 'package:nestafar/models/menu_item.dart';
import 'package:nestafar/models/cart_item.dart';

void main() {
  group('Model Tests', () {
    group('Restaurant', () {
      test('should create a Restaurant instance', () {
        const restaurant = Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'A test restaurant',
          imageUrl: 'test.jpg',
          rating: 4.5,
          deliveryTime: '30-40 min',
          deliveryFee: 2.99,
          minimumOrder: 15.0,
          cuisine: 'Italian',
          isOpen: true,
        );

        expect(restaurant.id, '1');
        expect(restaurant.name, 'Test Restaurant');
        expect(restaurant.rating, 4.5);
        expect(restaurant.isOpen, true);
      });

      test('should convert to and from JSON', () {
        const restaurant = Restaurant(
          id: '1',
          name: 'Test Restaurant',
          description: 'A test restaurant',
          imageUrl: 'test.jpg',
          rating: 4.5,
          deliveryTime: '30-40 min',
          deliveryFee: 2.99,
          minimumOrder: 15.0,
          cuisine: 'Italian',
          isOpen: true,
        );

        final json = restaurant.toJson();
        final restaurantFromJson = Restaurant.fromJson(json);

        expect(restaurantFromJson, restaurant);
      });
    });

    group('MenuItem', () {
      test('should create a MenuItem instance', () {
        final menuItem = MenuItem(
          id: '1',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato and mozzarella',
          price: 12.99,
          category: MenuCategory.mains,
          imageUrl: 'pizza.jpg',
          isAvailable: true,
          dietaryTypes: const [DietaryType.vegetarian],
          preparationTime: 15,
        );

        expect(menuItem.id, '1');
        expect(menuItem.name, 'Margherita Pizza');
        expect(menuItem.price, 12.99);
        expect(menuItem.isAvailable, true);
        expect(menuItem.dietaryTypes, contains(DietaryType.vegetarian));
      });

      test('should convert to and from JSON', () {
        final menuItem = MenuItem(
          id: '1',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato and mozzarella',
          price: 12.99,
          category: MenuCategory.mains,
          imageUrl: 'pizza.jpg',
          isAvailable: true,
          dietaryTypes: const [DietaryType.vegetarian],
          preparationTime: 15,
        );

        final json = menuItem.toJson();
        final menuItemFromJson = MenuItem.fromJson(json);

        expect(menuItemFromJson, menuItem);
      });
    });

    group('CartItem', () {
      test('should create a CartItem instance', () {
        final menuItem = MenuItem(
          id: '1',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato and mozzarella',
          price: 12.99,
          category: MenuCategory.mains,
          imageUrl: 'pizza.jpg',
          isAvailable: true,
          dietaryTypes: const [DietaryType.vegetarian],
          preparationTime: 15,
        );

        final cartItem = CartItem(
          menuItem: menuItem,
          quantity: 2,
        );

        expect(cartItem.menuItem, menuItem);
        expect(cartItem.quantity, 2);
        expect(cartItem.totalPrice, 25.98); // 12.99 * 2
      });

      test('should convert to and from JSON', () {
        final menuItem = MenuItem(
          id: '1',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato and mozzarella',
          price: 12.99,
          category: MenuCategory.mains,
          imageUrl: 'pizza.jpg',
          isAvailable: true,
          dietaryTypes: const [DietaryType.vegetarian],
          preparationTime: 15,
        );

        final cartItem = CartItem(
          menuItem: menuItem,
          quantity: 2,
        );

        final json = cartItem.toJson();
        final cartItemFromJson = CartItem.fromJson(json);

        expect(cartItemFromJson, cartItem);
      });
    });
  });
}