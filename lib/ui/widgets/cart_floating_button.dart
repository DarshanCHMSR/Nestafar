import 'package:flutter/material.dart';
import '../../blocs/blocs.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';

/// Floating action button showing cart summary
class CartFloatingButton extends StatelessWidget {
  final CartUpdated cartState;
  final VoidCallback onPressed;

  const CartFloatingButton({
    Key? key,
    required this.cartState,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cart icon with badge
            Badge(
              label: Text(
                cartState.itemCount.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            
            const SizedBox(width: AppConstants.spacingM),
            
            // View cart text
            const Text(
              'View Cart',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(width: AppConstants.spacingM),
            
            // Total amount
            if (cartState.totals != null)
              Text(
                FormatUtils.formatPrice(cartState.totals!.total),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                FormatUtils.formatPrice(cartState.subtotal),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}