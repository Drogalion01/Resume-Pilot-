import os

os.makedirs('lib/shared/widgets/animations', exist_ok=True)
os.makedirs('lib/shared/widgets/cards', exist_ok=True)
os.makedirs('lib/shared/widgets/buttons', exist_ok=True)
os.makedirs('lib/shared/widgets/backgrounds', exist_ok=True)
os.makedirs('lib/shared/widgets/charts', exist_ok=True)
os.makedirs('lib/core/theme', exist_ok=True)

theme_code = """import 'package:flutter/material.dart';

class PremiumTheme {
  static ThemeData get lightMode {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFCFCFC),
      primaryColor: const Color(0xFF50C878), // Emerald Green
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF50C878),
        secondary: Color(0xFFEFF2F9), // Secondary surface
        surface: Color(0xFFEFF2F9),
        background: Color(0xFFFCFCFC),
      ),
      fontFamily: 'Inter',
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFFEFF2F9),
      ),
    );
  }

  static ThemeData get darkMode {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: const Color(0xFF8E2DE2), // Electric Violet
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8E2DE2),
        secondary: Color(0xFF1E1E1E),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
      ),
      fontFamily: 'Inter',
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E1E1E),
      ),
    );
  }
}
"""

with open('lib/core/theme/premium_theme.dart', 'w', encoding='utf-8') as f:
    f.write(theme_code)

glass_card_code = """import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withOpacity(0.05) 
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
"""
with open('lib/shared/widgets/cards/glass_card.dart', 'w', encoding='utf-8') as f:
    f.write(glass_card_code)

animated_button_code = """import 'package:flutter/material.dart';

class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedScaleButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
"""
with open('lib/shared/widgets/buttons/animated_scale_button.dart', 'w', encoding='utf-8') as f:
    f.write(animated_button_code)

animated_counter_code = """import 'package:flutter/material.dart';

class AnimatedCounterText extends StatelessWidget {
  final double targetValue;
  final TextStyle? textStyle;
  final String prefix;
  final String suffix;
  final int fractionDigits;

  const AnimatedCounterText({
    Key? key,
    required this.targetValue,
    this.textStyle,
    this.prefix = '',
    this.suffix = '',
    this.fractionDigits = 0,
  }) : super(key: key);

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
"""
with open('lib/shared/widgets/animations/animated_counter_text.dart', 'w', encoding='utf-8') as f:
    f.write(animated_counter_code)

wave_chart_code = """import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmoothWaveChart extends StatefulWidget {
  final Color color;
  final double height;
  final double width;

  const SmoothWaveChart({
    Key? key,
    required this.color,
    this.height = 100,
    this.width = double.infinity,
  }) : super(key: key);

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
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
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
"""
with open('lib/shared/widgets/charts/smooth_wave_chart.dart', 'w', encoding='utf-8') as f:
    f.write(wave_chart_code)

breathing_bg_code = """import 'package:flutter/material.dart';
import 'dart:ui';

class BreathingBackground extends StatefulWidget {
  final Widget child;

  const BreathingBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<BreathingBackground> createState() => _BreathingBackgroundState();
}

class _BreathingBackgroundState extends State<BreathingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Stack(
      children: [
        // Base background
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        
        // Moving circles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: -100 + (_controller.value * 50),
              left: -50 + (_controller.value * 30),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.15),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              bottom: -150 + ((1 - _controller.value) * 50),
              right: -50 + ((1 - _controller.value) * 30),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            );
          },
        ),
        
        // Global Blur overlay to make it a mesh gradient feel
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
        
        // Foreground Content
        widget.child,
      ],
    );
  }
}
"""
with open('lib/shared/widgets/backgrounds/breathing_background.dart', 'w', encoding='utf-8') as f:
    f.write(breathing_bg_code)

print("UI components created successfully!")
