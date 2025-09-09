import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: AppColors.backgroundGradient,
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}
