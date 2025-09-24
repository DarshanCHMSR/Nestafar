import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Events for CartBloc
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Event to add an item to cart
class AddItemToCart extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;

  const AddItemToCart({
    required this.menuItem,
    this.quantity = 1,
    this.specialInstructions,
  });

  @override
  List<Object> get props => [menuItem, quantity, specialInstructions ?? ''];
}

/// Event to remove an item from cart
class RemoveItemFromCart extends CartEvent {
  final String menuItemId;

  const RemoveItemFromCart(this.menuItemId);

  @override
  List<Object> get props => [menuItemId];
}

/// Event to update item quantity in cart
class UpdateItemQuantity extends CartEvent {
  final String menuItemId;
  final int quantity;

  const UpdateItemQuantity({
    required this.menuItemId,
    required this.quantity,
  });

  @override
  List<Object> get props => [menuItemId, quantity];
}

/// Event to clear entire cart
class ClearCart extends CartEvent {
  const ClearCart();
}

/// Event to calculate cart totals
class CalculateCartTotals extends CartEvent {
  final double deliveryFee;

  const CalculateCartTotals(this.deliveryFee);

  @override
  List<Object> get props => [deliveryFee];
}