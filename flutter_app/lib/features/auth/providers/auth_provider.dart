import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/auth/auth_repository.dart';
import '../../../core/auth/auth_state.dart';

// ─────────────────────────────────────────────────────────────────
// AuthNotifier — global auth state machine
// ─────────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
  static const _cachePrefixesToClear = [
    'dashboard_cache_data_user_',
    'resume_list_cache_user_',
    'applications_list_cache_user_',
  ];

  static const _legacyCacheKeysToClear = [
    'dashboard_cache_data',
    'resume_list_cache',
    'applications_list_cache',
  ];

  @override
  AuthState build() {
    // Defer bootstrap until AFTER build() returns.
    // Calling _bootstrap() directly would execute `state = checking` synchronously
    // inside build(), which Riverpod silently drops — leaving the app on splash forever.
    Future.microtask(_bootstrap);
    return const AuthState.initial();
  }

  // ── Cold start ───────────────────────────────────────────────────────

  Future<void> _bootstrap() async {
    state = const AuthState.checking();
    try {
      final resolved = await ref
          .read(authRepositoryProvider)
          .checkAuthStatus()
          .timeout(const Duration(seconds: 8));
      state = resolved;
    } on TimeoutException {
      // Backend unreachable — fall through to welcome screen immediately.
      state = const AuthState.unauthenticated();
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  // ── BDApps Auth ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> checkSubscription(String phoneNumber) async {
    return ref.read(authRepositoryProvider).checkSubscription(phoneNumber);
  }

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    return ref.read(authRepositoryProvider).sendOtp(phoneNumber);
  }

  Future<void> verifyOtp({
    required String phone,
    required String referenceNo,
    required String otp,
  }) async {
    final result = await ref.read(authRepositoryProvider).verifyOtp(
          phone: phone,
          referenceNo: referenceNo,
          otp: otp,
        );
    state = result;
  }

  Future<void> sessionByPhone({required String phone}) async {
    final result = await ref.read(authRepositoryProvider).sessionByPhone(
          phone: phone,
        );
    state = result;
  }

  // ── Logout ────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
      await _clearCachedUserData();
    } finally {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> _clearCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        final isUserScopedCache =
            _cachePrefixesToClear.any((prefix) => key.startsWith(prefix));
        final isLegacyCache = _legacyCacheKeysToClear.contains(key);
        if (isUserScopedCache || isLegacyCache) {
          await prefs.remove(key);
        }
      }
    } catch (_) {
      // Keep logout resilient even if local cache cleanup fails.
    }
  }

  // ── Force-unauthenticate (called by RefreshInterceptor on 401) ─────────────

  void forceUnauthenticated() {
    state = const AuthState.unauthenticated();
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

/// Global auth state — watched by GoRouter redirect and all auth-aware widgets.
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// ── GoRouterRefreshNotifier ───────────────────────────────────────────────

/// Bridges Riverpod state changes → GoRouter [refreshListenable].
/// GoRouter re-evaluates redirect whenever auth state changes.
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream<AuthState> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
