import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../applications/providers/application_detail_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../data/interview_service.dart';
import '../models/interview.dart';

// ── Form state ────────────────────────────────────────────────────────────────

class InterviewFormState {
  const InterviewFormState({
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.prefill,
  });

  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final InterviewResponse? prefill; // non-null when editing

  InterviewFormState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    bool clearError = false,
    InterviewResponse? prefill,
  }) =>
      InterviewFormState(
        isLoading: isLoading ?? this.isLoading,
        isSaved: isSaved ?? this.isSaved,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        prefill: prefill ?? this.prefill,
      );
}

// ── Controller ────────────────────────────────────────────────────────────────

/// Handles add & edit form submission.
/// Family param: applicationId (needed to invalidate detail after mutation).
class InterviewFormNotifier extends FamilyNotifier<InterviewFormState, int> {
  @override
  InterviewFormState build(int applicationId) => const InterviewFormState();

  /// Load an existing interview for editing.
  Future<void> loadForEdit(int interviewId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final interview =
          await ref.read(interviewServiceProvider).getInterview(interviewId);
      state = state.copyWith(isLoading: false, prefill: interview);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load interview: ${e.toString()}',
      );
    }
  }

  /// Create a new interview.
  Future<bool> create({
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
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(interviewServiceProvider).createInterview(
            applicationId: arg,
            roundName: roundName,
            interviewType: interviewType,
            date: date,
            time: time,
            timezone: timezone,
            interviewerName: interviewerName,
            meetingLink: meetingLink,
            status: status,
            notes: notes,
            reminderEnabled: reminderEnabled,
          );
      ref.invalidate(applicationDetailProvider(arg));
      ref.invalidate(dashboardProvider);
      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save interview. Please try again.',
      );
      return false;
    }
  }

  /// Update an existing interview.
  Future<bool> update(
    int interviewId,
    Map<String, dynamic> fields,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref
          .read(interviewServiceProvider)
          .updateInterview(interviewId, fields);
      ref.invalidate(applicationDetailProvider(arg));
      ref.invalidate(dashboardProvider);
      state = state.copyWith(isLoading: false, isSaved: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update interview. Please try again.',
      );
      return false;
    }
  }
}

final interviewFormProvider =
    NotifierProviderFamily<InterviewFormNotifier, InterviewFormState, int>(
  InterviewFormNotifier.new,
);

// ── Quick-mutation helpers (used from InterviewsSection) ──────────────────────

/// Toggles reminder_enabled on an interview without opening the edit screen.
Future<void> toggleInterviewReminder(
  WidgetRef ref, {
  required int applicationId,
  required int interviewId,
  required bool enabled,
}) async {
  await ref
      .read(interviewServiceProvider)
      .updateInterview(interviewId, {'reminder_enabled': enabled});
  ref.invalidate(applicationDetailProvider(applicationId));
  ref.invalidate(dashboardProvider);
}

/// Updates the status of an interview.
Future<void> updateInterviewStatus(
  WidgetRef ref, {
  required int applicationId,
  required int interviewId,
  required InterviewStatus newStatus,
}) async {
  await ref
      .read(interviewServiceProvider)
      .updateInterview(interviewId, {'status': newStatus.name});
  ref.invalidate(applicationDetailProvider(applicationId));
  ref.invalidate(dashboardProvider);
}

/// Deletes an interview.
Future<void> deleteInterview(
  WidgetRef ref, {
  required int applicationId,
  required int interviewId,
}) async {
  await ref.read(interviewServiceProvider).deleteInterview(interviewId);
  ref.invalidate(applicationDetailProvider(applicationId));
  ref.invalidate(dashboardProvider);
}
