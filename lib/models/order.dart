import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// Enum representing order status
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

/// DeliveryDetails model for order delivery information
class DeliveryDetails extends Equatable {
  /// Customer name
  final String customerName;
  
  /// Phone number
  final String phoneNumber;
  
  /// Delivery address
  final String address;
  
  /// Landmark for easier location
  final String? landmark;
  
  /// Special delivery instructions
  final String? deliveryInstructions;

  const DeliveryDetails({
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    this.landmark,
    this.deliveryInstructions,
  });

  /// Creates DeliveryDetails from JSON
  factory DeliveryDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryDetails(
      customerName: json['customerName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      landmark: json['landmark'] as String?,
      deliveryInstructions: json['deliveryInstructions'] as String?,
    );
  }

  /// Converts DeliveryDetails to JSON
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'landmark': landmark,
      'deliveryInstructions': deliveryInstructions,
    };
  }

  @override
  List<Object?> get props => [
        customerName,
        phoneNumber,
        address,
        landmark,
        deliveryInstructions,
      ];
}

/// Order model representing a complete food order
class Order extends Equatable {
  /// Unique identifier for the order
  final String id;
  
  /// Restaurant ID
  final String restaurantId;
  
  /// List of items in the order
  final List<CartItem> items;
  
  /// Delivery details
  final DeliveryDetails deliveryDetails;
  
  /// Subtotal (sum of all item prices)
  final double subtotal;
  
  /// Tax amount
  final double tax;
  
  /// Delivery fee
  final double deliveryFee;
  
  /// Total amount (subtotal + tax + deliveryFee)
  final double total;
  
  /// Order status
  final OrderStatus status;
  
  /// Order creation timestamp
  final DateTime createdAt;
  
  /// Expected delivery time
  final DateTime expectedDeliveryTime;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.deliveryDetails,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.expectedDeliveryTime,
  });

  /// Creates an Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      deliveryDetails: DeliveryDetails.fromJson(
          json['deliveryDetails'] as Map<String, dynamic>),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: _statusFromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expectedDeliveryTime: DateTime.parse(json['expectedDeliveryTime'] as String),
    );
  }

  /// Converts Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryDetails': deliveryDetails.toJson(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'expectedDeliveryTime': expectedDeliveryTime.toIso8601String(),
    };
  }

  /// Helper method to convert string to OrderStatus
  static OrderStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        items,
        deliveryDetails,
        subtotal,
        tax,
        deliveryFee,
        total,
        status,
        createdAt,
        expectedDeliveryTime,
      ];
}