import 'package:flutter/material.dart';
import 'package:project_x/models/post_model.dart';

class LikeAnimation extends StatelessWidget {
  final bool isAnimating;
  final bool smallLike;
  final Widget child;

  const LikeAnimation({
    required this.isAnimating,
    this.smallLike = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isAnimating)
          ScaleTransition(
            scale: Tween<double>(begin: 1, end: 1.5).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation<double>(1),
                curve: const Interval(0, 0.5, curve: Curves.easeOut),
              ),
            ),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
              size: smallLike ? 16 : 18,
            ),
          ),
      ],
    );
  }
}