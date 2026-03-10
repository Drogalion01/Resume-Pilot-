import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../profile/models/user_profile.dart';

/// Fixed-height (~110 px) hero header for the dashboard screen.
///
/// Shows a time-based greeting, the user's display name, a gradient avatar
/// with initials, and a notification icon button.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.user});

  final UserProfile user;

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH)
          .copyWith(top: 16, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting + name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _greeting(),
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foregroundSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  user.firstName,
                  style: AppTextStyles.headline
                      .copyWith(color: colors.foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Avatar
          _GradientAvatar(initials: user.displayInitials, colors: colors),

          const SizedBox(width: 8),

          // Notification bell (decorative for now)
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: colors.foreground),
            style: IconButton.styleFrom(
              backgroundColor: colors.surfaceSecondary,
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({
    required this.initials,
    required this.colors,
  });

  final String initials;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.primaryButton(colors),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
