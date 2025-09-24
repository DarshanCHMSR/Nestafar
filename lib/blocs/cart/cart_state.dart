import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

/// States for CartBloc
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

/// Initial cart state
class CartInitial extends CartState {
  const CartInitial();
}

/// Cart updated with items
class CartUpdated extends CartState {
  final List<CartItem> items;
  final OrderTotals? totals;
  final String? restaurantId;

  const CartUpdated({
    required this.items,
    this.totals,
    this.restaurantId,
  });

  /// Total number of items in cart
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get subtotal without tax and delivery fee
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object> get props => [items, totals ?? const OrderTotals(subtotal: 0, tax: 0, deliveryFee: 0, total: 0), restaurantId ?? ''];
}

/// Error occurred in cart operations
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}