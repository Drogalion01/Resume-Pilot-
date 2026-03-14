import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ResumePilot Design System — Gradient Tokens
///
/// Converts the CSS hero-gradient and accent gradient patterns into
/// Flutter LinearGradient / RadialGradient objects.
///
/// All gradients are factory methods that accept an [AppColors] instance
/// so they adapt to light / dark mode automatically.
///
/// Usage:
///   AppGradients.heroBackground(colors)   → hero header mesh gradient
///   AppGradients.primaryButton(colors)    → primary button gradient fill
///   AppGradients.goldAccent(colors)       → gold shimmer accent strip
///   AppGradients.scoreRingExcellent(...)  → score ring gradient

abstract class AppGradients {
  // ── Hero background (full-width header) ────────────────────────────────────
  //
  // CSS: 3 radial gradients layered over a solid base + gold glow layer.
  // Flutter only supports LinearGradient natively in a single BoxDecoration,
  // so we approximate the mesh with a linear sweep from top-left → bottom-right.
  // For the full mesh, use Stack with multiple RadialGradient containers or
  // CustomPainter. This helper gives a single-pass approximation.
  //
  static LinearGradient heroBackground(AppColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.heroGradient1,
          colors.heroGradient2,
          colors.heroGradient3,
          colors.heroGradient4,
        ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      );

  /// Hero radial glow layers as separate gradients to be rendered additively.
  /// Render heroGlow1 → heroGlow2 → heroGlow3 in stacked Containers.
  static RadialGradient heroGlow1(AppColors colors) => RadialGradient(
        center: const Alignment(-0.6, -0.4), // 20% x, 30% y
        radius: 1.2,
        colors: [
          colors.heroGradient1.withValues(alpha: 0.85),
          colors.heroGradient1.withValues(alpha: 0.0),
        ],
      );

  static RadialGradient heroGlow2(AppColors colors) => RadialGradient(
        center: const Alignment(0.6, 0.4), // 80% x, 70% y
        radius: 1.1,
        colors: [
          colors.heroGradient2.withValues(alpha: 0.80),
          colors.heroGradient2.withValues(alpha: 0.0),
        ],
      );

  /// Gold shimmer accent layered on top of hero glows (opacity 0.45 in CSS)
  static RadialGradient heroGoldGlow(AppColors colors) => RadialGradient(
        center: const Alignment(0.5, 0.2), // 75% x, 60% y
        radius: 0.9,
        colors: [
          colors.heroGoldGlow.withValues(alpha: 0.45),
          colors.heroGoldGlow.withValues(alpha: 0.0),
        ],
      );

  // ── Primary button gradient ─────────────────────────────────────────────────
  //
  // Subtle top-highlight gives the button a slightly elevated, premium feel.
  static LinearGradient primaryButton(AppColors colors) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.primaryHover,
          colors.primary,
        ],
        stops: const [0.0, 1.0],
      );

  /// Premium / Gold-tinted button gradient
  static LinearGradient premiumButton(AppColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.primaryHover,
          colors.primary,
          Color.lerp(colors.primary, colors.gold, 0.25)!,
        ],
        stops: const [0.0, 0.6, 1.0],
      );

  // ── Gold accent strip ───────────────────────────────────────────────────────
  static LinearGradient goldAccent(AppColors colors) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colors.gold,
          Color.lerp(colors.gold, colors.goldMuted, 0.3)!,
        ],
      );

  // ── Score ring gradients ────────────────────────────────────────────────────
  // Applied as a SweepGradient on the arc stroke.

  static SweepGradient scoreRingExcellent(AppColors colors) => SweepGradient(
        colors: [
          colors.scoreExcellent,
          Color.lerp(colors.scoreExcellent, colors.scoreGood, 0.5)!,
          colors.scoreExcellent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  static SweepGradient scoreRingGood(AppColors colors) => SweepGradient(
        colors: [
          colors.scoreGood,
          Color.lerp(colors.scoreGood, colors.scoreExcellent, 0.3)!,
          colors.scoreGood,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  static SweepGradient scoreRingAverage(AppColors colors) => SweepGradient(
        colors: [
          colors.scoreAverage,
          Color.lerp(colors.scoreAverage, colors.gold, 0.3)!,
          colors.scoreAverage,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  static SweepGradient scoreRingPoor(AppColors colors) => SweepGradient(
        colors: [
          colors.scorePoor,
          Color.lerp(colors.scorePoor, colors.scoreAverage, 0.3)!,
          colors.scorePoor,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  // ── Surface shimmer (loading skeleton) ──────────────────────────────────────
  static LinearGradient shimmer(AppColors colors) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colors.surfaceSecondary,
          colors.surfacePrimary.withValues(alpha: 0.9),
          colors.surfaceSecondary,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  // ── Score ring factory (dispatches by score %) ──────────────────────────────
  static SweepGradient forScore(int score, AppColors colors) {
    if (score >= 80) return scoreRingExcellent(colors);
    if (score >= 60) return scoreRingGood(colors);
    if (score >= 40) return scoreRingAverage(colors);
    return scoreRingPoor(colors);
  }
}
