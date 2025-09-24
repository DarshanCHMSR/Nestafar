import '../models/models.dart';

/// Repository interface for order-related operations
/// Follows Interface Segregation Principle by being focused on orders only
abstract class IOrderRepository {
  /// Places a new order
  Future<Order> placeOrder({
    required String restaurantId,
    required List<CartItem> items,
    required DeliveryDetails deliveryDetails,
  });
  
  /// Fetches order by ID
  Future<Order?> getOrderById(String orderId);
  
  /// Updates order status
  Future<Order> updateOrderStatus(String orderId, OrderStatus status);
  
  /// Calculates order totals including tax and delivery fee
  Future<OrderTotals> calculateOrderTotals({
    required List<CartItem> items,
    required double deliveryFee,
  });
}

/// Helper class for order calculations
class OrderTotals {
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;

  const OrderTotals({
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });
}