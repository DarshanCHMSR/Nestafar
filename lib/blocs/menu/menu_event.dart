import 'package:equatable/equatable.dart';

/// Events for MenuBloc
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch menu items for a restaurant
class FetchMenuItems extends MenuEvent {
  final String restaurantId;

  const FetchMenuItems(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

/// Event to refresh menu items
class RefreshMenuItems extends MenuEvent {
  final String restaurantId;

  const RefreshMenuItems(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

/// Event to clear menu items (when navigating away)
class ClearMenu extends MenuEvent {
  const ClearMenu();
}