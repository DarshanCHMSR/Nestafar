import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'menu_event.dart';
import 'menu_state.dart';

/// BLoC for managing menu state
/// Follows Single Responsibility Principle - only handles menu operations
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IRestaurantRepository _restaurantRepository;

  MenuBloc({
    required IRestaurantRepository restaurantRepository,
  })  : _restaurantRepository = restaurantRepository,
        super(const MenuInitial()) {
    on<FetchMenuItems>(_onFetchMenuItems);
    on<RefreshMenuItems>(_onRefreshMenuItems);
    on<ClearMenu>(_onClearMenu);
  }

  /// Handles fetching menu items
  Future<void> _onFetchMenuItems(
    FetchMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoading());
    
    try {
      final menuItems = await _restaurantRepository.getMenuItems(event.restaurantId);
      
      if (menuItems.isEmpty) {
        emit(MenuEmpty(event.restaurantId));
      } else {
        emit(MenuLoaded(
          menuItems: menuItems,
          restaurantId: event.restaurantId,
        ));
      }
    } catch (error) {
      emit(MenuError(
        message: error.toString(),
        restaurantId: event.restaurantId,
      ));
    }
  }

  /// Handles refreshing menu items
  Future<void> _onRefreshMenuItems(
    RefreshMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    try {
      final menuItems = await _restaurantRepository.getMenuItems(event.restaurantId);
      
      if (menuItems.isEmpty) {
        emit(MenuEmpty(event.restaurantId));
      } else {
        emit(MenuLoaded(
          menuItems: menuItems,
          restaurantId: event.restaurantId,
        ));
      }
    } catch (error) {
      emit(MenuError(
        message: error.toString(),
        restaurantId: event.restaurantId,
      ));
    }
  }

  /// Handles clearing menu items
  void _onClearMenu(
    ClearMenu event,
    Emitter<MenuState> emit,
  ) {
    emit(const MenuInitial());
  }
}