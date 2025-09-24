import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Custom rating stars widget for displaying restaurant ratings
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRatingText;
  final int maxStars;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showRatingText = true,
    this.maxStars = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? AppTheme.starRating;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star icons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxStars, (index) {
            final starValue = index + 1;
            IconData iconData;
            
            if (rating >= starValue) {
              iconData = Icons.star;
            } else if (rating >= starValue - 0.5) {
              iconData = Icons.star_half;
            } else {
              iconData = Icons.star_border;
            }
            
            return Icon(
              iconData,
              color: starColor,
              size: size,
            );
          }),
        ),
        
        // Rating text
        if (showRatingText) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Animated rating stars with bounce effect
class AnimatedRatingStars extends StatefulWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRatingText;
  final Duration animationDuration;

  const AnimatedRatingStars({
    Key? key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showRatingText = true,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<AnimatedRatingStars> createState() => _AnimatedRatingStarsState();
}

class _AnimatedRatingStarsState extends State<AnimatedRatingStars>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final starColor = widget.color ?? AppTheme.starRating;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated star icons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            IconData iconData;
            
            if (widget.rating >= starValue) {
              iconData = Icons.star;
            } else if (widget.rating >= starValue - 0.5) {
              iconData = Icons.star_half;
            } else {
              iconData = Icons.star_border;
            }
            
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _animations[index].value,
                  child: Icon(
                    iconData,
                    color: starColor,
                    size: widget.size,
                  ),
                );
              },
            );
          }),
        ),
        
        // Rating text
        if (widget.showRatingText) ...[
          const SizedBox(width: 4),
          Text(
            widget.rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}