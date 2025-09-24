import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// States for MenuBloc
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

/// Initial state
class MenuInitial extends MenuState {
  const MenuInitial();
}

/// Loading menu items
class MenuLoading extends MenuState {
  const MenuLoading();
}

/// Successfully loaded menu items
class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final String restaurantId;

  const MenuLoaded({
    required this.menuItems,
    required this.restaurantId,
  });

  /// Groups menu items by category
  Map<MenuCategory, List<MenuItem>> get groupedMenuItems {
    final Map<MenuCategory, List<MenuItem>> grouped = {};
    
    for (final item in menuItems) {
      if (grouped.containsKey(item.category)) {
        grouped[item.category]!.add(item);
      } else {
        grouped[item.category] = [item];
      }
    }
    
    return grouped;
  }

  @override
  List<Object> get props => [menuItems, restaurantId];
}

/// No menu items found
class MenuEmpty extends MenuState {
  final String restaurantId;

  const MenuEmpty(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

/// Error occurred while loading menu
class MenuError extends MenuState {
  final String message;
  final String restaurantId;

  const MenuError({
    required this.message,
    required this.restaurantId,
  });

  @override
  List<Object> get props => [message, restaurantId];
}