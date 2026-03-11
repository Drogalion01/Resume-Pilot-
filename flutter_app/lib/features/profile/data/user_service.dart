import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../models/user_profile.dart';

class UserService {
  const UserService(this._dio);
  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  /// GET /user/me  →  UserProfile
  Future<UserProfile> getProfile() =>
      _run(() async {
        final res = await _dio.get<Map<String, dynamic>>('/user/me');
        return UserProfile.fromJson(res.data!);
      });

  /// PUT /user/me  →  UserProfile (full replacement via JsonKey fields)
  Future<UserProfile> updateProfile(Map<String, dynamic> fields) =>
      _run(() async {
        final res = await _dio.put<Map<String, dynamic>>(
          '/user/me',
          data: fields,
        );
        return UserProfile.fromJson(res.data!);
      });
}

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.watch(dioProvider)),
);
