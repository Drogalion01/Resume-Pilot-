import 'package:freezed_annotation/freezed_annotation.dart';

import '../../interviews/models/interview.dart';
import '../../resume/models/resume_version.dart';
import 'application.dart';
import 'reminder_note.dart';

part 'application_detail.freezed.dart';
part 'application_detail.g.dart';

@freezed
class ApplicationDetailResponse with _$ApplicationDetailResponse {
  const factory ApplicationDetailResponse({
    required ApplicationResponse application,
    @JsonKey(name: 'timeline_events')
    @Default([])
    List<TimelineEventResponse> timelineEvents,
    @Default([]) List<InterviewResponse> interviews,
    @Default([]) List<ReminderResponse> reminders,
    @Default([]) List<NoteResponse> notes,
    @JsonKey(name: 'resume_version') ResumeVersionResponse? resumeVersion,
  }) = _ApplicationDetailResponse;

  factory ApplicationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDetailResponseFromJson(json);
}
