import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// States for OrderBloc
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

/// Initial order state
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// Order is being submitted
class OrderSubmitting extends OrderState {
  const OrderSubmitting();
}

/// Order submitted successfully
class OrderSuccess extends OrderState {
  final Order order;

  const OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}

/// Order submission failed
class OrderFailure extends OrderState {
  final String message;
  final String? restaurantId;
  final List<CartItem>? items;
  final DeliveryDetails? deliveryDetails;

  const OrderFailure({
    required this.message,
    this.restaurantId,
    this.items,
    this.deliveryDetails,
  });

  @override
  List<Object> get props => [
    message,
    restaurantId ?? '',
    items ?? [],
    deliveryDetails ?? const DeliveryDetails(customerName: '', phoneNumber: '', address: ''),
  ];
}