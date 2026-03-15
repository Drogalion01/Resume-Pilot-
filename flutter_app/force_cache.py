import re

file_path = 'lib/core/network/api_client.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Instead of relying on backend caching headers, we force the interceptor to cache 
new_options = '''
  final cacheOptions = CacheOptions(
    store: FileCacheStore(cacheDir),
    // Request first, but fallback to cache if offline.
    policy: CachePolicy.request,
    // Provide a default stale time of 7 days, even if the backend didn't set caching explicitely!
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );
'''

# Wait, dio_cache_interceptor by default respects Cache-Control. 
# To force it, we can't easily do it just in CacheOptions, wait, CachePolicy.forceCache wouldn't hit the server!
# Oh, CachePolicy.request does: "Returns the cached response if the request fails". It ignores CacheControl in that exact fallback scenario. It will ALWAYS save the response to disk if policy is not CachePolicy.noCache.
