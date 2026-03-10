import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys stored in flutter_secure_storage.
abstract class _K {
  static const accessToken  = 'access_token';
  static const userId       = 'user_id';
  static const userEmail    = 'user_email';
  static const userInitials = 'user_initials';
}

/// flutter_secure_storage wrapper — single access point for token persistence.
///
/// ⚠ No refresh token: the backend does not issue refresh tokens.
///   Only the access_token (30-min JWT) is persisted.
///   On any 401 outside the auth endpoints, [clearAll] is called and the user
///   is redirected to /login.
///
/// Uses [AndroidOptions(encryptedSharedPreferences: true)] for AES-256
/// hardware-backed storage on Android 6+.
class TokenStorage {
  TokenStorage(this._storage);
  final FlutterSecureStorage _storage;

  // ── Write ────────────────────────────────────────────────────────────────

  Future<void> saveAuth({
    required String accessToken,
    required int    userId,
    required String email,
    required String initials,
  }) async {
    await Future.wait([
      _storage.write(key: _K.accessToken,  value: accessToken),
      _storage.write(key: _K.userId,       value: userId.toString()),
      _storage.write(key: _K.userEmail,    value: email),
      _storage.write(key: _K.userInitials, value: initials),
    ]);
  }

  Future<void> clearAll() => _storage.deleteAll();

  // ── Read ─────────────────────────────────────────────────────────────────

  Future<String?> getAccessToken()  => _storage.read(key: _K.accessToken);
  Future<String?> getUserEmail()    => _storage.read(key: _K.userEmail);
  Future<String?> getUserInitials() => _storage.read(key: _K.userInitials);

  Future<int?> getUserId() async {
    final raw = await _storage.read(key: _K.userId);
    return raw != null ? int.tryParse(raw) : null;
  }

  /// True when a persisted token exists (does not validate expiry).
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((_) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.watch(flutterSecureStorageProvider));
});

