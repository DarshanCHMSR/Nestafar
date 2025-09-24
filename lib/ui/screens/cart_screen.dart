import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';
import '../themes/app_theme.dart';
import '../widgets/error_widget.dart';

import 'checkout_screen.dart';

/// Screen displaying cart items and totals
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceContainerLow,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shopping_cart_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Your Cart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartUpdated && state.isNotEmpty) {
                return TextButton(
                  onPressed: () => _clearCart(context),
                  child: const Text('Clear'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || (state is CartUpdated && state.isEmpty)) {
            return const _EmptyCartView();
          } else if (state is CartUpdated) {
            return _CartContentView(cartState: state);
          } else if (state is CartError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                // Refresh cart or retry last operation
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _clearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<CartBloc>().add(const ClearCart());
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

/// Empty cart view
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: 'Your cart is empty',
      message: 'Add items to your cart to get started',
      icon: Icons.shopping_cart_outlined,
    );
  }
}

/// Cart content view with items and totals
class _CartContentView extends StatelessWidget {
  final CartUpdated cartState;

  const _CartContentView({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            itemCount: cartState.items.length,
            itemBuilder: (context, index) {
              final cartItem = cartState.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
                child: _CartItemCard(cartItem: cartItem),
              );
            },
          ),
        ),
        
        // Totals and checkout section
        _CartTotalsSection(cartState: cartState),
      ],
    );
  }
}

/// Individual cart item card
class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuItem = cartItem.menuItem;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Row(
          children: [
            // Item image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: menuItem.imageUrl != null && menuItem.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      child: Image.network(
                        menuItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(theme);
                        },
                      ),
                    )
                  : _buildPlaceholder(theme),
            ),
            
            const SizedBox(width: AppConstants.spacingM),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with dietary indicator
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
                  
                  const SizedBox(height: AppConstants.spacingXS),
                  
                  // Price
                  Text(
                    FormatUtils.formatPrice(menuItem.price),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Special instructions
                  if (cartItem.specialInstructions != null && 
                      cartItem.specialInstructions!.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingXS),
                    Text(
                      'Note: ${cartItem.specialInstructions}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(width: AppConstants.spacingM),
            
            // Quantity controls and total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Quantity controls
                _QuantityControls(
                  quantity: cartItem.quantity,
                  onIncrement: () => _incrementQuantity(context, cartItem),
                  onDecrement: () => _decrementQuantity(context, cartItem),
                ),
                
                const SizedBox(height: AppConstants.spacingS),
                
                // Item total
                Text(
                  FormatUtils.formatPrice(cartItem.totalPrice),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Center(
        child: Icon(
          Icons.fastfood,
          size: AppConstants.iconM,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _incrementQuantity(BuildContext context, CartItem cartItem) {
    if (cartItem.quantity < AppConstants.maxQuantityPerItem) {
      context.read<CartBloc>().add(
        UpdateItemQuantity(
          menuItemId: cartItem.menuItem.id,
          quantity: cartItem.quantity + 1,
        ),
      );
    }
  }

  void _decrementQuantity(BuildContext context, CartItem cartItem) {
    context.read<CartBloc>().add(
      UpdateItemQuantity(
        menuItemId: cartItem.menuItem.id,
        quantity: cartItem.quantity - 1,
      ),
    );
  }
}

/// Quantity controls widget
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
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          InkWell(
            onTap: onDecrement,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusS),
              bottomLeft: Radius.circular(AppConstants.radiusS),
            ),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: AppConstants.iconS,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          
          // Quantity
          Container(
            width: 40,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: theme.colorScheme.outline),
                right: BorderSide(color: theme.colorScheme.outline),
              ),
            ),
            child: Text(
              quantity.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Increment button
          InkWell(
            onTap: onIncrement,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppConstants.radiusS),
              bottomRight: Radius.circular(AppConstants.radiusS),
            ),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: AppConstants.iconS,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cart totals section with checkout button
class _CartTotalsSection extends StatelessWidget {
  final CartUpdated cartState;

  const _CartTotalsSection({required this.cartState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totals = cartState.totals;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          if (totals != null) ...[
            // Subtotal
            _TotalRow(
              label: 'Subtotal',
              amount: totals.subtotal,
              isHighlighted: false,
            ),
            
            const SizedBox(height: AppConstants.spacingS),
            
            // Tax
            _TotalRow(
              label: 'Tax',
              amount: totals.tax,
              isHighlighted: false,
            ),
            
            const SizedBox(height: AppConstants.spacingS),
            
            // Delivery fee
            _TotalRow(
              label: 'Delivery fee',
              amount: totals.deliveryFee,
              isHighlighted: false,
            ),
            
            const SizedBox(height: AppConstants.spacingM),
            
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
            
            const SizedBox(height: AppConstants.spacingM),
            
            // Total
            _TotalRow(
              label: 'Total',
              amount: totals.total,
              isHighlighted: true,
            ),
          ] else ...[
            // Just subtotal if totals not calculated
            _TotalRow(
              label: 'Subtotal',
              amount: cartState.subtotal,
              isHighlighted: true,
            ),
          ],
          
          const SizedBox(height: AppConstants.spacingL),
          
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _navigateToCheckout(context),
              child: Text(
                'Proceed to Checkout • ${totals != null ? FormatUtils.formatPrice(totals.total) : FormatUtils.formatPrice(cartState.subtotal)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );
  }
}

/// Individual total row
class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isHighlighted;

  const _TotalRow({
    required this.label,
    required this.amount,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            fontSize: isHighlighted ? 16 : null,
          ),
        ),
        Text(
          FormatUtils.formatPrice(amount),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            fontSize: isHighlighted ? 16 : null,
            color: isHighlighted ? theme.colorScheme.primary : null,
          ),
        ),
      ],
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