"""
gen_settings_profile_module.py
Generates Flutter settings + profile module for ResumePilot.
Run from:  f:\\Resume Pilot app\\flutter_app\\
           python gen_settings_profile_module.py
"""

from pathlib import Path

ROOT = Path(__file__).parent / "lib"

FILES: dict[str, str] = {}

# ─────────────────────────────────────────────────────────────────────────────
# 1. user_settings.dart  (Freezed model)
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/settings/models/user_settings.dart"] = '''\
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

// ─── UserSettings ────────────────────────────────────────────────────────────
//
// Maps GET /user/settings → SettingsResponse
//   id, user_id, theme_preference, email_notifications_enabled,
//   interview_reminders_enabled, marketing_emails_enabled,
//   created_at, updated_at
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'theme_preference')
    @Default('system') String themePreference,
    @JsonKey(name: 'email_notifications_enabled')
    @Default(true) bool emailNotificationsEnabled,
    @JsonKey(name: 'interview_reminders_enabled')
    @Default(true) bool interviewRemindersEnabled,
    @JsonKey(name: 'marketing_emails_enabled')
    @Default(false) bool marketingEmailsEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

extension UserSettingsX on UserSettings {
  /// 'system' | 'light' | 'dark'
  bool get isDark        => themePreference == 'dark';
  bool get isLight       => themePreference == 'light';
  bool get isSystemTheme => themePreference == 'system';
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# 2. user_service.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/profile/data/user_service.dart"] = '''\
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/user_profile.dart';

class UserService {
  const UserService(this._dio);
  final Dio _dio;

  /// GET /user/me  →  UserProfile
  Future<UserProfile> getProfile() async {
    final res = await _dio.get<Map<String, dynamic>>('/user/me');
    return UserProfile.fromJson(res.data!);
  }

  /// PUT /user/me  →  UserProfile (full replacement via JsonKey fields)
  Future<UserProfile> updateProfile(Map<String, dynamic> fields) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/user/me',
      data: fields,
    );
    return UserProfile.fromJson(res.data!);
  }
}

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.watch(dioProvider)),
);
'''

# ─────────────────────────────────────────────────────────────────────────────
# 3. settings_service.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/settings/data/settings_service.dart"] = '''\
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/user_settings.dart';

class SettingsService {
  const SettingsService(this._dio);
  final Dio _dio;

  /// GET /user/settings  →  UserSettings
  Future<UserSettings> getSettings() async {
    final res = await _dio.get<Map<String, dynamic>>('/user/settings');
    return UserSettings.fromJson(res.data!);
  }

  /// PATCH /user/settings  →  UserSettings
  Future<UserSettings> updateSettings(Map<String, dynamic> fields) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/user/settings',
      data: fields,
    );
    return UserSettings.fromJson(res.data!);
  }
}

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref.watch(dioProvider)),
);
'''

# ─────────────────────────────────────────────────────────────────────────────
# 4. profile_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/profile/providers/profile_provider.dart"] = '''\
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user_service.dart';
import '../models/user_profile.dart';

// ── ProfileNotifier ───────────────────────────────────────────────────────────
//
// Fetched once after login, kept alive for the session.
// Screens read: ref.watch(profileProvider)  → AsyncValue<UserProfile>
// Screens write: ref.read(profileProvider.notifier).updateProfile(fields)
// ─────────────────────────────────────────────────────────────────────────────

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() =>
      ref.watch(userServiceProvider).getProfile();

  Future<bool> updateProfile(Map<String, dynamic> fields) async {
    final previous = state;
    state = const AsyncLoading();
    try {
      final updated =
          await ref.read(userServiceProvider).updateProfile(fields);
      state = AsyncData(updated);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final profileProvider =
    AsyncNotifierProvider.keepAlive<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);
'''

# ─────────────────────────────────────────────────────────────────────────────
# 5. settings_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/settings/providers/settings_provider.dart"] = '''\
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_service.dart';
import '../models/user_settings.dart';

// ── Theme mode provider ───────────────────────────────────────────────────────
//
// A simple StateProvider<ThemeMode> seeded by SettingsNotifier.build()
// and updated whenever the user changes their theme preference.
//
// Consumed in app/app.dart:
//   themeMode: ref.watch(themeModeProvider)
// ─────────────────────────────────────────────────────────────────────────────

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ── SettingsNotifier ──────────────────────────────────────────────────────────

class SettingsNotifier extends AsyncNotifier<UserSettings> {
  @override
  Future<UserSettings> build() async {
    final settings =
        await ref.watch(settingsServiceProvider).getSettings();
    // Seed the theme provider immediately in the same frame.
    ref.read(themeModeProvider.notifier).state =
        _toThemeMode(settings.themePreference);
    return settings;
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  Future<void> setThemePreference(String preference) async {
    final prev = state.valueOrNull;
    if (prev == null) return;
    // Optimistic — update local theme immediately
    final updated = prev.copyWith(themePreference: preference);
    state = AsyncData(updated);
    ref.read(themeModeProvider.notifier).state = _toThemeMode(preference);
    try {
      final fromServer = await ref
          .read(settingsServiceProvider)
          .updateSettings({'theme_preference': preference});
      state = AsyncData(fromServer);
      ref.read(themeModeProvider.notifier).state =
          _toThemeMode(fromServer.themePreference);
    } catch (_) {
      // Roll back
      state = AsyncData(prev);
      ref.read(themeModeProvider.notifier).state =
          _toThemeMode(prev.themePreference);
    }
  }

  // ── Email notifications ───────────────────────────────────────────────────

  Future<void> toggleEmailNotifications() async {
    final prev = state.valueOrNull;
    if (prev == null) return;
    final next = !prev.emailNotificationsEnabled;
    state = AsyncData(prev.copyWith(emailNotificationsEnabled: next));
    try {
      final fromServer = await ref
          .read(settingsServiceProvider)
          .updateSettings({'email_notifications_enabled': next});
      state = AsyncData(fromServer);
    } catch (_) {
      state = AsyncData(prev);
    }
  }

  // ── Interview reminders ───────────────────────────────────────────────────

  Future<void> toggleInterviewReminders() async {
    final prev = state.valueOrNull;
    if (prev == null) return;
    final next = !prev.interviewRemindersEnabled;
    state = AsyncData(prev.copyWith(interviewRemindersEnabled: next));
    try {
      final fromServer = await ref
          .read(settingsServiceProvider)
          .updateSettings({'interview_reminders_enabled': next});
      state = AsyncData(fromServer);
    } catch (_) {
      state = AsyncData(prev);
    }
  }

  // ── Marketing emails ──────────────────────────────────────────────────────

  Future<void> toggleMarketingEmails() async {
    final prev = state.valueOrNull;
    if (prev == null) return;
    final next = !prev.marketingEmailsEnabled;
    state = AsyncData(prev.copyWith(marketingEmailsEnabled: next));
    try {
      final fromServer = await ref
          .read(settingsServiceProvider)
          .updateSettings({'marketing_emails_enabled': next});
      state = AsyncData(fromServer);
    } catch (_) {
      state = AsyncData(prev);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static ThemeMode _toThemeMode(String pref) => switch (pref) {
        'light'  => ThemeMode.light,
        'dark'   => ThemeMode.dark,
        _        => ThemeMode.system,
      };
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, UserSettings>(
  SettingsNotifier.new,
);
'''

# ─────────────────────────────────────────────────────────────────────────────
# 6. settings_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/settings/screens/settings_screen.dart"] = '''\
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

// ─────────────────────────────────────────────────────────────────────────────
// SettingsScreen — tab 3
// ─────────────────────────────────────────────────────────────────────────────

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
        AppSpacing.pageH, AppSpacing.px20,
        AppSpacing.pageH, AppSpacing.px8,
      ),
      child: Text(
        'Settings',
        style: AppTextStyles.headingXl.copyWith(color: colors.foreground),
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
                      style: AppTextStyles.titleMd
                          .copyWith(color: colors.foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      style: AppTextStyles.bodySmall.copyWith(
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
                  style: AppTextStyles.labelMd
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
  final AppColors    colors;
  final bool         isDark;

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
              // Placeholder — full delete-account flow in a future sprint
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
                    style: AppTextStyles.labelSm.copyWith(
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
  final String    label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSm.copyWith(
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
            style: AppTextStyles.titleSm.copyWith(color: colors.foreground),
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
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.foregroundTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeColor: colors.primary,
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
                          style: AppTextStyles.bodySmall.copyWith(
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
          style: AppTextStyles.titleMd.copyWith(
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
                    style: AppTextStyles.bodySmall
                        .copyWith(color: colors.destructive),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# 7. user_profile_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["features/profile/screens/user_profile_screen.dart"] = '''\
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/user_profile.dart';
import '../providers/profile_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UserProfileScreen — pushed from Settings (/profile)
// ─────────────────────────────────────────────────────────────────────────────

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors     = Theme.of(context).appColors;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: profileAsync.when(
        data: (p) => _ProfileLoaded(profile: p, colors: colors),
        loading: () => _ProfileLoadingView(colors: colors),
        error: (e, _) => _ProfileErrorView(
          message: e.toString(), colors: colors),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loaded state — edit form
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileLoaded extends ConsumerStatefulWidget {
  const _ProfileLoaded({required this.profile, required this.colors});
  final UserProfile profile;
  final AppColors   colors;

  @override
  ConsumerState<_ProfileLoaded> createState() => _ProfileLoadedState();
}

class _ProfileLoadedState extends ConsumerState<_ProfileLoaded> {
  final _formKey   = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _initialsCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.profile.fullName);
    _initialsCtrl = TextEditingController(
      text: widget.profile.initials ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _initialsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final fields = <String, dynamic>{
      'full_name': _nameCtrl.text.trim(),
      if (_initialsCtrl.text.trim().isNotEmpty)
        'initials': _initialsCtrl.text.trim().toUpperCase(),
    };

    final ok = await ref
        .read(profileProvider.notifier)
        .updateProfile(fields);

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors  = widget.colors;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final profile = widget.profile;

    return Stack(
      children: [
        // ── Gradient background ──────────────────────────────────────────
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.heroBackground(colors),
            ),
          ),
        ),

        // ── Gold glow blob ────────────────────────────────────────────────
        Positioned(
          top: -40,
          right: -40,
          child: IgnorePointer(
            child: SizedBox(
              width: 200,
              height: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.heroGoldGlow(colors),
                ),
              ),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              // ── App bar ─────────────────────────────────────────────────
              _ProfileAppBar(
                colors: colors,
                saving: _saving,
                onSave: _save,
              ),

              // ── Scrollable body ─────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageH,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.px24),

                        // Avatar
                        Center(
                          child: _LargeAvatarCircle(
                            initials: profile.displayInitials,
                            colors: colors,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.px12),

                        // Email chip (read-only)
                        Center(
                          child: _EmailChip(
                            email: profile.email,
                            colors: colors,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.px32),

                        // ── Form card ─────────────────────────────────────
                        _FormCard(
                          isDark: isDark,
                          colors: colors,
                          child: Column(
                            children: [
                              _FormField(
                                controller: _nameCtrl,
                                label: 'Full Name',
                                hint: 'e.g. Jane Smith',
                                colors: colors,
                                required: true,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  if (v.trim().length < 2) {
                                    return 'Name is too short';
                                  }
                                  return null;
                                },
                              ),
                              _FormDivider(colors: colors),
                              _FormField(
                                controller: _initialsCtrl,
                                label: 'Initials (optional)',
                                hint: 'e.g. JS',
                                colors: colors,
                                maxLength: 3,
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.px24),

                        // ── Account stats card ─────────────────────────────
                        _AccountStatsCard(
                          profile: profile,
                          isDark: isDark,
                          colors: colors,
                        ),

                        const SizedBox(height: AppSpacing.px32),

                        // ── Save button ────────────────────────────────────
                        _SaveButton(
                          saving: _saving,
                          colors: colors,
                          onPressed: _save,
                        ),

                        const SizedBox(height: AppSpacing.px48),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({
    required this.colors,
    required this.saving,
    required this.onSave,
  });

  final AppColors  colors;
  final bool       saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px8,
          vertical: AppSpacing.px4,
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  size: 20, color: colors.foreground),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                'Edit Profile',
                style: AppTextStyles.titleLg
                    .copyWith(color: colors.foreground),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: saving ? null : onSave,
              child: saving
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation(colors.primary),
                      ),
                    )
                  : Text(
                      'Save',
                      style: AppTextStyles.labelMd
                          .copyWith(color: colors.primary),
                    ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar
// ─────────────────────────────────────────────────────────────────────────────

class _LargeAvatarCircle extends StatelessWidget {
  const _LargeAvatarCircle({required this.initials, required this.colors});
  final String    initials;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.heroGradient1,
              colors.primary,
              colors.heroGradient2,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTextStyles.headingMd.copyWith(
            color: colors.primaryForeground,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Email chip
// ─────────────────────────────────────────────────────────────────────────────

class _EmailChip extends StatelessWidget {
  const _EmailChip({required this.email, required this.colors});
  final String    email;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px12,
          vertical: AppSpacing.px6,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 14, color: colors.foregroundTertiary),
            const SizedBox(width: 6),
            Text(
              email,
              style: AppTextStyles.bodySmall
                  .copyWith(color: colors.foregroundSecondary),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Form card
// ─────────────────────────────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.child,
    required this.isDark,
    required this.colors,
  });
  final Widget    child;
  final bool      isDark;
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

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.colors,
    this.required = false,
    this.maxLength,
    this.textCapitalization = TextCapitalization.words,
    this.validator,
  });

  final TextEditingController   controller;
  final String                  label;
  final String                  hint;
  final AppColors               colors;
  final bool                    required;
  final int?                    maxLength;
  final TextCapitalization      textCapitalization;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px16,
          vertical: AppSpacing.px12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSm.copyWith(
                    color: colors.foregroundSecondary,
                  ),
                ),
                if (required)
                  Text(
                    ' *',
                    style: AppTextStyles.labelSm
                        .copyWith(color: colors.destructive),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.px6),
            TextFormField(
              controller: controller,
              maxLength: maxLength,
              textCapitalization: textCapitalization,
              validator: validator,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.foreground),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.foregroundQuaternary,
                ),
                counterText: '',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
}

class _FormDivider extends StatelessWidget {
  const _FormDivider({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: colors.borderSubtle);
}

// ─────────────────────────────────────────────────────────────────────────────
// Account stats card
// ─────────────────────────────────────────────────────────────────────────────

class _AccountStatsCard extends StatelessWidget {
  const _AccountStatsCard({
    required this.profile,
    required this.isDark,
    required this.colors,
  });

  final UserProfile profile;
  final bool        isDark;
  final AppColors   colors;

  @override
  Widget build(BuildContext context) {
    final joined    = DateFormat('MMMM yyyy').format(profile.createdAt);
    final daysSince = DateTime.now().difference(profile.createdAt).inDays;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px20,
          vertical: AppSpacing.px16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: AppTextStyles.titleSm.copyWith(
                color: colors.foregroundSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.px12),
            Row(
              children: [
                _StatChip(
                  icon: Icons.calendar_today_outlined,
                  label: 'Joined $joined',
                  colors: colors,
                ),
                const SizedBox(width: AppSpacing.px8),
                _StatChip(
                  icon: Icons.access_time_outlined,
                  label: '$daysSince days',
                  colors: colors,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.colors,
  });
  final IconData  icon;
  final String    label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px10,
          vertical: AppSpacing.px6,
        ),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: colors.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(color: colors.primary),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Save button
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.saving,
    required this.colors,
    required this.onPressed,
  });
  final bool       saving;
  final AppColors  colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: saving
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [colors.primaryHover, colors.primary],
                  ),
            color: saving ? colors.primaryMuted : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ElevatedButton(
            onPressed: saving ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: saving
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(colors.primaryForeground),
                    ),
                  )
                : Text(
                    'Save Changes',
                    style: AppTextStyles.labelLg.copyWith(
                      color: colors.primaryForeground,
                    ),
                  ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Other state views
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      );
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({
    required this.message,
    required this.colors,
  });
  final String    message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _ProfileAppBar(
                  colors: colors,
                  saving: false,
                  onSave: () => context.pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Failed to load profile.',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: colors.foregroundSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# Write files
# ─────────────────────────────────────────────────────────────────────────────

def main():
    for rel, content in FILES.items():
        path = ROOT / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        print(f"  wrote  {rel}")
    print(f"\nDone — {len(FILES)} files written.")


if __name__ == "__main__":
    main()
