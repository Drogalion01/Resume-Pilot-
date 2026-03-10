import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppListItem  — general-purpose row list item
// ─────────────────────────────────────────────────────────────────────────────

class AppListItem extends StatelessWidget {
  const AppListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
  });

  final String       title;
  final String?      subtitle;
  final Widget?      leading;
  final Widget?      trailing;
  final VoidCallback? onTap;
  final EdgeInsets?  padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final content = Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.px16,
            vertical: AppSpacing.px12,
          ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.px12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: colors.foreground),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.foregroundSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.px8),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        splashColor: colors.primaryMuted.withValues(alpha: 0.25),
        highlightColor: colors.primaryLight.withValues(alpha: 0.3),
        child: content,
      );
    }
    return content;
  }
}
