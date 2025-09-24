import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Events for OrderBloc
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

/// Event to submit an order
class SubmitOrder extends OrderEvent {
  final String restaurantId;
  final List<CartItem> items;
  final DeliveryDetails deliveryDetails;

  const SubmitOrder({
    required this.restaurantId,
    required this.items,
    required this.deliveryDetails,
  });

  @override
  List<Object> get props => [restaurantId, items, deliveryDetails];
}

/// Event to retry submitting order
class RetrySubmitOrder extends OrderEvent {
  final String restaurantId;
  final List<CartItem> items;
  final DeliveryDetails deliveryDetails;

  const RetrySubmitOrder({
    required this.restaurantId,
    required this.items,
    required this.deliveryDetails,
  });

  @override
  List<Object> get props => [restaurantId, items, deliveryDetails];
}

/// Event to reset order state
class ResetOrder extends OrderEvent {
  const ResetOrder();
}