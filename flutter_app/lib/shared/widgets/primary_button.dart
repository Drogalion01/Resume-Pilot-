import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PrimaryButton
//
// Gradient-filled pill button — the main CTA throughout the app.
// Press animates to scale 0.97 + removes gradient (loading dims it).
// ─────────────────────────────────────────────────────────────────────────────

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.width,
    this.height = 52.0,
  });

  final String       label;
  final VoidCallback? onPressed;
  final IconData?    icon;
  final bool         loading;
  final bool         enabled;
  final double?      width;
  final double       height;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final isDisabled = !widget.enabled || widget.loading || widget.onPressed == null;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); if (!isDisabled) widget.onPressed?.call(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width:  widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? null
                : AppGradients.primaryButton(colors),
            color: isDisabled ? colors.primaryMuted : null,
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(colors.primaryForeground),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: colors.primaryForeground),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: isDisabled
                            ? colors.foregroundTertiary
                            : colors.primaryForeground,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
