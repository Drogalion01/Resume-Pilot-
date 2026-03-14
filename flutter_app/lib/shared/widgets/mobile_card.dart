import 'package:flutter/material.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MobileCard  — base elevated content card
//
// Variants:
//   default     → white/dark-surface + card shadow
//   outlined    → transparent + 1px border, no shadow
//   elevated    → surface + stronger primary-tinted shadow
//   sunken      → surfaceSunken background
//   interactive → default shadow; pressed = hover shadow + scale 0.98
// ─────────────────────────────────────────────────────────────────────────────

enum CardVariant { basic, outlined, elevated, sunken, interactive }

class MobileCard extends StatefulWidget {
  const MobileCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.variant = CardVariant.basic,
    this.radius,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final CardVariant variant;
  final double? radius;
  final Color? color;

  @override
  State<MobileCard> createState() => _MobileCardState();
}

class _MobileCardState extends State<MobileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final isInteractive =
        widget.variant == CardVariant.interactive || widget.onTap != null;

    final radius = widget.radius ?? AppRadii.card;
    final padding = widget.padding ?? const EdgeInsets.all(AppSpacing.cardPad);

    BoxDecoration decoration;
    switch (widget.variant) {
      case CardVariant.outlined:
        decoration = AppDecorations.cardOutlined(colors);
      case CardVariant.elevated:
        decoration = AppDecorations.cardElevated(colors, brightness);
      case CardVariant.sunken:
        decoration = AppDecorations.cardSunken(colors);
      case CardVariant.interactive:
        decoration = AppDecorations.cardInteractive(colors, brightness,
            pressed: _pressed);
      case CardVariant.basic:
        decoration = AppDecorations.card(colors, brightness);
    }

    if (widget.color != null) {
      decoration = decoration.copyWith(color: widget.color);
    }
    if (widget.radius != null) {
      decoration = decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      );
    }

    Widget content = Padding(padding: padding, child: widget.child);

    if (isInteractive) {
      content = GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: (_pressed && isInteractive) ? 0.975 : 1.0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: content,
        ),
      );
    }

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}
