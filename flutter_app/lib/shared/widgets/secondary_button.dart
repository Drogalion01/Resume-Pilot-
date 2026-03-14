import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SecondaryButton  — outlined / ghost button
// ─────────────────────────────────────────────────────────────────────────────

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.width,
    this.height = 52.0,
    this.ghost = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool enabled;
  final double? width;
  final double height;

  /// ghost = true → transparent fill; false → surfacePrimary fill
  final bool ghost;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDisabled =
        !widget.enabled || widget.loading || widget.onPressed == null;
    final fg = isDisabled ? colors.foregroundTertiary : colors.primary;
    final bg = widget.ghost
        ? ((_pressed && !isDisabled)
            ? colors.primaryLight.withValues(alpha: 0.6)
            : Colors.transparent)
        : ((_pressed && !isDisabled)
            ? colors.primaryLight
            : colors.surfacePrimary);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!isDisabled) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadii.button),
            border: Border.all(
              color: isDisabled ? colors.border : colors.primaryMuted,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: fg),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTextStyles.buttonLabel.copyWith(color: fg),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
