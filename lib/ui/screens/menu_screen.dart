import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/error_widget.dart';

import '../widgets/cart_floating_button.dart';
import 'cart_screen.dart';

/// Screen displaying restaurant menu items
class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;

  const MenuScreen({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch menu items when screen loads
    context.read<MenuBloc>().add(FetchMenuItems(widget.restaurant.id));
    // Calculate cart totals with restaurant's delivery fee
    context.read<CartBloc>().add(CalculateCartTotals(widget.restaurant.deliveryFee));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartUpdated && state.isNotEmpty) {
                return IconButton(
                  icon: Badge(
                    label: Text(state.itemCount.toString()),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  onPressed: () => _navigateToCart(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Restaurant header
          _RestaurantHeader(restaurant: widget.restaurant),
          
          // Menu content
          Expanded(
            child: BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading) {
                  return const _LoadingView();
                } else if (state is MenuLoaded) {
                  return _MenuListView(
                    menuItems: state.groupedMenuItems,
                    restaurant: widget.restaurant,
                  );
                } else if (state is MenuEmpty) {
                  return const _EmptyView();
                } else if (state is MenuError) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<MenuBloc>().add(FetchMenuItems(widget.restaurant.id));
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated && state.isNotEmpty) {
            return CartFloatingButton(
              cartState: state,
              onPressed: () => _navigateToCart(context),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }
}

/// Restaurant header with basic info
class _RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantHeader({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXS),
                    Text(
                      restaurant.cuisine,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!restaurant.isOpen)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingM,
                    vertical: AppConstants.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Text(
                    'CLOSED',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          Row(
            children: [
              _InfoChip(
                icon: Icons.star,
                label: restaurant.rating.toStringAsFixed(1),
                color: Colors.amber,
              ),
              const SizedBox(width: AppConstants.spacingS),
              _InfoChip(
                icon: Icons.access_time,
                label: FormatUtils.formatDeliveryTime(restaurant.deliveryTimeMinutes),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.spacingS),
              _InfoChip(
                icon: Icons.delivery_dining,
                label: FormatUtils.formatPrice(restaurant.deliveryFee),
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small info chip widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppConstants.iconS,
            color: color,
          ),
          const SizedBox(width: AppConstants.spacingXS),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      itemCount: 8,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppConstants.spacingM),
          child: MenuItemShimmer(),
        );
      },
    );
  }
}

/// Menu list view grouped by categories
class _MenuListView extends StatelessWidget {
  final Map<MenuCategory, List<MenuItem>> menuItems;
  final Restaurant restaurant;

  const _MenuListView({
    required this.menuItems,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final categories = menuItems.keys.toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = menuItems[category]!;
        
        return _CategorySection(
          category: category,
          items: items,
          restaurant: restaurant,
        );
      },
    );
  }
}

/// Category section with header and items
class _CategorySection extends StatelessWidget {
  final MenuCategory category;
  final List<MenuItem> items;
  final Restaurant restaurant;

  const _CategorySection({
    required this.category,
    required this.items,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
          child: Row(
            children: [
              Text(
                MenuCategoryConfig.icons[category.name] ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                MenuCategoryConfig.labels[category.name] ?? category.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
        
        // Category items
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
          child: MenuItemCard(
            menuItem: item,
            restaurant: restaurant,
          ),
        )).toList(),
      ],
    );
  }
}

/// Empty state view
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: 'No Menu Items',
      message: 'This restaurant doesn\'t have any menu items available right now.',
      icon: Icons.restaurant_menu,
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

/// Menu item shimmer for loading state
class MenuItemShimmer extends StatefulWidget {
  const MenuItemShimmer({Key? key}) : super(key: key);

  @override
  State<MenuItemShimmer> createState() => _MenuItemShimmerState();
}

class _MenuItemShimmerState extends State<MenuItemShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(
                            width: 160,
                            height: 18,
                            animation: _animation,
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          _ShimmerBox(
                            width: double.infinity,
                            height: 14,
                            animation: _animation,
                          ),
                          const SizedBox(height: AppConstants.spacingXS),
                          _ShimmerBox(
                            width: 200,
                            height: 14,
                            animation: _animation,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    _ShimmerBox(
                      width: 80,
                      height: 80,
                      animation: _animation,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                Row(
                  children: [
                    _ShimmerBox(
                      width: 60,
                      height: 16,
                      animation: _animation,
                    ),
                    const Spacer(),
                    _ShimmerBox(
                      width: 80,
                      height: 32,
                      animation: _animation,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Individual shimmer box component
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final Animation<double> animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            theme.colorScheme.surfaceContainerHighest,
          ],
          stops: [
            animation.value - 0.3,
            animation.value,
            animation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
        ),
      ),
    );
  }
}