import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/application.dart';
import '../models/application_detail.dart';
import '../models/reminder_note.dart';

class ApplicationService {
  const ApplicationService(this._dio);

  final Dio _dio;

  // ── Applications CRUD ──────────────────────────────────────────────────────

  Future<List<ApplicationResponse>> getApplications() async {
    final res = await _dio.get<List<dynamic>>('/applications');
    return res.data!
        .map((e) => ApplicationResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ApplicationDetailResponse> getApplicationDetail(int id) async {
    final res =
        await _dio.get<Map<String, dynamic>>('/applications/$id');
    return ApplicationDetailResponse.fromJson(res.data!);
  }

  Future<ApplicationResponse> createApplication(ApplicationCreate body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/applications',
      data: body.toJson(),
    );
    return ApplicationResponse.fromJson(res.data!);
  }

  Future<ApplicationResponse> updateApplication(
    int id,
    Map<String, dynamic> fields,
  ) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/applications/$id',
      data: fields,
    );
    return ApplicationResponse.fromJson(res.data!);
  }

  Future<void> deleteApplication(int id) async {
    await _dio.delete('/applications/$id');
  }

  // ── Reminders ──────────────────────────────────────────────────────────────

  Future<ReminderResponse> createReminder(
    int applicationId, {
    required String title,
    DateTime? scheduledFor,
    bool completed = false,
    bool isEnabled = true,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/applications/$applicationId/reminders',
      data: {
        'title': title,
        if (scheduledFor != null)
          'scheduled_for': scheduledFor.toIso8601String(),
        'completed': completed,
        'is_enabled': isEnabled,
      },
    );
    return ReminderResponse.fromJson(res.data!);
  }

  Future<ReminderResponse> updateReminder(
    int reminderId,
    Map<String, dynamic> fields,
  ) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/reminders/$reminderId',
      data: fields,
    );
    return ReminderResponse.fromJson(res.data!);
  }

  Future<void> deleteReminder(int reminderId) async {
    await _dio.delete('/reminders/$reminderId');
  }

  // ── Notes (upsert) ─────────────────────────────────────────────────────────

  Future<NoteResponse> upsertNote(int applicationId, String content) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/applications/$applicationId/notes',
      data: {'content': content},
    );
    return NoteResponse.fromJson(res.data!);
  }
}

final applicationServiceProvider = Provider<ApplicationService>(
  (ref) => ApplicationService(ref.watch(dioProvider)),
);
