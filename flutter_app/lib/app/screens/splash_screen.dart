import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SplashScreen
//
// Shown while AuthNotifier runs _bootstrap() (AuthState.initial / .checking).
// Router automatically replaces this screen once auth state settles.
// No navigation logic here — GoRouter redirect handles everything.
// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _dotOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _scaleIn = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _dotOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.heroBackground(colors),
        ),
        child: Stack(
          children: [
            // Ambient glow blobs (decorative, same as welcome screen hero)
            Positioned(
              top: -80,
              right: -60,
              child: _GlowBlob(
                gradient: AppGradients.heroGlow1(colors),
                size: 320,
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: _GlowBlob(
                gradient: AppGradients.heroGlow2(colors),
                size: 280,
              ),
            ),

            // Centre content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo mark
                  FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scaleIn,
                      child: _LogoMark(colors: colors),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App name
                  FadeTransition(
                    opacity: _fadeIn,
                    child: Text(
                      'ResumePilot',
                      style: AppTextStyles.display.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Loading indicator
                  FadeTransition(
                    opacity: _dotOpacity,
                    child: _PulsingDots(color: colors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LogoMark — gradient rounded-square with a stylised "P" glyph
// ─────────────────────────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.colors});
  final dynamic colors; // AppColors

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton(colors),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: colors.primaryForeground,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PulsingDots — three animated dots while loading
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingDots extends StatefulWidget {
  const _PulsingDots({required this.color});
  final Color color;

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _scales = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final anim = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
      _controllers.add(ctrl);
      _scales.add(anim);

      // Stagger each dot by 200 ms
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ScaleTransition(
            scale: _scales[i],
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GlowBlob — radial gradient decorative blob (no pointer events)
// ─────────────────────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.gradient, required this.size});
  final Gradient gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
      ),
    );
  }
}
