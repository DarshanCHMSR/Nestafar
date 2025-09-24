import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_item.dart';

part 'order.g.dart';

/// Enum representing order status
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('preparing')
  preparing,
  @JsonValue('out_for_delivery')
  outForDelivery,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
}

/// DeliveryDetails model for order delivery information
@JsonSerializable()
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
  factory DeliveryDetails.fromJson(Map<String, dynamic> json) => 
      _$DeliveryDetailsFromJson(json);

  /// Converts DeliveryDetails to JSON
  Map<String, dynamic> toJson() => _$DeliveryDetailsToJson(this);

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
@JsonSerializable()
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
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Converts Order to JSON
  Map<String, dynamic> toJson() => _$OrderToJson(this);

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