import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../models/interview.dart';

class InterviewService {
  const InterviewService(this._dio);
  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  /// GET /interviews/{id}
  Future<InterviewResponse> getInterview(int id) async {
    return _run(() async {
      final res = await _dio.get<Map<String, dynamic>>('/interviews/$id');
      return InterviewResponse.fromJson(res.data!);
    });
  }

  /// POST /applications/{applicationId}/interviews
  /// [date] → "YYYY-MM-DD"   [time] → "HH:mm:ss" or null
  Future<InterviewResponse> createInterview({
    required int applicationId,
    required String roundName,
    required InterviewType interviewType,
    required DateTime date,
    TimeOfDay? time,
    String? timezone,
    String? interviewerName,
    String? meetingLink,
    InterviewStatus status = InterviewStatus.scheduled,
    String? notes,
    bool reminderEnabled = false,
  }) async {
    return _run(() async {
      final res = await _dio.post<Map<String, dynamic>>(
        '/applications/$applicationId/interviews',
        data: {
          'round_name': roundName,
          'interview_type': interviewType.name,
          'date': _fmtDate(date),
          if (time != null) 'time': _fmtTime(time),
          if (timezone != null) 'timezone': timezone,
          if (interviewerName != null) 'interviewer_name': interviewerName,
          if (meetingLink != null) 'meeting_link': meetingLink,
          'status': status.name,
          if (notes != null) 'notes': notes,
          'reminder_enabled': reminderEnabled,
        },
      );
      return InterviewResponse.fromJson(res.data!);
    });
  }

  /// PATCH /interviews/{id}  — partial update
  Future<InterviewResponse> updateInterview(
    int id,
    Map<String, dynamic> fields,
  ) async {
    return _run(() async {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/interviews/$id',
        data: fields,
      );
      return InterviewResponse.fromJson(res.data!);
    });
  }

  /// DELETE /interviews/{id}
  Future<void> deleteInterview(int id) async {
    return _run(() async {
      await _dio.delete('/interviews/$id');
    });
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  /// "YYYY-MM-DD"
  static String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}'
      '-${d.month.toString().padLeft(2, '0')}'
      '-${d.day.toString().padLeft(2, '0')}';

  /// "HH:mm:ss"
  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}'
      ':${t.minute.toString().padLeft(2, '0')}'
      ':00';

  /// Expose formatters for use in provider / screen
  static String formatDate(DateTime d) => _fmtDate(d);
  static String formatTime(TimeOfDay t) => _fmtTime(t);
}

final interviewServiceProvider = Provider<InterviewService>(
  (ref) => InterviewService(ref.watch(dioProvider)),
);
