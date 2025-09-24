import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Shimmer loading effect for restaurant cards
class RestaurantCardShimmer extends StatefulWidget {
  const RestaurantCardShimmer({Key? key}) : super(key: key);

  @override
  State<RestaurantCardShimmer> createState() => _RestaurantCardShimmerState();
}

class _RestaurantCardShimmerState extends State<RestaurantCardShimmer>
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
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      theme.colorScheme.surfaceVariant,
                      theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      theme.colorScheme.surfaceVariant,
                    ],
                    stops: [
                      _animation.value - 0.3,
                      _animation.value,
                      _animation.value + 0.3,
                    ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                  ),
                ),
              ),
              
              // Content shimmer
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer
                    _ShimmerBox(
                      width: 200,
                      height: 20,
                      animation: _animation,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingS),
                    
                    // Subtitle shimmer
                    _ShimmerBox(
                      width: 120,
                      height: 16,
                      animation: _animation,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Details row shimmer
                    Row(
                      children: [
                        _ShimmerBox(
                          width: 60,
                          height: 14,
                          animation: _animation,
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        _ShimmerBox(
                          width: 80,
                          height: 14,
                          animation: _animation,
                        ),
                        const Spacer(),
                        _ShimmerBox(
                          width: 70,
                          height: 14,
                          animation: _animation,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
            theme.colorScheme.surfaceVariant,
            theme.colorScheme.surfaceVariant.withOpacity(0.5),
            theme.colorScheme.surfaceVariant,
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

/// Generic shimmer container for other use cases
class ShimmerContainer extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerContainer({
    Key? key,
    required this.child,
    this.isLoading = true,
  }) : super(key: key);

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _animationController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [
                _animationController.value - 0.3,
                _animationController.value,
                _animationController.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}