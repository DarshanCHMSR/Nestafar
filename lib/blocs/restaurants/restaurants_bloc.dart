import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'restaurants_event.dart';
import 'restaurants_state.dart';

/// BLoC for managing restaurants state
/// Follows Single Responsibility Principle - only handles restaurant listing
class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final IRestaurantRepository _restaurantRepository;

  RestaurantsBloc({
    required IRestaurantRepository restaurantRepository,
  })  : _restaurantRepository = restaurantRepository,
        super(const RestaurantsInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
    on<RefreshRestaurants>(_onRefreshRestaurants);
  }

  /// Handles fetching restaurants
  Future<void> _onFetchRestaurants(
    FetchRestaurants event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(const RestaurantsLoading());
    
    try {
      final restaurants = await _restaurantRepository.getRestaurants();
      
      if (restaurants.isEmpty) {
        emit(const RestaurantsEmpty());
      } else {
        emit(RestaurantsLoaded(restaurants));
      }
    } catch (error) {
      emit(RestaurantsError(error.toString()));
    }
  }

  /// Handles refreshing restaurants
  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantsState> emit,
  ) async {
    // Don't show loading for refresh to maintain better UX
    try {
      final restaurants = await _restaurantRepository.getRestaurants();
      
      if (restaurants.isEmpty) {
        emit(const RestaurantsEmpty());
      } else {
        emit(RestaurantsLoaded(restaurants));
      }
    } catch (error) {
      emit(RestaurantsError(error.toString()));
    }
  }
}