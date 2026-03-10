import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_service.dart';
import '../models/dashboard_response.dart';

class DashboardNotifier extends AsyncNotifier<DashboardResponse> {
  @override
  Future<DashboardResponse> build() =>
      ref.watch(dashboardServiceProvider).getDashboard();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardResponse>(
  DashboardNotifier.new,
);
