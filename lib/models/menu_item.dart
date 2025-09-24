import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

/// Enum representing dietary preferences
enum DietaryType {
  @JsonValue('veg')
  vegetarian,
  @JsonValue('non_veg')
  nonVegetarian,
  @JsonValue('vegan')
  vegan,
}

/// Enum representing menu item categories
enum MenuCategory {
  @JsonValue('starters')
  starters,
  @JsonValue('mains')
  mains,
  @JsonValue('desserts')
  desserts,
  @JsonValue('drinks')
  drinks,
  @JsonValue('sides')
  sides,
}

/// MenuItem model representing a food item in a restaurant's menu
@JsonSerializable()
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
  factory MenuItem.fromJson(Map<String, dynamic> json) => 
      _$MenuItemFromJson(json);

  /// Converts MenuItem to JSON
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

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