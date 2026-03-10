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
    AsyncNotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);
