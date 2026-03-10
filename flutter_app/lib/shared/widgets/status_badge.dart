import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StatusBadge  — colored pill chip for ApplicationStatus
// ─────────────────────────────────────────────────────────────────────────────

enum BadgeSize { small, medium, large }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.size = BadgeSize.medium,
  });

  final ApplicationStatus status;
  final BadgeSize         size;

  double get _fontSize => switch (size) {
        BadgeSize.small  => 10.0,
        BadgeSize.medium => 11.0,
        BadgeSize.large  => 12.0,
      };

  EdgeInsets get _padding => switch (size) {
        BadgeSize.small  => const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        BadgeSize.medium => const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        BadgeSize.large  => const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final pair   = AppStatusColors.forStatus(status, colors);

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: pair.background,
        borderRadius: BorderRadius.circular(AppRadii.badgePill),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.overline.copyWith(
          color: pair.foreground,
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
