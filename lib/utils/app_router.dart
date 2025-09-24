import 'package:flutter/material.dart';
import '../models/models.dart';
import '../ui/screens/screens.dart';

class AppRoutes {
  static const String restaurants = '/';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.restaurants:
        return MaterialPageRoute(
          builder: (_) => const RestaurantsScreen(),
          settings: settings,
        );
        
      case AppRoutes.menu:
        final restaurant = settings.arguments as Restaurant?;
        if (restaurant == null) {
          return _errorRoute();
        }
        return MaterialPageRoute(
          builder: (_) => MenuScreen(restaurant: restaurant),
          settings: settings,
        );
        
      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
        
      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
          settings: settings,
        );
        
      case AppRoutes.orderConfirmation:
        final order = settings.arguments as Order?;
        if (order == null) {
          return _errorRoute();
        }
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(order: order),
          settings: settings,
        );
        
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Route not found!'),
        ),
      ),
    );
  }
}