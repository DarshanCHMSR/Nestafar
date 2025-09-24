import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'order_event.dart';
import 'order_state.dart';

/// BLoC for managing order state
/// Follows Single Responsibility Principle - only handles order operations
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository _orderRepository;

  OrderBloc({
    required IOrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(const OrderInitial()) {
    on<SubmitOrder>(_onSubmitOrder);
    on<RetrySubmitOrder>(_onRetrySubmitOrder);
    on<ResetOrder>(_onResetOrder);
  }

  /// Handles submitting order
  Future<void> _onSubmitOrder(
    SubmitOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderSubmitting());
    
    try {
      final order = await _orderRepository.placeOrder(
        restaurantId: event.restaurantId,
        items: event.items,
        deliveryDetails: event.deliveryDetails,
      );
      
      emit(OrderSuccess(order));
    } catch (error) {
      emit(OrderFailure(
        message: error.toString(),
        restaurantId: event.restaurantId,
        items: event.items,
        deliveryDetails: event.deliveryDetails,
      ));
    }
  }

  /// Handles retrying order submission
  Future<void> _onRetrySubmitOrder(
    RetrySubmitOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderSubmitting());
    
    try {
      final order = await _orderRepository.placeOrder(
        restaurantId: event.restaurantId,
        items: event.items,
        deliveryDetails: event.deliveryDetails,
      );
      
      emit(OrderSuccess(order));
    } catch (error) {
      emit(OrderFailure(
        message: error.toString(),
        restaurantId: event.restaurantId,
        items: event.items,
        deliveryDetails: event.deliveryDetails,
      ));
    }
  }

  /// Handles resetting order state
  void _onResetOrder(
    ResetOrder event,
    Emitter<OrderState> emit,
  ) {
    emit(const OrderInitial());
  }
}