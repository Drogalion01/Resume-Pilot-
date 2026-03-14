import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dashboard_service.dart';
import '../models/dashboard_response.dart';

const _kDashboardCacheKey = 'dashboard_cache_data';

class DashboardNotifier extends AsyncNotifier<DashboardResponse> {
  @override
  Future<DashboardResponse> build() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Optimistic UI: Try to load from cache first
    final cachedData = prefs.getString(_kDashboardCacheKey);
    if (cachedData != null) {
      try {
        final json = jsonDecode(cachedData);
        final cachedResponse = DashboardResponse.fromJson(json);

        // Yield cached data immediately so UI renders instantly without loading spinner
        state = AsyncData(cachedResponse);
      } catch (e) {
        // Cache decoding failed, ignore
      }
    }

    // 2. Fetch fresh data from backend
    try {
      final response = await ref.watch(dashboardServiceProvider).getDashboard();

      // 3. Update cache with fresh data
      await prefs.setString(_kDashboardCacheKey, jsonEncode(response.toJson()));

      // 4. Return new data to update state
      return response;
    } catch (e, st) {
      // 5. Offline Fallback
      if (state.hasValue) {
        // If network fails but we had cached data, silently preserve the cache
        // (User still sees the Dashboard without a fatal error screen)
        return state.requireValue;
      } else {
        // Real error (no network + no cache)
        Error.throwWithStackTrace(e, st);
      }
    }
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
