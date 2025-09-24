import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Nestafar App Tests', () {
    test('Basic test to validate test setup', () {
      // Simple test to ensure testing framework is working
      expect(1 + 1, equals(2));
      expect('Flutter', isA<String>());
      expect([1, 2, 3], hasLength(3));
    });

    test('String utilities', () {
      const text = 'Nestafar Food Ordering';
      expect(text.contains('Food'), isTrue);
      expect(text.toLowerCase(), equals('nestafar food ordering'));
      expect(text.split(' '), hasLength(3));
    });

    test('Math operations for price calculations', () {
      const price = 12.99;
      const quantity = 2;
      const deliveryFee = 2.99;
      
      final itemTotal = price * quantity;
      final orderTotal = itemTotal + deliveryFee;
      
      expect(itemTotal, equals(25.98));
      expect(orderTotal, equals(28.97));
      expect(orderTotal.toStringAsFixed(2), equals('28.97'));
    });

    test('List operations for menu items', () {
      final menuItems = ['Pizza', 'Burger', 'Salad', 'Pasta'];
      
      expect(menuItems, hasLength(4));
      expect(menuItems.first, equals('Pizza'));
      expect(menuItems.last, equals('Pasta'));
      expect(menuItems.contains('Burger'), isTrue);
      
      final filteredItems = menuItems.where((item) => item.length > 5).toList();
      expect(filteredItems, hasLength(1));
      expect(filteredItems.first, equals('Burger'));
    });

    test('Map operations for restaurant data', () {
      final restaurantData = {
        'id': '1',
        'name': 'Italian Bistro',
        'rating': 4.5,
        'isOpen': true,
        'deliveryTime': '30-40 min',
      };
      
      expect(restaurantData['name'], equals('Italian Bistro'));
      expect(restaurantData['rating'], equals(4.5));
      expect(restaurantData['isOpen'], isTrue);
      expect(restaurantData.keys, hasLength(5));
      expect(restaurantData.containsKey('deliveryTime'), isTrue);
    });
  });
}