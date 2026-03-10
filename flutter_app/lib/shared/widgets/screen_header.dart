import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScreenHeader
//
// Thin app-bar style header used on full-screen push routes (no bottom-nav).
// Transparent background — scrolls behind gradient when used inside
// CustomScrollView; sticky when used as standalone column header.
// ─────────────────────────────────────────────────────────────────────────────

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
  });

  final String       title;
  final String?      subtitle;
  final Widget?      leading;
  final List<Widget> actions;
  final bool         centerTitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final canPop = Navigator.of(context).canPop();

    final backBtn = canPop
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: colors.foreground,
            ),
            onPressed: Navigator.of(context).pop,
          )
        : null;

    final effectiveLeading = leading ?? backBtn;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.px4,
        right: AppSpacing.px4,
        top: AppSpacing.px4,
        bottom: AppSpacing.px4,
      ),
      child: Row(
        children: [
          if (effectiveLeading != null) effectiveLeading,
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: AppTextStyles.title.copyWith(color: colors.foreground),
              child: centerTitle
                  ? Text(title, textAlign: TextAlign.center)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.foregroundSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
