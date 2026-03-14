import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

// ─────────────────────────────────────────────────────────────────────────────
// SettingsScreen — tab 3
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final profileAsync = ref.watch(profileProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // ── Background gradient ────────────────────────────────────────
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
                // ── Header ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _SettingsHeader(colors: colors),
                ),

                // ── Profile Summary Card ───────────────────────────────
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

                // ── Settings body ──────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageH,
        AppSpacing.px20,
        AppSpacing.pageH,
        AppSpacing.px8,
      ),
      child: Text(
        'Settings',
        style: AppTextStyles.display.copyWith(color: colors.foreground),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile summary card
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSummaryCard extends ConsumerWidget {
  const _ProfileSummaryCard({
    required this.profile,
    required this.colors,
    required this.isDark,
  });

  final UserProfile profile;
  final AppColors colors;
  final bool isDark;

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
                      profile.fullName ?? 'User',
                      style: AppTextStyles.title
                          .copyWith(color: colors.foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email ?? profile.phone ?? '',
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
                  style:
                      AppTextStyles.buttonLabel.copyWith(color: colors.primary),
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

// ─────────────────────────────────────────────────────────────────────────────
// Settings body — sections
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({
    required this.settings,
    required this.colors,
    required this.isDark,
  });

  final UserSettings settings;
  final AppColors colors;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Appearance ─────────────────────────────────────────────────
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

          // ── Notifications ───────────────────────────────────────────────
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

          // ── Account ─────────────────────────────────────────────────────
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
                  title: 'Unsubscribe',
                  subtitle: 'Cancel your premium service subscription',
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

  // ── Dialogs ────────────────────────────────────────────────────────────────

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
        builder: (_) {
          return AlertDialog(
            title: const Text('Unsubscribe'),
            content: const Text(
              'This will cancel your premium subscription. You will also be logged out. '
              'To use this app again, you will need to subscribe again.\n\n'
              'Are you sure you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  Navigator.pop(context, true);

                  final phone = ref.read(profileProvider).value?.phone;
                  if (phone == null || phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Cannot identify phone number to unsubscribe.')),
                    );
                    return;
                  }

                  try {
                    String subId =
                        phone.startsWith('880') ? phone : '8801$phone';
                    if (subId.startsWith('8801880')) {
                      subId = phone; // Handle if double prepended
                    }
                    // actually it should probably just be tel:880xxxxxxxx
                    // The backend usually expects tel:8801xxxxxxx
                    String finalSubId =
                        'tel:$phone'; // bdapps_api handles prepending if missing

                    final response = await http.post(
                      Uri.parse(
                          'https://www.flicksize.com/resumepilot/unsubscribe.php'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'subscriberId': finalSubId}),
                    );

                    if (response.statusCode >= 200 &&
                        response.statusCode < 300) {
                      // Unsubscribed successfully, log out locally
                      ref.read(authNotifierProvider.notifier).logout();
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Failed to unsubscribe. Server returned: ${response.statusCode}')),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Unsubscribe'),
              ),
            ],
          );
        });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme segment control
// ─────────────────────────────────────────────────────────────────────────────

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
    ('light', Icons.light_mode_outlined, 'Light'),
    ('dark', Icons.dark_mode_outlined, 'Dark'),
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
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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

// ─────────────────────────────────────────────────────────────────────────────
// Shared tile widgets
// ─────────────────────────────────────────────────────────────────────────────

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
  final String label;
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
  final IconData icon;
  final String title;
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

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final AppColors colors;
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

  final IconData icon;
  final String title;
  final String? subtitle;
  final AppColors colors;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool enabled;

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

// ─────────────────────────────────────────────────────────────────────────────
// Avatar
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.initials, required this.colors});
  final String initials;
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

// ─────────────────────────────────────────────────────────────────────────────
// Loading shimmers
// ─────────────────────────────────────────────────────────────────────────────

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
  final String message;
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
