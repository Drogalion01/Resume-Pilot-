import 'package:flutter/material.dart';

class BreathingBackground extends StatelessWidget {
  final Widget child;

  const BreathingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }
}
