import 'dart:math';
import '../models/models.dart';
import 'restaurant_repository.dart';

/// Mock implementation of IRestaurantRepository
/// Follows Liskov Substitution Principle - can be replaced with real implementation
class RestaurantRepositoryImpl implements IRestaurantRepository {
  // Mock data - in real implementation, this would come from API/Database
  static const List<Map<String, dynamic>> _mockRestaurants = [
    {
      'id': '1',
      'name': 'Spice Paradise',
      'cuisine': 'Indian',
      'rating': 4.5,
      'deliveryTimeMinutes': 30,
      'imageUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'description': 'Authentic Indian cuisine with traditional spices',
      'deliveryFee': 2.99,
      'minimumOrder': 15.0,
      'isOpen': true,
    },
    {
      'id': '2',
      'name': 'Pizza Corner',
      'cuisine': 'Italian',
      'rating': 4.2,
      'deliveryTimeMinutes': 25,
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      'description': 'Wood-fired pizzas and Italian classics',
      'deliveryFee': 1.99,
      'minimumOrder': 12.0,
      'isOpen': true,
    },
    {
      'id': '3',
      'name': 'Dragon Palace',
      'cuisine': 'Chinese',
      'rating': 4.7,
      'deliveryTimeMinutes': 35,
      'imageUrl': 'https://images.unsplash.com/photo-1574484284002-952d92456975?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2087&q=80',
      'description': 'Traditional Chinese dishes with modern twists',
      'deliveryFee': 3.49,
      'minimumOrder': 18.0,
      'isOpen': true,
    },
    {
      'id': '4',
      'name': 'Burger Junction',
      'cuisine': 'American',
      'rating': 4.0,
      'deliveryTimeMinutes': 20,
      'imageUrl': 'https://images.unsplash.com/photo-1521017432531-fbd92d768814?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
      'description': 'Gourmet burgers and American comfort food',
      'deliveryFee': 2.49,
      'minimumOrder': 10.0,
      'isOpen': false,
    },
  ];

  static const Map<String, List<Map<String, dynamic>>> _mockMenuItems = {
    '1': [
      // Starters
      {
        'id': '1_1',
        'name': 'Samosa',
        'description': 'Crispy pastry filled with spiced potatoes and peas',
        'price': 5.99,
        'category': 'starters',
        'dietaryType': 'veg',
        'restaurantId': '1',
        'isAvailable': true,
        'preparationTimeMinutes': 10,
        'spiceLevel': 2,
      },
      {
        'id': '1_2',
        'name': 'Chicken Tikka',
        'description': 'Grilled chicken marinated in yogurt and spices',
        'price': 8.99,
        'category': 'starters',
        'dietaryType': 'non_veg',
        'restaurantId': '1',
        'isAvailable': true,
        'preparationTimeMinutes': 15,
        'spiceLevel': 3,
      },
      // Mains
      {
        'id': '1_3',
        'name': 'Butter Chicken',
        'description': 'Creamy tomato-based curry with tender chicken',
        'price': 14.99,
        'category': 'mains',
        'dietaryType': 'non_veg',
        'restaurantId': '1',
        'isAvailable': true,
        'preparationTimeMinutes': 25,
        'spiceLevel': 2,
      },
      {
        'id': '1_4',
        'name': 'Palak Paneer',
        'description': 'Spinach curry with cottage cheese cubes',
        'price': 12.99,
        'category': 'mains',
        'dietaryType': 'veg',
        'restaurantId': '1',
        'isAvailable': true,
        'preparationTimeMinutes': 20,
        'spiceLevel': 2,
      },
      // Drinks
      {
        'id': '1_5',
        'name': 'Mango Lassi',
        'description': 'Sweet yogurt drink with fresh mango',
        'price': 3.99,
        'category': 'drinks',
        'dietaryType': 'veg',
        'restaurantId': '1',
        'isAvailable': true,
        'preparationTimeMinutes': 5,
      },
    ],
    '2': [
      // Starters
      {
        'id': '2_1',
        'name': 'Garlic Bread',
        'description': 'Toasted bread with garlic butter and herbs',
        'price': 4.99,
        'category': 'starters',
        'dietaryType': 'veg',
        'restaurantId': '2',
        'isAvailable': true,
        'preparationTimeMinutes': 8,
      },
      // Mains
      {
        'id': '2_2',
        'name': 'Margherita Pizza',
        'description': 'Classic pizza with tomato sauce, mozzarella, and basil',
        'price': 12.99,
        'category': 'mains',
        'dietaryType': 'veg',
        'restaurantId': '2',
        'isAvailable': true,
        'preparationTimeMinutes': 15,
      },
      {
        'id': '2_3',
        'name': 'Pepperoni Pizza',
        'description': 'Pizza topped with pepperoni and mozzarella cheese',
        'price': 15.99,
        'category': 'mains',
        'dietaryType': 'non_veg',
        'restaurantId': '2',
        'isAvailable': true,
        'preparationTimeMinutes': 15,
      },
      // Drinks
      {
        'id': '2_4',
        'name': 'Italian Soda',
        'description': 'Refreshing carbonated drink with fruit flavors',
        'price': 2.99,
        'category': 'drinks',
        'dietaryType': 'veg',
        'restaurantId': '2',
        'isAvailable': true,
        'preparationTimeMinutes': 2,
      },
    ],
    '3': [
      // Starters
      {
        'id': '3_1',
        'name': 'Spring Rolls',
        'description': 'Crispy vegetable rolls with sweet and sour sauce',
        'price': 6.99,
        'category': 'starters',
        'dietaryType': 'veg',
        'restaurantId': '3',
        'isAvailable': true,
        'preparationTimeMinutes': 12,
      },
      // Mains
      {
        'id': '3_2',
        'name': 'Sweet and Sour Pork',
        'description': 'Tender pork with bell peppers in tangy sauce',
        'price': 16.99,
        'category': 'mains',
        'dietaryType': 'non_veg',
        'restaurantId': '3',
        'isAvailable': true,
        'preparationTimeMinutes': 20,
        'spiceLevel': 1,
      },
      {
        'id': '3_3',
        'name': 'Kung Pao Chicken',
        'description': 'Spicy chicken with peanuts and vegetables',
        'price': 15.99,
        'category': 'mains',
        'dietaryType': 'non_veg',
        'restaurantId': '3',
        'isAvailable': true,
        'preparationTimeMinutes': 18,
        'spiceLevel': 4,
      },
    ],
    '4': [
      // Mains
      {
        'id': '4_1',
        'name': 'Classic Burger',
        'description': 'Beef patty with lettuce, tomato, and special sauce',
        'price': 9.99,
        'category': 'mains',
        'dietaryType': 'non_veg',
        'restaurantId': '4',
        'isAvailable': true,
        'preparationTimeMinutes': 12,
      },
      {
        'id': '4_2',
        'name': 'Veggie Burger',
        'description': 'Plant-based patty with fresh vegetables',
        'price': 8.99,
        'category': 'mains',
        'dietaryType': 'veg',
        'restaurantId': '4',
        'isAvailable': true,
        'preparationTimeMinutes': 10,
      },
    ],
  };

  @override
  Future<List<Restaurant>> getRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simulate potential network failure (5% chance)
    if (Random().nextInt(100) < 5) {
      throw Exception('Network error: Unable to fetch restaurants');
    }
    
    return _mockRestaurants
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<Restaurant?> getRestaurantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final restaurantData = _mockRestaurants
        .where((restaurant) => restaurant['id'] == id)
        .firstOrNull;
    
    if (restaurantData == null) return null;
    
    return Restaurant.fromJson(restaurantData);
  }

  @override
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Simulate potential network failure (3% chance)
    if (Random().nextInt(100) < 3) {
      throw Exception('Network error: Unable to fetch menu items');
    }
    
    final menuItems = _mockMenuItems[restaurantId] ?? [];
    return menuItems.map((json) => MenuItem.fromJson(json)).toList();
  }

  @override
  Future<bool> isRestaurantOpen(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final restaurant = await getRestaurantById(restaurantId);
    return restaurant?.isOpen ?? false;
  }
}