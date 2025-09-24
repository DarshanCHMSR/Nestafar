import 'package:get_it/get_it.dart';
import '../repositories/repositories.dart';

/// Service locator for dependency injection
/// Follows Dependency Inversion Principle by providing interfaces
final GetIt serviceLocator = GetIt.instance;

/// Sets up dependency injection
/// Call this method before running the app
void setupServiceLocator() {
  // Register repositories
  serviceLocator.registerLazySingleton<IRestaurantRepository>(
    () => RestaurantRepositoryImpl(),
  );
  
  serviceLocator.registerLazySingleton<IOrderRepository>(
    () => OrderRepositoryImpl(),
  );
}