import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmoothWaveChart extends StatefulWidget {
  final Color color;
  final double height;
  final double width;

  const SmoothWaveChart({
    super.key,
    required this.color,
    this.height = 100,
    this.width = double.infinity,
  });

  @override
  State<SmoothWaveChart> createState() => _SmoothWaveChartState();
}

class _SmoothWaveChartState extends State<SmoothWaveChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: WavePainter(
            color: widget.color,
            progress: _animation.value,
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double progress;

  WavePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    path.moveTo(0, size.height);

    double x = 0;
    double y = 0;

    // Generate a smooth wave using sine functions
    for (double i = 0; i <= size.width * progress; i++) {
      x = i;
      y = size.height / 2 + math.sin(i * 0.03) * 15 + math.cos(i * 0.015) * 10;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Fill path
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width * progress, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
