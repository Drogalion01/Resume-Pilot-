import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../../applications/models/reminder_note.dart';

/// Dio calls for all reminder endpoints.
/// Verified against backend/app/routes/reminders.py.
class ReminderService {
  const ReminderService(this._dio);

  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  // ── List ──────────────────────────────────────────────────────────────────

  /// GET /reminders — all reminders for the current user across all apps,
  /// ordered by scheduled_for asc (backend handles sort).
  Future<List<ReminderResponse>> getReminders() async {
    return _run(() async {
      final res = await _dio.get<List<dynamic>>('reminders');
      return res.data!
          .map((e) => ReminderResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  // ── Create ────────────────────────────────────────────────────────────────

  /// POST /applications/{applicationId}/reminders
  /// Server auto-logs a timeline event on creation.
  Future<ReminderResponse> createReminder(
    int applicationId, {
    required String title,
    DateTime? scheduledFor,
    bool completed = false,
    bool isEnabled = true,
  }) async {
    return _run(() async {
      final res = await _dio.post<Map<String, dynamic>>(
        'applications/$applicationId/reminders',
        data: {
          'title': title,
          if (scheduledFor != null)
            'scheduled_for': scheduledFor.toIso8601String(),
          'completed': completed,
          'is_enabled': isEnabled,
        },
      );
      return ReminderResponse.fromJson(res.data!);
    });
  }

  // ── Update ────────────────────────────────────────────────────────────────

  /// PATCH /reminders/{id} — partial update (mark complete, reschedule, etc).
  Future<ReminderResponse> updateReminder(
    int reminderId,
    Map<String, dynamic> fields,
  ) async {
    return _run(() async {
      final res = await _dio.patch<Map<String, dynamic>>(
        'reminders/$reminderId',
        data: fields,
      );
      return ReminderResponse.fromJson(res.data!);
    });
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  /// DELETE /reminders/{id}
  Future<void> deleteReminder(int reminderId) async {
    return _run(() async {
      await _dio.delete('reminders/$reminderId');
    });
  }
}

final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(ref.watch(dioProvider)),
);
