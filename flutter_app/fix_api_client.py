import re

file_path = 'lib/core/network/api_client.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# ADD IMPORTS
imports = '''
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
'''

if 'dio_cache_interceptor' not in content:
    content = content.replace("import 'package:dio/dio.dart';", "import 'package:dio/dio.dart';\n" + imports)


# ADD PROVIDER
cache_provider = '''
/// Setup cache directory synchronously
final cacheDirProvider = Provider<String>((ref) => throw UnimplementedError('cacheDirProvider not initialized'));
'''

if 'cacheDirProvider' not in content:
    content = content.replace('/// Dio HTTP client singleton', cache_provider + '\n/// Dio HTTP client singleton')

# REPLACE DIO INSTANCE
old_dio_setup = '''
  dio.interceptors.addAll([
    AuthInterceptor(storage),
    RefreshInterceptor(
      storage,
      onUnauthorized: () =>
          ref.read(authNotifierProvider.notifier).forceUnauthenticated(),
    ),
    ErrorInterceptor(),
  ]);
'''

new_dio_setup = '''
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
'''

if 'DioCacheInterceptor' not in content:
    content = content.replace(old_dio_setup.strip(), new_dio_setup.strip())

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated api_client.dart successfully")
