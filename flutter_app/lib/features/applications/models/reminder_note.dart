import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_note.freezed.dart';
part 'reminder_note.g.dart';

// ── Reminder ──────────────────────────────────────────────────────────────────

@freezed
class ReminderResponse with _$ReminderResponse {
  const factory ReminderResponse({
    required int id,
    @JsonKey(name: 'application_id') required int applicationId,
    required String title,
    @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
    @Default(false) bool completed,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ReminderResponse;

  factory ReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$ReminderResponseFromJson(json);
}

// ── Note ──────────────────────────────────────────────────────────────────────

@freezed
class NoteResponse with _$NoteResponse {
  const factory NoteResponse({
    required int id,
    @JsonKey(name: 'application_id') required int applicationId,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NoteResponse;

  factory NoteResponse.fromJson(Map<String, dynamic> json) =>
      _$NoteResponseFromJson(json);
}

// ── Timeline Event ─────────────────────────────────────────────────────────────

@freezed
class TimelineEventResponse with _$TimelineEventResponse {
  const factory TimelineEventResponse({
    required int id,
    @JsonKey(name: 'application_id') required int applicationId,
    @JsonKey(name: 'event_type') required String eventType,
    required String title,
    String? detail,
    DateTime? timestamp,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TimelineEventResponse;

  factory TimelineEventResponse.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventResponseFromJson(json);
}
