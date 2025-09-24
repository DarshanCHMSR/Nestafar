import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// CartItem model representing a menu item with quantity in the cart
class CartItem extends Equatable {
  /// The menu item
  final MenuItem menuItem;
  
  /// Quantity of this item in the cart
  final int quantity;
  
  /// Any special instructions for this item
  final String? specialInstructions;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  /// Total price for this cart item (price * quantity)
  double get totalPrice => menuItem.price * quantity;

  /// Creates a CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menuItem'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  /// Converts CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  /// Creates a copy of this cart item with updated quantity
  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity, specialInstructions];
}