import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/user_profile.dart';

class UserService {
  const UserService(this._dio);
  final Dio _dio;

  /// GET /user/me  →  UserProfile
  Future<UserProfile> getProfile() async {
    final res = await _dio.get<Map<String, dynamic>>('/user/me');
    return UserProfile.fromJson(res.data!);
  }

  /// PUT /user/me  →  UserProfile (full replacement via JsonKey fields)
  Future<UserProfile> updateProfile(Map<String, dynamic> fields) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/user/me',
      data: fields,
    );
    return UserProfile.fromJson(res.data!);
  }
}

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.watch(dioProvider)),
);
