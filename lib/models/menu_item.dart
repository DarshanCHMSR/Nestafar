import 'package:equatable/equatable.dart';

/// Enum representing dietary preferences
enum DietaryType {
  vegetarian,
  nonVegetarian,
  vegan,
}

/// Enum representing menu item categories
enum MenuCategory {
  starters,
  mains,
  desserts,
  drinks,
  sides,
}

/// MenuItem model representing a food item in a restaurant's menu
class MenuItem extends Equatable {
  /// Unique identifier for the menu item
  final String id;
  
  /// Name of the menu item
  final String name;
  
  /// Description of the menu item
  final String description;
  
  /// Price in currency units
  final double price;
  
  /// Menu category this item belongs to
  final MenuCategory category;
  
  /// Dietary type of the item
  final DietaryType dietaryType;
  
  /// URL to item's image
  final String? imageUrl;
  
  /// Whether the item is currently available
  final bool isAvailable;
  
  /// Restaurant ID this item belongs to
  final String restaurantId;
  
  /// Preparation time in minutes
  final int preparationTimeMinutes;
  
  /// Spice level (1-5, where 1 is mild and 5 is very spicy)
  final int? spiceLevel;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.dietaryType,
    required this.restaurantId,
    this.imageUrl,
    this.isAvailable = true,
    this.preparationTimeMinutes = 15,
    this.spiceLevel,
  });

  /// Creates a MenuItem from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: _categoryFromString(json['category'] as String),
      dietaryType: _dietaryTypeFromString(json['dietaryType'] as String),
      restaurantId: json['restaurantId'] as String,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      preparationTimeMinutes: json['preparationTimeMinutes'] as int? ?? 15,
      spiceLevel: json['spiceLevel'] as int?,
    );
  }

  /// Converts MenuItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.name,
      'dietaryType': dietaryType.name,
      'restaurantId': restaurantId,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'preparationTimeMinutes': preparationTimeMinutes,
      'spiceLevel': spiceLevel,
    };
  }

  /// Helper method to convert string to MenuCategory
  static MenuCategory _categoryFromString(String category) {
    switch (category) {
      case 'starters':
        return MenuCategory.starters;
      case 'mains':
        return MenuCategory.mains;
      case 'desserts':
        return MenuCategory.desserts;
      case 'drinks':
        return MenuCategory.drinks;
      case 'sides':
        return MenuCategory.sides;
      default:
        return MenuCategory.mains;
    }
  }

  /// Helper method to convert string to DietaryType
  static DietaryType _dietaryTypeFromString(String dietaryType) {
    switch (dietaryType) {
      case 'veg':
        return DietaryType.vegetarian;
      case 'non_veg':
        return DietaryType.nonVegetarian;
      case 'vegan':
        return DietaryType.vegan;
      default:
        return DietaryType.vegetarian;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        dietaryType,
        imageUrl,
        isAvailable,
        restaurantId,
        preparationTimeMinutes,
        spiceLevel,
      ];
}