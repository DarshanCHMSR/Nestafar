import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../utils/constants.dart';
import '../../utils/format_utils.dart';

/// Custom card widget for displaying restaurant information
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
              ),
              child: restaurant.imageUrl.isNotEmpty
                  ? Image.network(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _PlaceholderImage();
                      },
                    )
                  : _PlaceholderImage(),
            ),
            
            // Restaurant details
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!restaurant.isOpen) ...[
                        const SizedBox(width: AppConstants.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingS,
                            vertical: AppConstants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          ),
                          child: Text(
                            'CLOSED',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXS),
                  
                  Text(
                    restaurant.cuisine,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingS),
                  
                  Row(
                    children: [
                      // Rating
                      Icon(
                        Icons.star,
                        size: AppConstants.iconS,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: AppConstants.spacingXS),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(width: AppConstants.spacingM),
                      
                      // Delivery time
                      Icon(
                        Icons.access_time,
                        size: AppConstants.iconS,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppConstants.spacingXS),
                      Text(
                        FormatUtils.formatDeliveryTime(restaurant.deliveryTimeMinutes),
                        style: theme.textTheme.bodySmall,
                      ),
                      
                      const Spacer(),
                      
                      // Delivery fee
                      Text(
                        'Delivery ${FormatUtils.formatPrice(restaurant.deliveryFee)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder image widget
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
      ),
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: AppConstants.iconXL,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}