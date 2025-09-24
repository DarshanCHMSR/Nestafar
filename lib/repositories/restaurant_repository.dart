import '../models/models.dart';

/// Repository interface for restaurant-related operations
/// Follows Interface Segregation Principle by being focused on restaurants only
abstract class IRestaurantRepository {
  /// Fetches all available restaurants
  Future<List<Restaurant>> getRestaurants();
  
  /// Fetches a specific restaurant by ID
  Future<Restaurant?> getRestaurantById(String id);
  
  /// Fetches menu items for a specific restaurant
  Future<List<MenuItem>> getMenuItems(String restaurantId);
  
  /// Checks if a restaurant is currently open
  Future<bool> isRestaurantOpen(String restaurantId);
}