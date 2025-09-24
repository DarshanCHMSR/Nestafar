import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'services/service_locator.dart';
import 'repositories/repositories.dart';
import 'ui/themes/app_theme.dart';
import 'utils/app_router.dart';

void main() {
  // Set up dependency injection
  setupServiceLocator();
  
  runApp(const NestafairApp());
}

/// Main application widget
class NestafairApp extends StatelessWidget {
  const NestafairApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Restaurants BLoC
        BlocProvider(
          create: (context) => RestaurantsBloc(
            restaurantRepository: serviceLocator<IRestaurantRepository>(),
          ),
        ),
        
        // Menu BLoC
        BlocProvider(
          create: (context) => MenuBloc(
            restaurantRepository: serviceLocator<IRestaurantRepository>(),
          ),
        ),
        
        // Cart BLoC
        BlocProvider(
          create: (context) => CartBloc(
            orderRepository: serviceLocator<IOrderRepository>(),
          ),
        ),
        
        // Order BLoC
        BlocProvider(
          create: (context) => OrderBloc(
            orderRepository: serviceLocator<IOrderRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Nestafar Food Ordering',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.restaurants,
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}