import 'package:equatable/equatable.dart';

/// Restaurant model representing a food establishment
class Restaurant extends Equatable {
  /// Unique identifier for the restaurant
  final String id;
  
  /// Name of the restaurant
  final String name;
  
  /// Cuisine type (e.g., "Italian", "Indian", "Chinese")
  final String cuisine;
  
  /// Restaurant rating (0.0 to 5.0)
  final double rating;
  
  /// Estimated delivery time in minutes
  final int deliveryTimeMinutes;
  
  /// URL to restaurant's thumbnail image
  final String imageUrl;
  
  /// Brief description of the restaurant
  final String description;
  
  /// Delivery fee in currency units
  final double deliveryFee;
  
  /// Minimum order amount
  final double minimumOrder;
  
  /// Whether the restaurant is currently open
  final bool isOpen;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.imageUrl,
    required this.description,
    required this.deliveryFee,
    required this.minimumOrder,
    this.isOpen = true,
  });

  /// Creates a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      rating: (json['rating'] as num).toDouble(),
      deliveryTimeMinutes: json['deliveryTimeMinutes'] as int,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      minimumOrder: (json['minimumOrder'] as num).toDouble(),
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }

  /// Converts Restaurant to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'rating': rating,
      'deliveryTimeMinutes': deliveryTimeMinutes,
      'imageUrl': imageUrl,
      'description': description,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'isOpen': isOpen,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        cuisine,
        rating,
        deliveryTimeMinutes,
        imageUrl,
        description,
        deliveryFee,
        minimumOrder,
        isOpen,
      ];
}