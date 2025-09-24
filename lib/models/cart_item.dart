import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'menu_item.dart';

part 'cart_item.g.dart';

/// CartItem model representing a menu item with quantity in the cart
@JsonSerializable()
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
  factory CartItem.fromJson(Map<String, dynamic> json) => 
      _$CartItemFromJson(json);

  /// Converts CartItem to JSON
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

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