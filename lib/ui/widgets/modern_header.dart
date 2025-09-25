import 'package:flutter/material.dart';

class ModernAppHeader extends StatefulWidget {
  final int? cartItemCount;
  final VoidCallback? onLocationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onCategoryTap;

  const ModernAppHeader({
    super.key,
    this.cartItemCount,
    this.onLocationTap,
    this.onSearchTap,
    this.onCartTap,
    this.onProfileTap,
    this.onCategoryTap,
  });

  @override
  State<ModernAppHeader> createState() => _ModernAppHeaderState();
}

class _ModernAppHeaderState extends State<ModernAppHeader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: 170,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
                theme.colorScheme.secondary.withValues(alpha: 0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  // Brand name section
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Nestafar brand name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Nestafar',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Location and profile row
                          Row(
                            children: [
                              // Location section
                              Expanded(
                                child: GestureDetector(
                                  onTap: widget.onLocationTap,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Deliver to',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: Colors.white.withValues(alpha: 0.8),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(height: 1),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Home - 123 Main Street',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Cart and Profile
                              Row(
                                children: [
                                  if (widget.cartItemCount != null && widget.cartItemCount! > 0)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: widget.onCartTap,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Badge(
                                            label: Text(
                                              widget.cartItemCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: theme.colorScheme.error,
                                            child: Icon(
                                              Icons.shopping_cart_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: widget.onProfileTap,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Search bar
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
                    )),
                    child: FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
                      )),
                      child: GestureDetector(
                        onTap: widget.onSearchTap,
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Icon(
                                Icons.search_rounded,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search for restaurants, dishes...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Category chips
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.8),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.4, 1.0, curve: Curves.easeOutCubic),
                    )),
                    child: FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.4, 1.0, curve: Curves.easeOutCubic),
                      )),
                      child: CategoryChips(
                        onCategoryTap: widget.onCategoryTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryChips extends StatelessWidget {
  final VoidCallback? onCategoryTap;

  const CategoryChips({
    super.key,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['🍕 Pizza', '🍔 Burgers', '🍣 Sushi', '🥗 Healthy'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 100)),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == categories.length - 1 ? 0 : 0,
                  ),
                  child: GestureDetector(
                    onTap: onCategoryTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}