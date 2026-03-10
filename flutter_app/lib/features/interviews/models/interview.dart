import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interview.freezed.dart';
part 'interview.g.dart';

enum InterviewType {
  @JsonValue('phone')  phone,
  @JsonValue('video')  video,
  @JsonValue('onsite') onsite,
}

extension InterviewTypeX on InterviewType {
  String get displayName => switch (this) {
    InterviewType.phone  => 'Phone',
    InterviewType.video  => 'Video',
    InterviewType.onsite => 'On-site',
  };
  IconData get icon => switch (this) {
    InterviewType.phone  => Icons.phone_outlined,
    InterviewType.video  => Icons.videocam_outlined,
    InterviewType.onsite => Icons.business_outlined,
  };
}

enum InterviewStatus {
  @JsonValue('scheduled')    scheduled,
  @JsonValue('completed')    completed,
  @JsonValue('rescheduled')  rescheduled,
  @JsonValue('cancelled')    cancelled,
}

extension InterviewStatusX on InterviewStatus {
  String get displayName => switch (this) {
    InterviewStatus.scheduled   => 'Scheduled',
    InterviewStatus.completed   => 'Completed',
    InterviewStatus.rescheduled => 'Rescheduled',
    InterviewStatus.cancelled   => 'Cancelled',
  };
}

@freezed
class InterviewResponse with _$InterviewResponse {
  const factory InterviewResponse({
    required int id,
    @JsonKey(name: 'application_id')   required int applicationId,
    @JsonKey(name: 'round_name')       required String roundName,
    @JsonKey(name: 'interview_type')   required InterviewType interviewType,
    required DateTime date,
    String? time,
    String? timezone,
    @JsonKey(name: 'interviewer_name') String? interviewerName,
    @JsonKey(name: 'meeting_link')     String? meetingLink,
    required InterviewStatus status,
    String? notes,
    @JsonKey(name: 'reminder_enabled') required bool reminderEnabled,
    @JsonKey(name: 'created_at')       required DateTime createdAt,
    @JsonKey(name: 'updated_at')       required DateTime updatedAt,
  }) = _InterviewResponse;

  factory InterviewResponse.fromJson(Map<String, dynamic> json) =>
      _$InterviewResponseFromJson(json);
}

extension InterviewResponseX on InterviewResponse {
  TimeOfDay? get parsedTime {
    if (time == null) return null;
    final parts = time!.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
