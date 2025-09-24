import 'package:equatable/equatable.dart';

/// Events for RestaurantsBloc
abstract class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch all restaurants
class FetchRestaurants extends RestaurantsEvent {
  const FetchRestaurants();
}

/// Event to refresh restaurants list
class RefreshRestaurants extends RestaurantsEvent {
  const RefreshRestaurants();
}