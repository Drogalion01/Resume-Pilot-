import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/dashboard_response.dart';

class DashboardService {
  const DashboardService(this._dio);
  final Dio _dio;

  Future<DashboardResponse> getDashboard() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/dashboard');
    return DashboardResponse.fromJson(response.data!);
  }
}

final dashboardServiceProvider = Provider<DashboardService>(
  (ref) => DashboardService(ref.watch(dioProvider)),
);
