import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';

/// Card widget for displaying menu items
class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final Restaurant restaurant;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and dietary indicator
                      Row(
                        children: [
                          Text(
                            DietaryTypeConfig.icons[menuItem.dietaryType.name] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: AppConstants.spacingXS),
                          Expanded(
                            child: Text(
                              menuItem.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.spacingS),
                      
                      // Description
                      Text(
                        menuItem.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: AppConstants.spacingS),
                      
                      // Price and spice level
                      Row(
                        children: [
                          Text(
                            FormatUtils.formatPrice(menuItem.price),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (menuItem.spiceLevel != null) ...[
                            const SizedBox(width: AppConstants.spacingM),
                            _SpiceLevelIndicator(level: menuItem.spiceLevel!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacingM),
                
                // Item image and add button
                Column(
                  children: [
                    // Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        color: theme.colorScheme.surfaceVariant,
                      ),
                      child: menuItem.imageUrl != null && menuItem.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              child: Image.network(
                                menuItem.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _PlaceholderImage();
                                },
                              ),
                            )
                          : _PlaceholderImage(),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingS),
                    
                    // Add to cart section
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int currentQuantity = 0;
                        
                        if (state is CartUpdated) {
                          final cartItem = state.items
                              .where((item) => item.menuItem.id == menuItem.id)
                              .firstOrNull;
                          currentQuantity = cartItem?.quantity ?? 0;
                        }
                        
                        if (currentQuantity == 0) {
                          return _AddButton(
                            onPressed: menuItem.isAvailable && restaurant.isOpen
                                ? () => _addToCart(context)
                                : null,
                          );
                        } else {
                          return _QuantityControls(
                            quantity: currentQuantity,
                            onIncrement: () => _incrementQuantity(context, currentQuantity),
                            onDecrement: () => _decrementQuantity(context, currentQuantity),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            
            // Availability status
            if (!menuItem.isAvailable || !restaurant.isOpen) ...[
              const SizedBox(height: AppConstants.spacingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingS,
                  vertical: AppConstants.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  !restaurant.isOpen ? 'Restaurant Closed' : 'Currently Unavailable',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(AddItemToCart(menuItem: menuItem));
    _showAddedToCartSnackBar(context);
  }

  void _incrementQuantity(BuildContext context, int currentQuantity) {
    if (currentQuantity < AppConstants.maxQuantityPerItem) {
      context.read<CartBloc>().add(
        UpdateItemQuantity(
          menuItemId: menuItem.id,
          quantity: currentQuantity + 1,
        ),
      );
    }
  }

  void _decrementQuantity(BuildContext context, int currentQuantity) {
    context.read<CartBloc>().add(
      UpdateItemQuantity(
        menuItemId: menuItem.id,
        quantity: currentQuantity - 1,
      ),
    );
  }

  void _showAddedToCartSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuItem.name} added to cart'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Placeholder image for menu items
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Center(
        child: Icon(
          Icons.fastfood,
          size: AppConstants.iconL,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Spice level indicator
class _SpiceLevelIndicator extends StatelessWidget {
  final int level;

  const _SpiceLevelIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.whatshot,
          size: AppConstants.iconS,
          color: _getSpiceColor(level),
        ),
        const SizedBox(width: AppConstants.spacingXS),
        Text(
          'Spice $level',
          style: theme.textTheme.labelSmall?.copyWith(
            color: _getSpiceColor(level),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getSpiceColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.deepOrange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.red.shade800;
      default:
        return Colors.grey;
    }
  }
}

/// Add to cart button
class _AddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AddButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 32,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
        ),
        child: const Text(
          'ADD',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Quantity controls with increment/decrement buttons
class _QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControls({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 80,
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        children: [
          // Decrement button
          Expanded(
            child: InkWell(
              onTap: onDecrement,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusS),
                bottomLeft: Radius.circular(AppConstants.radiusS),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: AppConstants.iconS,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          
          // Quantity
          Container(
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Increment button
          Expanded(
            child: InkWell(
              onTap: onIncrement,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppConstants.radiusS),
                bottomRight: Radius.circular(AppConstants.radiusS),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: AppConstants.iconS,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}