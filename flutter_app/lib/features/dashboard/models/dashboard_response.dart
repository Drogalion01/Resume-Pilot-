import 'package:freezed_annotation/freezed_annotation.dart';

import '../../applications/models/application.dart';
import '../../interviews/models/interview.dart';
import '../../profile/models/user_profile.dart';
import '../../resume/models/resume_version.dart';

part 'dashboard_response.freezed.dart';
part 'dashboard_response.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DashboardResponse  ←  GET /api/v1/dashboard
//
// Verified against:
//   backend/app/schemas/dashboard.py → DashboardResponse
//   backend/app/services/dashboard_service.py → get_dashboard_data()
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class DashboardResponse with _$DashboardResponse {
  const factory DashboardResponse({
    required UserProfile user,
    required DashboardSummary summary,
    required DashboardInsight insight,
    @JsonKey(name: 'recent_resumes')
    @Default([])
    List<ResumeResponse> recentResumes,
    @JsonKey(name: 'upcoming_interviews')
    @Default([])
    List<InterviewResponse> upcomingInterviews,
    @JsonKey(name: 'recent_applications')
    @Default([])
    List<ApplicationResponse> recentApplications,
  }) = _DashboardResponse;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardSummary  ←  backend DashboardSummary
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    @JsonKey(name: 'total_resumes') required int totalResumes,
    @JsonKey(name: 'total_applications') required int totalApplications,
    @JsonKey(name: 'total_interviews') required int totalInterviews,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardInsight  ←  backend DashboardInsight
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class DashboardInsight with _$DashboardInsight {
  const factory DashboardInsight({
    /// e.g. "3 Active Applications"
    @JsonKey(name: 'trending_stat') required String trendingStat,
    String? description,
  }) = _DashboardInsight;

  factory DashboardInsight.fromJson(Map<String, dynamic> json) =>
      _$DashboardInsightFromJson(json);
}
