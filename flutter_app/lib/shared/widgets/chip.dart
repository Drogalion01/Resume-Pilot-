import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppChip  — filter / tag pill chip
// ─────────────────────────────────────────────────────────────────────────────

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.count,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final int? count;

  /// Override foreground — defaults to primary (selected) / foreground-secondary
  final Color? foregroundColor;

  /// Override background — defaults to primaryLight (selected) / surfaceSecondary
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final fg = foregroundColor ??
        (selected ? colors.primary : colors.foregroundSecondary);
    final bg = backgroundColor ??
        (selected ? colors.primaryLight : colors.surfaceSecondary);
    final borderColor = selected ? colors.primaryMuted : colors.borderSubtle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px12,
          vertical: AppSpacing.px6,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: AppTextStyles.buttonLabelSm.copyWith(color: fg),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: selected ? colors.primary : colors.border,
                  borderRadius: BorderRadius.circular(AppRadii.badgePill),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.micro.copyWith(
                      color: selected
                          ? colors.primaryForeground
                          : colors.foregroundSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
