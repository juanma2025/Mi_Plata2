import 'package:flutter/material.dart';

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Curves (Apple HIG inspired)
  static const Curve appleEaseIn = Cubic(0.42, 0.0, 1.0, 1.0);
  static const Curve appleEaseOut = Cubic(0.0, 0.0, 0.58, 1.0);
  static const Curve appleEaseInOut = Cubic(0.42, 0.0, 0.58, 1.0);
  
  /// Slide Up + Fade In (equiv: animate-slide-up)
  static Widget slideUpFade({
    required Widget child,
    required Animation<double> animation,
  }) {
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: appleEaseOut,
    );
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15), // roughly 15px depending on context
      end: Offset.zero,
    ).animate(fadeAnimation);

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }

  /// Slide Right (equiv: animate-slide-right)
  static Widget slideRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(-0.05, 0), // roughly 20px depending on width
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: appleEaseOut,
    ));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }

  /// Fade In (equiv: animate-fade-in)
  static Widget fadeIn({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
