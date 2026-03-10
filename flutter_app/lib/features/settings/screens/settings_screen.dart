import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/models/user_profile.dart';
import '../../profile/providers/profile_provider.dart';
import '../models/user_settings.dart';
import '../providers/settings_provider.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SettingsScreen â€” tab 3
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors     = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final isDark     = brightness == Brightness.dark;

    final profileAsync  = ref.watch(profileProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // â”€â”€ Background gradient â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                SliverToBoxAdapter(
                  child: _SettingsHeader(colors: colors),
                ),

                // â”€â”€ Profile Summary Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                SliverToBoxAdapter(
                  child: profileAsync.when(
                    data: (p) => _ProfileSummaryCard(
                      profile: p, colors: colors, isDark: isDark),
                    loading: () => const _ProfileSummaryShimmer(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.px24),
                ),

                // â”€â”€ Settings body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                SliverToBoxAdapter(
                  child: settingsAsync.when(
                    data: (s) => _SettingsBody(
                      settings: s, colors: colors, isDark: isDark),
                    loading: () => const _SettingsBodyShimmer(),
                    error: (e, _) => _SettingsErrorBanner(
                      message: e.toString(), colors: colors),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.px48),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Header
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageH, AppSpacing.px20,
        AppSpacing.pageH, AppSpacing.px8,
      ),
      child: Text(
        'Settings',
        style: AppTextStyles.display.copyWith(color: colors.foreground),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Profile summary card
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProfileSummaryCard extends ConsumerWidget {
  const _ProfileSummaryCard({
    required this.profile,
    required this.colors,
    required this.isDark,
  });

  final UserProfile profile;
  final AppColors   colors;
  final bool        isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.px20),
          child: Row(
            children: [
              // Avatar
              _AvatarCircle(initials: profile.displayInitials, colors: colors),
              const SizedBox(width: AppSpacing.px16),

              // Name + Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: AppTextStyles.title
                          .copyWith(color: colors.foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.foregroundSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Edit Profile button
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.profile),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: colors.primary,
                ),
                label: Text(
                  'Edit',
                  style: AppTextStyles.buttonLabel
                      .copyWith(color: colors.primary),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.px10,
                    vertical: AppSpacing.px6,
                  ),
                  backgroundColor: colors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Settings body â€” sections
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({
    required this.settings,
    required this.colors,
    required this.isDark,
  });

  final UserSettings settings;
  final AppColors    colors;
  final bool         isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // â”€â”€ Appearance â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionLabel(label: 'Appearance', colors: colors),
          const SizedBox(height: AppSpacing.px8),
          _SettingsCard(
            isDark: isDark,
            colors: colors,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.px16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TileLabel(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    colors: colors,
                  ),
                  const SizedBox(height: AppSpacing.px12),
                  _ThemeSegmentControl(
                    current: settings.themePreference,
                    colors: colors,
                    onChanged: (pref) => ref
                        .read(settingsProvider.notifier)
                        .setThemePreference(pref),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.px24),

          // â”€â”€ Notifications â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionLabel(label: 'Notifications', colors: colors),
          const SizedBox(height: AppSpacing.px8),
          _SettingsCard(
            isDark: isDark,
            colors: colors,
            child: Column(
              children: [
                _ToggleTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive application activity updates via email',
                  value: settings.emailNotificationsEnabled,
                  colors: colors,
                  onChanged: (_) => ref
                      .read(settingsProvider.notifier)
                      .toggleEmailNotifications(),
                ),
                _Divider(colors: colors),
                _ToggleTile(
                  icon: Icons.notifications_outlined,
                  title: 'Interview Reminders',
                  subtitle: 'Push reminders before scheduled interviews',
                  value: settings.interviewRemindersEnabled,
                  colors: colors,
                  onChanged: (_) => ref
                      .read(settingsProvider.notifier)
                      .toggleInterviewReminders(),
                ),
                _Divider(colors: colors),
                _ToggleTile(
                  icon: Icons.campaign_outlined,
                  title: 'Marketing Emails',
                  subtitle: 'Tips, product updates & promotions',
                  value: settings.marketingEmailsEnabled,
                  colors: colors,
                  onChanged: (_) => ref
                      .read(settingsProvider.notifier)
                      .toggleMarketingEmails(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.px24),

          // â”€â”€ Account â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionLabel(label: 'Account', colors: colors),
          const SizedBox(height: AppSpacing.px8),
          _SettingsCard(
            isDark: isDark,
            colors: colors,
            child: Column(
              children: [
                _NavTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  colors: colors,
                  onTap: () => context.push(AppRoutes.profile),
                ),
                _Divider(colors: colors),
                _NavTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Coming soon',
                  colors: colors,
                  enabled: false,
                  onTap: () {},
                ),
                _Divider(colors: colors),
                _NavTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  colors: colors,
                  iconColor: colors.statusRejected,
                  titleColor: colors.statusRejected,
                  onTap: () => _confirmSignOut(context, ref),
                ),
                _Divider(colors: colors),
                _NavTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and all data',
                  colors: colors,
                  iconColor: colors.destructive,
                  titleColor: colors.destructive,
                  onTap: () => _confirmDeleteAccount(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Dialogs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sign Out',
              style: TextStyle(color: colors.statusRejected),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(authNotifierProvider.notifier).logout();
      }
    });
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all your data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.destructive,
            ),
            onPressed: () {
              Navigator.pop(context, true);
              // Placeholder â€” full delete-account flow in a future sprint
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Account deletion is not yet available.'),
                ),
              );
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Theme segment control
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ThemeSegmentControl extends StatelessWidget {
  const _ThemeSegmentControl({
    required this.current,
    required this.colors,
    required this.onChanged,
  });

  final String current;
  final AppColors colors;
  final ValueChanged<String> onChanged;

  static const _options = [
    ('system', Icons.brightness_auto_outlined, 'System'),
    ('light',  Icons.light_mode_outlined,      'Light'),
    ('dark',   Icons.dark_mode_outlined,        'Dark'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _options.map((opt) {
        final (pref, icon, label) = opt;
        final selected = current == pref;
        return Expanded(
          child: GestureDetector(
            onTap: selected ? null : () => onChanged(pref),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.px10,
              ),
              decoration: BoxDecoration(
                color: selected ? colors.primary : colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? colors.primary : colors.border,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: selected
                        ? colors.primaryForeground
                        : colors.foregroundSecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: AppTextStyles.overline.copyWith(
                      color: selected
                          ? colors.primaryForeground
                          : colors.foregroundSecondary,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Shared tile widgets
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.child,
    required this.isDark,
    required this.colors,
  });
  final Widget child;
  final bool isDark;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
          border: Border.all(color: colors.borderSubtle),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: child,
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colors});
  final String    label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: colors.foregroundTertiary,
            letterSpacing: 0.8,
          ),
        ),
      );
}

class _TileLabel extends StatelessWidget {
  const _TileLabel({
    required this.icon,
    required this.title,
    required this.colors,
  });
  final IconData  icon;
  final String    title;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, color: colors.foregroundSecondary),
          const SizedBox(width: AppSpacing.px8),
          Text(
            title,
            style: AppTextStyles.title.copyWith(color: colors.foreground),
          ),
        ],
      );
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.colors,
    required this.onChanged,
    this.subtitle,
  });

  final IconData   icon;
  final String     title;
  final String?    subtitle;
  final bool       value;
  final AppColors  colors;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px16,
          vertical: AppSpacing.px12,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.foregroundSecondary),
            const SizedBox(width: AppSpacing.px12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: colors.foreground),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.foregroundTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeThumbColor: colors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.colors,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.titleColor,
    this.enabled = true,
  });

  final IconData   icon;
  final String     title;
  final String?    subtitle;
  final AppColors  colors;
  final VoidCallback onTap;
  final Color?     iconColor;
  final Color?     titleColor;
  final bool       enabled;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: enabled ? 1.0 : 0.45,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.px16,
              vertical: AppSpacing.px14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? colors.foregroundSecondary,
                ),
                const SizedBox(width: AppSpacing.px12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: titleColor ?? colors.foreground,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppTextStyles.caption.copyWith(
                            color: colors.foregroundTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: colors.foregroundQuaternary,
                ),
              ],
            ),
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  const _Divider({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        indent: AppSpacing.px16 + 20 + AppSpacing.px12,
        endIndent: 0,
        color: colors.borderSubtle,
      );
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Avatar
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.initials, required this.colors});
  final String    initials;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.primaryHover],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTextStyles.title.copyWith(
            color: colors.primaryForeground,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Loading shimmers
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProfileSummaryShimmer extends StatelessWidget {
  const _ProfileSummaryShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSubtle),
        ),
      ),
    );
  }
}

class _SettingsBodyShimmer extends StatelessWidget {
  const _SettingsBodyShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.px24),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderSubtle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsErrorBanner extends StatelessWidget {
  const _SettingsErrorBanner({
    required this.message,
    required this.colors,
  });
  final String    message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.destructiveLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.px16),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: colors.destructive, size: 20),
                const SizedBox(width: AppSpacing.px8),
                Expanded(
                  child: Text(
                    'Failed to load settings. Pull to refresh.',
                    style: AppTextStyles.caption
                        .copyWith(color: colors.destructive),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
