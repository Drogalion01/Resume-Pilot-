import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../models/user_settings.dart';

class SettingsService {
  const SettingsService(this._dio);
  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  /// GET /user/settings  →  UserSettings
  Future<UserSettings> getSettings() =>
      _run(() async {
        final res = await _dio.get<Map<String, dynamic>>('/user/settings');
        return UserSettings.fromJson(res.data!);
      });

  /// PATCH /user/settings  →  UserSettings
  Future<UserSettings> updateSettings(Map<String, dynamic> fields) =>
      _run(() async {
        final res = await _dio.patch<Map<String, dynamic>>(
          '/user/settings',
          data: fields,
        );
        return UserSettings.fromJson(res.data!);
      });
}

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref.watch(dioProvider)),
);
