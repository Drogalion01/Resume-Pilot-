import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/auth/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../data/application_service.dart';
import '../models/application.dart';

const _kApplicationsCacheKeyPrefix = 'applications_list_cache_user_';

// ── State ─────────────────────────────────────────────────────────────────────

class ApplicationsState {
  const ApplicationsState({
    this.applications = const [],
    this.activeFilter,
    this.searchQuery = '',
  });

  final List<ApplicationResponse> applications;
  final ApplicationStatus? activeFilter; // null = "All"
  final String searchQuery;

  ApplicationsState copyWith({
    List<ApplicationResponse>? applications,
    ApplicationStatus? activeFilter,
    bool clearFilter = false,
    String? searchQuery,
  }) =>
      ApplicationsState(
        applications: applications ?? this.applications,
        activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
        searchQuery: searchQuery ?? this.searchQuery,
      );

  List<ApplicationResponse> get filtered {
    var list = applications;
    if (activeFilter != null) {
      list = list.where((a) => a.status == activeFilter).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((a) =>
              a.companyName.toLowerCase().contains(q) ||
              a.role.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Map<ApplicationStatus, int> get statusCounts {
    final counts = <ApplicationStatus, int>{};
    for (final a in applications) {
      counts[a.status] = (counts[a.status] ?? 0) + 1;
    }
    return counts;
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ApplicationsNotifier extends AsyncNotifier<ApplicationsState> {
  @override
  Future<ApplicationsState> build() async {
    final auth = ref.watch(authNotifierProvider);
    final userId = auth is AuthStateAuthenticated ? auth.userId : 0;
    final cacheKey = '$_kApplicationsCacheKeyPrefix$userId';

    final prefs = await SharedPreferences.getInstance();
    List<ApplicationResponse>? cachedApps;

    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        cachedApps =
            jsonList.map((j) => ApplicationResponse.fromJson(j)).toList();
      } catch (_) {}
    }

    final service = ref.watch(applicationServiceProvider);

    final fetchFuture = service.getApplications().then((apps) async {
      await prefs.setString(
          cacheKey, jsonEncode(apps.map((a) => a.toJson()).toList()));
      if (cachedApps != null) {
        state = AsyncData(ApplicationsState(applications: apps));
      }
      return ApplicationsState(applications: apps);
    }).catchError((error, stackTrace) {
      if (cachedApps != null)
        return ApplicationsState(applications: cachedApps);
      throw error;
    });

    if (cachedApps != null) {
      return ApplicationsState(applications: cachedApps);
    }

    return await fetchFuture;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  void setFilter(ApplicationStatus? status) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(status == null
        ? current.copyWith(clearFilter: true)
        : current.copyWith(activeFilter: status));
  }

  void setSearch(String query) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(searchQuery: query));
  }

  Future<ApplicationResponse> addApplication(ApplicationCreate body) async {
    final svc = ref.read(applicationServiceProvider);
    final created = await svc.createApplication(body);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(
        applications: [created, ...current.applications],
      ));
    }
    ref.invalidate(dashboardProvider);
    return created;
  }

  Future<void> removeApplication(int id) async {
    await ref.read(applicationServiceProvider).deleteApplication(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(
        applications: current.applications.where((a) => a.id != id).toList(),
      ));
    }
    ref.invalidate(dashboardProvider);
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, ApplicationsState>(
  ApplicationsNotifier.new,
);
