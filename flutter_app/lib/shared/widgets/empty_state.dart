import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EmptyState  — centered icon + title + description + optional CTA
// ─────────────────────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Smaller layout for inline empty sections inside a card.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final iconSize = compact ? 36.0 : 52.0;
    final boxSize = compact ? 72.0 : 100.0;
    final vPad = compact ? AppSpacing.px24 : AppSpacing.px48;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: vPad,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primaryLight, colors.primaryMuted],
              ),
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: iconSize,
              color: colors.primary,
            ),
          ),

          SizedBox(height: compact ? AppSpacing.px16 : AppSpacing.px20),

          // Title
          Text(
            title,
            style: compact
                ? AppTextStyles.title.copyWith(color: colors.foreground)
                : AppTextStyles.headline.copyWith(color: colors.foreground),
            textAlign: TextAlign.center,
          ),

          if (description != null) ...[
            SizedBox(height: compact ? AppSpacing.px6 : AppSpacing.px8),
            Text(
              description!,
              style: AppTextStyles.body.copyWith(
                color: colors.foregroundSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? AppSpacing.px16 : AppSpacing.px24),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(actionLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.primaryForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.px24,
                  vertical: AppSpacing.px12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.button),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
