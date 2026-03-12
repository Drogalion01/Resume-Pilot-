import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_repository.dart';
import '../../../core/auth/auth_state.dart';

// ─────────────────────────────────────────────────────────────────
// AuthNotifier — global auth state machine
// ─────────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
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

  // ── Login ────────────────────────────────────────────────────────────

  /// Throws [AppException] subtype on failure — screens must catch and display.
  Future<void> login({required String email, required String password}) async {
    final result = await ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
        );
    state = result;
  }

  // ── Signup ───────────────────────────────────────────────────────────

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).signup(
          fullName: fullName,
          email: email,
          password: password,
        );
    state = result;
  }

  // ── Logout ────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }

  // ── Force-unauthenticate (called by RefreshInterceptor on 401) ─────────────

  void forceUnauthenticated() {
    state = const AuthState.unauthenticated();
  }

  // ── Forgot password ─────────────────────────────────────────────────────

  /// No state change — purely fire-and-return. Screens show the returned message.
  Future<String> forgotPassword(String email) =>
      ref.read(authRepositoryProvider).forgotPassword(email);
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
