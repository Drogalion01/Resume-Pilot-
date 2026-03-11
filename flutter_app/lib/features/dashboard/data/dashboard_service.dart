import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../models/dashboard_response.dart';

class DashboardService {
  const DashboardService(this._dio);
  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  Future<DashboardResponse> getDashboard() =>
      _run(() async {
        final response =
            await _dio.get<Map<String, dynamic>>('/dashboard');
        return DashboardResponse.fromJson(response.data!);
      });
}

final dashboardServiceProvider = Provider<DashboardService>(
  (ref) => DashboardService(ref.watch(dioProvider)),
);
