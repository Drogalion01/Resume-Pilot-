import 'package:flutter/material.dart';

class AnimatedCounterText extends StatelessWidget {
  final double targetValue;
  final TextStyle? textStyle;
  final String prefix;
  final String suffix;
  final int fractionDigits;

  const AnimatedCounterText({
    super.key,
    required this.targetValue,
    this.textStyle,
    this.prefix = '',
    this.suffix = '',
    this.fractionDigits = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Text(
          '$prefix${value.toStringAsFixed(fractionDigits)}$suffix',
          style: textStyle ?? Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}
