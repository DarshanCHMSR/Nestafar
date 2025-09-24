import 'dart:math';
import '../models/models.dart';
import 'order_repository.dart';

/// Mock implementation of IOrderRepository  
/// Follows Liskov Substitution Principle - can be replaced with real implementation
class OrderRepositoryImpl implements IOrderRepository {
  // In-memory storage for demo purposes
  final Map<String, Order> _orders = {};
  
  // Tax rate (8.5%)
  static const double _taxRate = 0.085;

  @override
  Future<Order> placeOrder({
    required String restaurantId,
    required List<CartItem> items,
    required DeliveryDetails deliveryDetails,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simulate potential network failure (2% chance)
    if (Random().nextInt(100) < 2) {
      throw Exception('Network error: Unable to place order');
    }
    
    // Generate unique order ID
    final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
    
    // Calculate totals
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * _taxRate;
    
    // Get delivery fee from restaurant (mocked here)
    const deliveryFee = 2.99; // This would come from restaurant data
    
    final total = subtotal + tax + deliveryFee;
    
    // Create order
    final order = Order(
      id: orderId,
      restaurantId: restaurantId,
      items: items,
      deliveryDetails: deliveryDetails,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      expectedDeliveryTime: DateTime.now().add(const Duration(minutes: 35)),
      paymentMethod: 'Credit Card', // Default payment method
    );
    
    // Store order
    _orders[orderId] = order;
    
    return order;
  }

  @override
  Future<Order?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _orders[orderId];
  }

  @override
  Future<Order> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final order = _orders[orderId];
    if (order == null) {
      throw Exception('Order not found');
    }
    
    // In a real implementation, this would update the backend
    // For now, we'll create a new order object with updated status
    final updatedOrder = Order(
      id: order.id,
      restaurantId: order.restaurantId,
      items: order.items,
      deliveryDetails: order.deliveryDetails,
      subtotal: order.subtotal,
      tax: order.tax,
      deliveryFee: order.deliveryFee,
      total: order.total,
      status: status,
      createdAt: order.createdAt,
      expectedDeliveryTime: order.expectedDeliveryTime,
      paymentMethod: order.paymentMethod,
    );
    
    _orders[orderId] = updatedOrder;
    return updatedOrder;
  }

  @override
  Future<OrderTotals> calculateOrderTotals({
    required List<CartItem> items,
    required double deliveryFee,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * _taxRate;
    final total = subtotal + tax + deliveryFee;
    
    return OrderTotals(
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
    );
  }
}