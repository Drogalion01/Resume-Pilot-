import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/auth/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/error/app_exception.dart';
import '../data/dashboard_service.dart';
import '../models/dashboard_response.dart';

const _kDashboardCacheKeyPrefix = 'dashboard_cache_data_user_';

class DashboardNotifier extends AsyncNotifier<DashboardResponse> {
  @override
  Future<DashboardResponse> build() async {
    final auth = ref.watch(authNotifierProvider);
    final userId = auth is AuthStateAuthenticated ? auth.userId : 0;
    final cacheKey = '$_kDashboardCacheKeyPrefix$userId';

    final prefs = await SharedPreferences.getInstance();
    DashboardResponse? cachedResponse;

    // 1. Optimistic UI: Try to load from cache first
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final json = jsonDecode(cachedData);
        cachedResponse = DashboardResponse.fromJson(json);
      } catch (e) {
        // Cache decoding failed, ignore
      }
    }

    final service = ref.watch(dashboardServiceProvider);

    // 2. Fetch fresh data from backend (Background Task)
    final fetchFuture = service
        .getDashboard()
        .timeout(
          const Duration(seconds: 12),
          onTimeout: () => throw const NetworkException(
            'Dashboard is taking too long to load. Please check your internet and retry.',
          ),
        )
        .then((response) async {
      // 3. Update cache with fresh data
      await prefs.setString(cacheKey, jsonEncode(response.toJson()));

      // If we yielded cache initially, we update the state with the fresh data now
      if (cachedResponse != null) {
        state = AsyncData(response);
      }
      return response;
    }).catchError((error, stackTrace) {
      if (cachedResponse != null) {
        // If network fails but we had cache, silently preserve cache
        return cachedResponse;
      }
      throw error;
    });

    // 4. Return immediately if cache exists (skipping loading spinner completely!)
    if (cachedResponse != null) {
      // Background fetch will overwrite state when done
      return cachedResponse;
    }

    // 5. If no cache, we must wait for the data
    return await fetchFuture;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardResponse>(
  DashboardNotifier.new,
);
