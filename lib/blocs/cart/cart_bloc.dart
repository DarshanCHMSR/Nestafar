import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC for managing cart state
/// Follows Single Responsibility Principle - only handles cart operations
class CartBloc extends Bloc<CartEvent, CartState> {
  final IOrderRepository _orderRepository;
  List<CartItem> _cartItems = [];
  String? _currentRestaurantId;

  CartBloc({
    required IOrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(const CartInitial()) {
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ClearCart>(_onClearCart);
    on<CalculateCartTotals>(_onCalculateCartTotals);
  }

  /// Handles adding item to cart
  void _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) {
    try {
      // Check if adding from different restaurant
      if (_currentRestaurantId != null && 
          _currentRestaurantId != event.menuItem.restaurantId) {
        emit(const CartError(
          'You can only order from one restaurant at a time. Please clear your cart to add items from a different restaurant.',
        ));
        return;
      }

      _currentRestaurantId = event.menuItem.restaurantId;

      // Check if item already exists in cart
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.menuItem.id == event.menuItem.id,
      );

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = _cartItems[existingItemIndex];
        final newQuantity = existingItem.quantity + event.quantity;
        
        _cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: newQuantity,
        );
      } else {
        // Add new item to cart
        _cartItems.add(CartItem(
          menuItem: event.menuItem,
          quantity: event.quantity,
          specialInstructions: event.specialInstructions,
        ));
      }

      emit(CartUpdated(
        items: List.from(_cartItems),
        restaurantId: _currentRestaurantId,
      ));
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  /// Handles removing item from cart
  void _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) {
    try {
      _cartItems.removeWhere((item) => item.menuItem.id == event.menuItemId);
      
      // Clear restaurant ID if cart is empty
      if (_cartItems.isEmpty) {
        _currentRestaurantId = null;
      }

      emit(CartUpdated(
        items: List.from(_cartItems),
        restaurantId: _currentRestaurantId,
      ));
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  /// Handles updating item quantity
  void _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) {
    try {
      if (event.quantity <= 0) {
        // Remove item if quantity is 0 or less
        add(RemoveItemFromCart(event.menuItemId));
        return;
      }

      final itemIndex = _cartItems.indexWhere(
        (item) => item.menuItem.id == event.menuItemId,
      );

      if (itemIndex != -1) {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
          quantity: event.quantity,
        );

        emit(CartUpdated(
          items: List.from(_cartItems),
          restaurantId: _currentRestaurantId,
        ));
      }
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  /// Handles clearing entire cart
  void _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) {
    _cartItems.clear();
    _currentRestaurantId = null;
    emit(const CartInitial());
  }

  /// Handles calculating cart totals
  Future<void> _onCalculateCartTotals(
    CalculateCartTotals event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (_cartItems.isEmpty) {
        emit(const CartInitial());
        return;
      }

      final totals = await _orderRepository.calculateOrderTotals(
        items: _cartItems,
        deliveryFee: event.deliveryFee,
      );

      emit(CartUpdated(
        items: List.from(_cartItems),
        totals: totals,
        restaurantId: _currentRestaurantId,
      ));
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }
}