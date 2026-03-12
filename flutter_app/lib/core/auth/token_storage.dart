import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys stored in flutter_secure_storage.
abstract class _K {
  static const accessToken = 'access_token';
  static const userId = 'user_id';
  static const userEmail = 'user_email';
  static const userInitials = 'user_initials';
  static const userPhone = 'user_phone';
}

/// flutter_secure_storage wrapper — single access point for token persistence.
///
/// ⚠ No refresh token: the backend does not issue refresh tokens.
///   Only the access_token (30-min JWT) is persisted.
///   On any 401 outside the auth endpoints, [clearAll] is called and the user
///   is redirected to /login.
///
/// On web, flutter_secure_storage uses WebCrypto (AES-GCM).  If the stored
/// data is incompatible with the current key (e.g. data from a previous version
/// or a cleared IndexedDB key), reads throw a JS OperationError.  All read
/// helpers therefore catch exceptions, clear potentially-corrupted storage, and
/// return null — forcing the user back to the login screen cleanly.
class TokenStorage {
  TokenStorage(this._storage);
  final FlutterSecureStorage _storage;

  // ── Write ────────────────────────────────────────────────────────────────

  Future<void> saveAuth({
    required String accessToken,
    required int userId,
    String? email,
    String? initials,
    String? phone,
  }) async {
    // Always evict stale/incompatible WebCrypto key+data before writing.
    // On web, flutter_secure_storage_web uses AES-GCM via the browser's
    // WebCrypto API.  Stale encrypted values from a previous session (with a
    // different AES key) cause crypto.subtle.decrypt() to throw a
    // DOMException(OperationError) — which is NOT a Dart Exception and
    // therefore escapes the library's own catch clause.
    await _tryClearAll();

    // Write ONE AT A TIME — never in parallel.
    //
    // flutter_secure_storage_web generates a shared AES key the first time
    // it sees empty storage, stores it under `publicKey` in localStorage,
    // then encrypts the value with it.  If multiple writes fire concurrently
    // (e.g. via Future.wait), they ALL race through the "no key yet" branch,
    // each generating its own key and clobbering `publicKey`.  Only the last
    // writer's key survives; all earlier writes become permanently unreadable.
    await _storage.write(key: _K.accessToken, value: accessToken);
    await _storage.write(key: _K.userId, value: userId.toString());
    await _storage.write(key: _K.userEmail, value: email);
    await _storage.write(key: _K.userInitials, value: initials);
    await _storage.write(key: _K.userPhone, value: phone);
  }

  Future<void> clearAll() => _tryClearAll();

  Future<void> _tryClearAll() async {
    try {
      // On web sometimes deleteAll throws or fails silently.
      // Explicitly delete known keys. On Android occasionally deleteAll() hangs.
      await _storage.delete(key: _K.accessToken);
      await _storage.delete(key: _K.userId);
      await _storage.delete(key: _K.userEmail);
      await _storage.delete(key: _K.userInitials);
      await _storage.delete(key: _K.userPhone);
    } catch (_) {
      // Ignore errors during clear — nothing we can do.
    }
  }

  // ── Read ─────────────────────────────────────────────────────────────────

  /// Returns the stored access token, or null if missing or storage is corrupt.
  /// On WebCrypto OperationError, clears all storage so future writes succeed.
  Future<String?> getAccessToken() => _safeRead(_K.accessToken);

  Future<String?> getUserEmail() => _safeRead(_K.userEmail);
  Future<String?> getUserInitials() => _safeRead(_K.userInitials);
  Future<String?> getUserPhone() => _safeRead(_K.userPhone);

  Future<int?> getUserId() async {
    final raw = await _safeRead(_K.userId);
    return raw != null ? int.tryParse(raw) : null;
  }

  /// True when a persisted token exists (does not validate expiry).
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Wraps [FlutterSecureStorage.read] with error handling.
  /// On any exception (e.g. WebCrypto OperationError on web), clears all
  /// storage and returns null so the caller treats the state as unauthenticated.
  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      await _tryClearAll();
      return null;
    }
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((_) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.watch(flutterSecureStorageProvider));
});
