import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/user_settings.dart';

class SettingsService {
  const SettingsService(this._dio);
  final Dio _dio;

  /// GET /user/settings  →  UserSettings
  Future<UserSettings> getSettings() async {
    final res = await _dio.get<Map<String, dynamic>>('/user/settings');
    return UserSettings.fromJson(res.data!);
  }

  /// PATCH /user/settings  →  UserSettings
  Future<UserSettings> updateSettings(Map<String, dynamic> fields) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/user/settings',
      data: fields,
    );
    return UserSettings.fromJson(res.data!);
  }
}

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref.watch(dioProvider)),
);
