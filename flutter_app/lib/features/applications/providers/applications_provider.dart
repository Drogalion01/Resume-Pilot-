import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/application_service.dart';
import '../models/application.dart';

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
        activeFilter:
            clearFilter ? null : (activeFilter ?? this.activeFilter),
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
    final apps =
        await ref.watch(applicationServiceProvider).getApplications();
    return ApplicationsState(applications: apps);
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
    return created;
  }

  Future<void> removeApplication(int id) async {
    await ref.read(applicationServiceProvider).deleteApplication(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(
        applications:
            current.applications.where((a) => a.id != id).toList(),
      ));
    }
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, ApplicationsState>(
  ApplicationsNotifier.new,
);
