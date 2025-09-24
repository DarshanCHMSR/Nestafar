import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// States for RestaurantsBloc
abstract class RestaurantsState extends Equatable {
  const RestaurantsState();

  @override
  List<Object> get props => [];
}

/// Initial state
class RestaurantsInitial extends RestaurantsState {
  const RestaurantsInitial();
}

/// Loading state
class RestaurantsLoading extends RestaurantsState {
  const RestaurantsLoading();
}

/// Successfully loaded restaurants
class RestaurantsLoaded extends RestaurantsState {
  final List<Restaurant> restaurants;

  const RestaurantsLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

/// No restaurants found
class RestaurantsEmpty extends RestaurantsState {
  const RestaurantsEmpty();
}

/// Error occurred while loading restaurants
class RestaurantsError extends RestaurantsState {
  final String message;

  const RestaurantsError(this.message);

  @override
  List<Object> get props => [message];
}