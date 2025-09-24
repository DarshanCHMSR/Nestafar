import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_shimmer.dart';
import 'menu_screen.dart';

/// Screen displaying list of available restaurants
class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch restaurants when screen loads
    context.read<RestaurantsBloc>().add(const FetchRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nestafar'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RestaurantsBloc>().add(const RefreshRestaurants());
        },
        child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
          builder: (context, state) {
            if (state is RestaurantsLoading) {
              return const _LoadingView();
            } else if (state is RestaurantsLoaded) {
              return _RestaurantsListView(restaurants: state.restaurants);
            } else if (state is RestaurantsEmpty) {
              return const _EmptyView();
            } else if (state is RestaurantsError) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<RestaurantsBloc>().add(const FetchRestaurants());
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// Loading view with shimmer effect
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppConstants.spacingM),
          child: RestaurantCardShimmer(),
        );
      },
    );
  }
}

/// List view of restaurants
class _RestaurantsListView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const _RestaurantsListView({required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
          child: RestaurantCard(
            restaurant: restaurant,
            onTap: () => _navigateToMenu(context, restaurant),
          ),
        );
      },
    );
  }

  void _navigateToMenu(BuildContext context, Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuScreen(restaurant: restaurant),
      ),
    );
  }
}

/// Empty state view
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: AppConstants.spacingM),
          Text(
            'No restaurants found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: AppConstants.spacingS),
          Text(
            'Please check back later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view with retry option
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: message,
      onRetry: onRetry,
    );
  }
}