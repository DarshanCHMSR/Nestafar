import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Modern restaurant card with Instamart-inspired design
class ModernRestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final bool showPromotions;

  const ModernRestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.showPromotions = true,
  });

  @override
  State<ModernRestaurantCard> createState() => _ModernRestaurantCardState();
}

class _ModernRestaurantCardState extends State<ModernRestaurantCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant Image with overlay
                      Stack(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.1),
                                  theme.colorScheme.secondary.withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                            child: widget.restaurant.imageUrl.isNotEmpty
                                ? Image.network(
                                    widget.restaurant.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderImage(theme);
                                    },
                                  )
                                : _buildPlaceholderImage(theme),
                          ),
                          
                          // Gradient overlay
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                          
                          // Top badges
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Row(
                              children: [
                                if (!widget.restaurant.isOpen)
                                  _buildBadge(
                                    'CLOSED',
                                    theme.colorScheme.error,
                                    Colors.white,
                                  ),
                                if (widget.restaurant.deliveryFee == 0.0)
                                  _buildBadge(
                                    'FREE DELIVERY',
                                    Colors.green,
                                    Colors.white,
                                  ),
                              ],
                            ),
                          ),
                          
                          // Favorite button
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // Add to favorites functionality
                                },
                                icon: Icon(
                                  Icons.favorite_border_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                          
                          // Quick add button (bottom right)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity()
                                ..scale(_isHovered ? 1.1 : 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: widget.onTap,
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Restaurant Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and rating
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.restaurant.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.restaurant.rating.toStringAsFixed(1),
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 6),
                            
                            // Cuisine
                            Text(
                              widget.restaurant.cuisine,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Delivery info
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.access_time_rounded,
                                  '${widget.restaurant.deliveryTimeMinutes} min',
                                  theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                _buildInfoChip(
                                  Icons.delivery_dining_rounded,
                                  widget.restaurant.deliveryFee == 0.0
                                      ? 'Free'
                                      : '\$${widget.restaurant.deliveryFee.toStringAsFixed(2)}',
                                  widget.restaurant.deliveryFee == 0.0
                                      ? Colors.green
                                      : theme.colorScheme.secondary,
                                ),
                                const Spacer(),
                                if (widget.restaurant.isOpen)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'OPEN',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            // Promotions
                            if (widget.showPromotions) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withValues(alpha: 0.1),
                                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '20% off on orders above \$25',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.2),
            theme.colorScheme.secondary.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_rounded,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              widget.restaurant.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color backgroundColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Skeleton loading for restaurant cards
class RestaurantCardSkeleton extends StatefulWidget {
  const RestaurantCardSkeleton({super.key});

  @override
  State<RestaurantCardSkeleton> createState() => _RestaurantCardSkeletonState();
}

class _RestaurantCardSkeletonState extends State<RestaurantCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        theme.colorScheme.surfaceContainerHighest,
                        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        theme.colorScheme.surfaceContainerHighest,
                      ],
                      stops: [
                        (_animation.value - 0.3).clamp(0.0, 1.0),
                        _animation.value,
                        (_animation.value + 0.3).clamp(0.0, 1.0),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Content skeleton
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Container(
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    theme.colorScheme.surfaceContainerHighest,
                                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                    theme.colorScheme.surfaceContainerHighest,
                                  ],
                                  stops: [
                                    (_animation.value - 0.3).clamp(0.0, 1.0),
                                    _animation.value,
                                    (_animation.value + 0.3).clamp(0.0, 1.0),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 50,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  theme.colorScheme.surfaceContainerHighest,
                                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  theme.colorScheme.surfaceContainerHighest,
                                ],
                                stops: [
                                  (_animation.value - 0.3).clamp(0.0, 1.0),
                                  _animation.value,
                                  (_animation.value + 0.3).clamp(0.0, 1.0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Cuisine
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              theme.colorScheme.surfaceContainerHighest,
                              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              theme.colorScheme.surfaceContainerHighest,
                            ],
                            stops: [
                              (_animation.value - 0.3).clamp(0.0, 1.0),
                              _animation.value,
                              (_animation.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Info chips
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  theme.colorScheme.surfaceContainerHighest,
                                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  theme.colorScheme.surfaceContainerHighest,
                                ],
                                stops: [
                                  (_animation.value - 0.3).clamp(0.0, 1.0),
                                  _animation.value,
                                  (_animation.value + 0.3).clamp(0.0, 1.0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 40,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  theme.colorScheme.surfaceContainerHighest,
                                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  theme.colorScheme.surfaceContainerHighest,
                                ],
                                stops: [
                                  (_animation.value - 0.3).clamp(0.0, 1.0),
                                  _animation.value,
                                  (_animation.value + 0.3).clamp(0.0, 1.0),
                                ],
                              ),
                            ),
                          );
                        },
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