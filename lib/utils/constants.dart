/// Application constants
class AppConstants {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Image sizes
  static const double thumbnailSize = 80.0;
  static const double avatarSize = 40.0;
  
  // Min tappable area
  static const double minTappableArea = 48.0;
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Order limits
  static const int maxQuantityPerItem = 10;
  static const double minOrderValue = 5.0;
  
  // Validation limits
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  static const int maxInstructionsLength = 250;
  static const int phoneNumberLength = 10;
}

/// Route names for navigation
class AppRoutes {
  static const String restaurants = '/restaurants';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
}

/// Asset paths
class AppAssets {
  static const String restaurantPlaceholder = 'assets/images/restaurant_placeholder.png';
  static const String foodPlaceholder = 'assets/images/food_placeholder.png';
  static const String emptyCart = 'assets/images/empty_cart.png';
  static const String orderSuccess = 'assets/images/order_success.png';
}

/// Dietary type icons and colors
class DietaryTypeConfig {
  static const Map<String, String> icons = {
    'veg': '🟢',
    'non_veg': '🔴',
    'vegan': '🟢',
  };
  
  static const Map<String, String> labels = {
    'veg': 'Vegetarian',
    'non_veg': 'Non-Vegetarian',
    'vegan': 'Vegan',
  };
}

/// Menu category configurations
class MenuCategoryConfig {
  static const Map<String, String> icons = {
    'starters': '🥗',
    'mains': '🍽️',
    'desserts': '🍰',
    'drinks': '🥤',
    'sides': '🍟',
  };
  
  static const Map<String, String> labels = {
    'starters': 'Starters',
    'mains': 'Main Course',
    'desserts': 'Desserts',
    'drinks': 'Beverages',
    'sides': 'Sides',
  };
}