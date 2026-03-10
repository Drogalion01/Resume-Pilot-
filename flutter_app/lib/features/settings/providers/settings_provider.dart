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
