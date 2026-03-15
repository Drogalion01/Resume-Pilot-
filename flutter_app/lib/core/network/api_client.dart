import 'package:dio/dio.dart';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_constants.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';
import '../auth/token_storage.dart';
// Lazy import via callback to break circular dependency:
// dioProvider ← authRepositoryProvider ← authNotifierProvider
// The callback is only CALLED at runtime (on 401), not during build.
import '../../features/auth/providers/auth_provider.dart';


/// Setup cache directory synchronously
final cacheDirProvider = Provider<String>((ref) => throw UnimplementedError('cacheDirProvider not initialized'));

/// Dio HTTP client singleton — the single network entry point.
///
/// Interceptor chain (order matters):
///   1. [AuthInterceptor]    — injects Bearer token before every request
///   2. [RefreshInterceptor] — handles 401: clear token → notify auth state
///   3. [ErrorInterceptor]   — maps DioException → AppException
///
/// receiveTimeout is 30 s to accommodate POST /resumes/analyze (AI call).
Dio buildDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final storage = ref.read(tokenStorageProvider);

  final cacheDir = ref.read(cacheDirProvider);
  final cacheOptions = CacheOptions(
    store: FileCacheStore(cacheDir),
    // Use request policy to always request fresh data when online, 
    // but fallback to the store if offline (hitCacheOnErrorExcept handles this).
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403, 500],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage),
    RefreshInterceptor(
      storage,
      onUnauthorized: () =>
          ref.read(authNotifierProvider.notifier).forceUnauthenticated(),
    ),
    DioCacheInterceptor(options: cacheOptions), // Offline cache middleware
    ErrorInterceptor(),
  ]);

  return dio;
}

/// Riverpod provider for the shared Dio instance.
final dioProvider = Provider<Dio>((ref) => buildDio(ref));
