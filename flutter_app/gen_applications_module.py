"""
ResumePilot Flutter — Applications module generator.
Run from flutter_app/ directory: python gen_applications_module.py
"""
import os

BASE = r"f:\Resume Pilot app\flutter_app\lib"

files = {}

# ─────────────────────────────────────────────────────────────────────────────
# 1. models/reminder_note.dart  — Reminder + Note + Timeline Freezed models
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/models/reminder_note.dart"] = r"""
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 2. models/application_detail.dart — ApplicationDetailResponse Freezed model
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/models/application_detail.dart"] = r"""
import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default([]) List<ReminderResponse> reminders,
    @Default([]) List<NoteResponse> notes,
    @JsonKey(name: 'resume_version') ResumeVersionResponse? resumeVersion,
  }) = _ApplicationDetailResponse;

  factory ApplicationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDetailResponseFromJson(json);
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 3. data/application_service.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/data/application_service.dart"] = r"""
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 4. providers/applications_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/providers/applications_provider.dart"] = r"""
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/application_service.dart';
import '../models/application.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class ApplicationsState {
  const ApplicationsState({
    this.applications = const [],
    this.activeFilter,
    this.searchQuery = '',
  });

  final List<ApplicationResponse> applications;
  final ApplicationStatus? activeFilter; // null = "All"
  final String searchQuery;

  ApplicationsState copyWith({
    List<ApplicationResponse>? applications,
    ApplicationStatus? activeFilter,
    bool clearFilter = false,
    String? searchQuery,
  }) =>
      ApplicationsState(
        applications: applications ?? this.applications,
        activeFilter:
            clearFilter ? null : (activeFilter ?? this.activeFilter),
        searchQuery: searchQuery ?? this.searchQuery,
      );

  List<ApplicationResponse> get filtered {
    var list = applications;
    if (activeFilter != null) {
      list = list.where((a) => a.status == activeFilter).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((a) =>
              a.companyName.toLowerCase().contains(q) ||
              a.role.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Map<ApplicationStatus, int> get statusCounts {
    final counts = <ApplicationStatus, int>{};
    for (final a in applications) {
      counts[a.status] = (counts[a.status] ?? 0) + 1;
    }
    return counts;
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ApplicationsNotifier extends AsyncNotifier<ApplicationsState> {
  @override
  Future<ApplicationsState> build() async {
    final apps =
        await ref.watch(applicationServiceProvider).getApplications();
    return ApplicationsState(applications: apps);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  void setFilter(ApplicationStatus? status) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(status == null
        ? current.copyWith(clearFilter: true)
        : current.copyWith(activeFilter: status));
  }

  void setSearch(String query) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(searchQuery: query));
  }

  Future<ApplicationResponse> addApplication(ApplicationCreate body) async {
    final svc = ref.read(applicationServiceProvider);
    final created = await svc.createApplication(body);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(
        applications: [created, ...current.applications],
      ));
    }
    return created;
  }

  Future<void> removeApplication(int id) async {
    await ref.read(applicationServiceProvider).deleteApplication(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(
        applications:
            current.applications.where((a) => a.id != id).toList(),
      ));
    }
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, ApplicationsState>(
  ApplicationsNotifier.new,
);
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 5. providers/application_detail_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/providers/application_detail_provider.dart"] = r"""
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/application_service.dart';
import '../models/application.dart';
import '../models/application_detail.dart';
import '../models/reminder_note.dart';

// ── Detail (mega-payload) ─────────────────────────────────────────────────────

class ApplicationDetailNotifier
    extends FamilyAsyncNotifier<ApplicationDetailResponse, int> {
  @override
  Future<ApplicationDetailResponse> build(int applicationId) =>
      ref.watch(applicationServiceProvider).getApplicationDetail(applicationId);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  // ── Status update ────────────────────────────────────────────────────────

  Future<void> updateStatus(ApplicationStatus newStatus) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref.read(applicationServiceProvider).updateApplication(
      current.application.id,
      {'status': newStatus.name == 'finalRound' ? 'final' : newStatus.name},
    );
    state = AsyncData(current.copyWith(
      application: updated,
    ));
  }

  // ── Reminders ────────────────────────────────────────────────────────────

  Future<void> addReminder({
    required String title,
    DateTime? scheduledFor,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final reminder = await ref.read(applicationServiceProvider).createReminder(
      current.application.id,
      title: title,
      scheduledFor: scheduledFor,
    );
    state = AsyncData(current.copyWith(
      reminders: [...current.reminders, reminder],
    ));
  }

  Future<void> toggleReminder(int reminderId, bool completed) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref
        .read(applicationServiceProvider)
        .updateReminder(reminderId, {'completed': completed});
    state = AsyncData(current.copyWith(
      reminders: current.reminders
          .map((r) => r.id == reminderId ? updated : r)
          .toList(),
    ));
  }

  Future<void> deleteReminder(int reminderId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await ref.read(applicationServiceProvider).deleteReminder(reminderId);
    state = AsyncData(current.copyWith(
      reminders: current.reminders.where((r) => r.id != reminderId).toList(),
    ));
  }

  // ── Notes ────────────────────────────────────────────────────────────────

  Future<void> saveNote(String content) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final note = await ref
        .read(applicationServiceProvider)
        .upsertNote(current.application.id, content);
    final existingIdx =
        current.notes.indexWhere((n) => n.id == note.id);
    final updatedNotes = existingIdx >= 0
        ? current.notes
            .map((n) => n.id == note.id ? note : n)
            .toList()
        : [...current.notes, note];
    state = AsyncData(current.copyWith(notes: updatedNotes));
  }

  // ── General field update ─────────────────────────────────────────────────

  Future<void> updateFields(Map<String, dynamic> fields) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref
        .read(applicationServiceProvider)
        .updateApplication(current.application.id, fields);
    state = AsyncData(current.copyWith(application: updated));
  }
}

final applicationDetailProvider = AsyncNotifierProviderFamily<
    ApplicationDetailNotifier, ApplicationDetailResponse, int>(
  ApplicationDetailNotifier.new,
);

// ── Add application form state ────────────────────────────────────────────────

class AddApplicationState {
  const AddApplicationState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  AddApplicationState copyWith({bool? isLoading, String? errorMessage}) =>
      AddApplicationState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

class AddApplicationNotifier extends AutoDisposeNotifier<AddApplicationState> {
  @override
  AddApplicationState build() => const AddApplicationState();

  Future<ApplicationResponse?> submit(ApplicationCreate body) async {
    state = state.copyWith(isLoading: true);
    try {
      final result =
          await ref.read(applicationServiceProvider).createApplication(body);
      ref.invalidate(applicationsProvider);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add application. Please try again.',
      );
      return null;
    }
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, ApplicationsState>(
  ApplicationsNotifier.new,
);

final addApplicationProvider =
    AutoDisposeNotifierProvider<AddApplicationNotifier, AddApplicationState>(
  AddApplicationNotifier.new,
);
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 6. widgets/application_states.dart — Loading/Error/Empty
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/widgets/application_states.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// List skeleton
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationListSkeleton extends StatelessWidget {
  const ApplicationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail skeleton
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationDetailSkeleton extends StatelessWidget {
  const ApplicationDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(double.infinity, 24),
            const SizedBox(height: 8),
            _box(180, 16),
            const SizedBox(height: 24),
            _box(double.infinity, 48, radius: 12),
            const SizedBox(height: 20),
            _box(120, 14),
            const SizedBox(height: 12),
            ..._bars(3, 56),
            const SizedBox(height: 20),
            _box(140, 14),
            const SizedBox(height: 12),
            ..._bars(2, 48),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double radius = 8}) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );

  List<Widget> _bars(int n, double h) => List.generate(
        n,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _box(double.infinity, h),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationsEmptyState extends StatelessWidget {
  const ApplicationsEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child:
                  Icon(Icons.work_outline, color: colors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'No applications yet',
              style: AppTextStyles.headline
                  .copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your job search by adding your first application.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Application'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationErrorState extends StatelessWidget {
  const ApplicationErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                color: colors.foregroundSecondary, size: 48),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.title.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 7. widgets/status_badge.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/widgets/status_badge.dart"] = r"""
import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';

extension ApplicationStatusColors on ApplicationStatus {
  Color foreground(AppColors c) => switch (this) {
        ApplicationStatus.saved       => c.statusSaved,
        ApplicationStatus.applied     => c.statusApplied,
        ApplicationStatus.assessment  => c.statusAssessment,
        ApplicationStatus.hr          => c.statusHr,
        ApplicationStatus.technical   => c.statusTechnical,
        ApplicationStatus.finalRound  => c.statusFinal,
        ApplicationStatus.offer       => c.statusOffer,
        ApplicationStatus.rejected    => c.statusRejected,
      };

  Color background(AppColors c) => switch (this) {
        ApplicationStatus.saved       => c.statusSavedBg,
        ApplicationStatus.applied     => c.statusAppliedBg,
        ApplicationStatus.assessment  => c.statusAssessmentBg,
        ApplicationStatus.hr          => c.statusHrBg,
        ApplicationStatus.technical   => c.statusTechnicalBg,
        ApplicationStatus.finalRound  => c.statusFinalBg,
        ApplicationStatus.offer       => c.statusOfferBg,
        ApplicationStatus.rejected    => c.statusRejectedBg,
      };
}

class ApplicationStatusBadge extends StatelessWidget {
  const ApplicationStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final ApplicationStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final fg = status.foreground(colors);
    final bg = status.background(colors);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(status.icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: AppTextStyles.micro
                .copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 8. widgets/timeline_widget.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/widgets/timeline_widget.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/reminder_note.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key, required this.events});

  final List<TimelineEventResponse> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No activity yet.',
          style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).appColors.foregroundSecondary),
        ),
      );
    }
    // Sort newest first
    final sorted = [...events]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      children: [
        for (var i = 0; i < sorted.length; i++)
          _TimelineItem(
            event: sorted[i],
            isLast: i == sorted.length - 1,
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});

  final TimelineEventResponse event;
  final bool isLast;

  static IconData _iconFor(String type) => switch (type) {
        'created'            => Icons.add_circle_outline,
        'status_change'      => Icons.swap_horiz_rounded,
        'reminder_added'     => Icons.alarm_add_outlined,
        'reminder_completed' => Icons.task_alt_outlined,
        'note_added'         => Icons.sticky_note_2_outlined,
        _                    => Icons.circle_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = DateFormat('MMM d, h:mm a').format(event.createdAt.toLocal());

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Line + dot column ─────────────────────────────────────────
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _iconFor(event.eventType),
                    size: 14,
                    color: colors.primary,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.borderSubtle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // ── Content ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600),
                  ),
                  if (event.detail != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.detail!,
                      style: AppTextStyles.caption
                          .copyWith(color: colors.foregroundSecondary),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    dateLabel,
                    style: AppTextStyles.micro
                        .copyWith(color: colors.foregroundTertiary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 9. widgets/reminders_widget.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/widgets/reminders_widget.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/reminder_note.dart';
import '../providers/application_detail_provider.dart';

class RemindersWidget extends ConsumerWidget {
  const RemindersWidget({
    super.key,
    required this.applicationId,
    required this.reminders,
  });

  final int applicationId;
  final List<ReminderResponse> reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final notifier =
        ref.read(applicationDetailProvider(applicationId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reminders.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              'No reminders set.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
            ),
          )
        else
          ...reminders.map(
            (r) => _ReminderTile(
              reminder: r,
              onToggle: (v) => notifier.toggleReminder(r.id, v),
              onDelete: () => notifier.deleteReminder(r.id),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () =>
              _showAddReminderSheet(context, notifier),
          icon: const Icon(Icons.alarm_add_outlined, size: 16),
          label: const Text('Add Reminder'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
        ),
      ],
    );
  }

  void _showAddReminderSheet(
      BuildContext context, ApplicationDetailNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddReminderSheet(notifier: notifier),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  final ReminderResponse reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = reminder.scheduledFor != null
        ? DateFormat('MMM d, h:mm a')
            .format(reminder.scheduledFor!.toLocal())
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: Checkbox(
            value: reminder.completed,
            onChanged: (v) => onToggle(v ?? false),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          title: Text(
            reminder.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground,
              decoration:
                  reminder.completed ? TextDecoration.lineThrough : null,
              color: reminder.completed
                  ? colors.foregroundSecondary
                  : colors.foreground,
            ),
          ),
          subtitle: dateLabel != null
              ? Text(
                  dateLabel,
                  style: AppTextStyles.micro
                      .copyWith(color: colors.foregroundTertiary),
                )
              : null,
          trailing: IconButton(
            icon: Icon(Icons.close_rounded,
                size: 18, color: colors.foregroundSecondary),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet({required this.notifier});

  final ApplicationDetailNotifier notifier;

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleCtrl = TextEditingController();
  DateTime? _scheduledFor;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await widget.notifier.addReminder(
      title: _titleCtrl.text.trim(),
      scheduledFor: _scheduledFor,
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    setState(() {
      _scheduledFor = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add Reminder',
              style: AppTextStyles.headline
                  .copyWith(color: colors.foreground)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Reminder',
              hintText: 'e.g. Follow up with recruiter',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDateTime,
            icon: const Icon(Icons.schedule_outlined, size: 16),
            label: Text(
              _scheduledFor != null
                  ? DateFormat('MMM d, h:mm a').format(_scheduledFor!)
                  : 'Set Date & Time (optional)',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed:
                _saving || _titleCtrl.text.trim().isEmpty ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Save Reminder'),
          ),
        ],
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 10. widgets/notes_editor.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/widgets/notes_editor.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/reminder_note.dart';
import '../providers/application_detail_provider.dart';

class NotesEditor extends ConsumerStatefulWidget {
  const NotesEditor({
    super.key,
    required this.applicationId,
    required this.notes,
  });

  final int applicationId;
  final List<NoteResponse> notes;

  @override
  ConsumerState<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends ConsumerState<NotesEditor> {
  late final TextEditingController _ctrl;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.notes.isNotEmpty ? widget.notes.first.content : '');
  }

  @override
  void didUpdateWidget(NotesEditor old) {
    super.didUpdateWidget(old);
    if (old.notes != widget.notes && !_editing) {
      _ctrl.text =
          widget.notes.isNotEmpty ? widget.notes.first.content : '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(applicationDetailProvider(widget.applicationId).notifier)
        .saveNote(_ctrl.text);
    setState(() {
      _saving = false;
      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_editing)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _ctrl,
                maxLines: 8,
                autofocus: true,
                style: AppTextStyles.body.copyWith(color: colors.foreground),
                decoration: const InputDecoration(
                  hintText: 'Write notes about this application…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _editing = false);
                        _ctrl.text = widget.notes.isNotEmpty
                            ? widget.notes.first.content
                            : '';
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          )
        else if (widget.notes.isNotEmpty &&
            widget.notes.first.content.isNotEmpty)
          GestureDetector(
            onTap: () => setState(() => _editing = true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notes.first.content,
                    style: AppTextStyles.body
                        .copyWith(color: colors.foreground),
                    maxLines: 6,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to edit',
                    style: AppTextStyles.micro
                        .copyWith(color: colors.foregroundTertiary),
                  ),
                ],
              ),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => setState(() => _editing = true),
            icon: const Icon(Icons.edit_note_outlined, size: 16),
            label: const Text('Add Notes'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40)),
          ),
      ],
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 11. screens/applications_tracker_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/screens/applications_tracker_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_states.dart';
import '../widgets/status_badge.dart';

class ApplicationsTrackerScreen extends ConsumerWidget {
  const ApplicationsTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final stateAsync = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 16)
                  .copyWith(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Applications',
                      style: AppTextStyles.headline
                          .copyWith(color: colors.foreground),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: colors.primary),
                    onPressed: () => context.push(AppRoutes.addApplication),
                  ),
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageH, vertical: 8),
              child: TextField(
                onChanged: (q) =>
                    ref.read(applicationsProvider.notifier).setSearch(q),
                decoration: InputDecoration(
                  hintText: 'Search company or role…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: colors.surfaceSecondary,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
              ),
            ),

            // ── Status filter chips ──────────────────────────────────────
            stateAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (s) => _StatusFilterRow(
                activeFilter: s.activeFilter,
                counts: s.statusCounts,
                onSelect: (status) =>
                    ref.read(applicationsProvider.notifier).setFilter(status),
              ),
            ),

            const SizedBox(height: 4),

            // ── List ─────────────────────────────────────────────────────
            Expanded(
              child: stateAsync.when(
                loading: () => const ApplicationListSkeleton(),
                error: (e, _) => ApplicationErrorState(
                  error: e,
                  onRetry: () => ref.invalidate(applicationsProvider),
                ),
                data: (s) {
                  final list = s.filtered;
                  if (list.isEmpty && s.applications.isEmpty) {
                    return ApplicationsEmptyState(
                      onAdd: () => context.push(AppRoutes.addApplication),
                    );
                  }
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No matching applications.',
                        style: AppTextStyles.caption.copyWith(
                            color: colors.foregroundSecondary),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(applicationsProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.pageH, vertical: 8),
                      itemCount: list.length,
                      itemBuilder: (_, i) =>
                          _ApplicationCard(app: list[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status filter row ─────────────────────────────────────────────────────────

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.activeFilter,
    required this.counts,
    required this.onSelect,
  });

  final ApplicationStatus? activeFilter;
  final Map<ApplicationStatus, int> counts;
  final ValueChanged<ApplicationStatus?> onSelect;

  static const _statuses = ApplicationStatus.values;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final total = counts.values.fold(0, (a, b) => a + b);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        children: [
          _Chip(
            label: 'All',
            count: total,
            active: activeFilter == null,
            foreground: colors.primary,
            background: colors.primaryLight,
            onTap: () => onSelect(null),
          ),
          ..._statuses.map((s) => _Chip(
                label: s.displayName,
                count: counts[s] ?? 0,
                active: activeFilter == s,
                foreground: s.foreground(colors),
                background: s.background(colors),
                onTap: () =>
                    onSelect(activeFilter == s ? null : s),
              )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active ? foreground : background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? foreground : foreground.withAlpha(60),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? Colors.white : foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: AppTextStyles.micro.copyWith(
                    color: active
                        ? Colors.white.withAlpha(180)
                        : foreground.withAlpha(180),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Application card ──────────────────────────────────────────────────────────

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app});

  final ApplicationResponse app;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = app.applicationDate != null
        ? DateFormat('MMM d, yyyy').format(app.applicationDate!)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card)),
      elevation: 0,
      color: colors.surfaceSecondary,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: () =>
            context.push(AppRoutes.applicationDetail(app.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.companyName,
                          style: AppTextStyles.title.copyWith(
                              color: colors.foreground),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          app.role,
                          style: AppTextStyles.caption.copyWith(
                              color: colors.foregroundSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ApplicationStatusBadge(status: app.status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (app.location != null) ...[
                    Icon(Icons.location_on_outlined,
                        size: 13, color: colors.foregroundTertiary),
                    const SizedBox(width: 3),
                    Text(
                      app.location!,
                      style: AppTextStyles.micro
                          .copyWith(color: colors.foregroundTertiary),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (dateLabel != null) ...[
                    Icon(Icons.calendar_today_outlined,
                        size: 13, color: colors.foregroundTertiary),
                    const SizedBox(width: 3),
                    Text(
                      dateLabel,
                      style: AppTextStyles.micro
                          .copyWith(color: colors.foregroundTertiary),
                    ),
                  ],
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: colors.foregroundSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 12. screens/add_application_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/screens/add_application_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../providers/application_detail_provider.dart';
import '../providers/applications_provider.dart';

class AddApplicationScreen extends ConsumerStatefulWidget {
  const AddApplicationScreen({super.key});

  @override
  ConsumerState<AddApplicationScreen> createState() =>
      _AddApplicationScreenState();
}

class _AddApplicationScreenState
    extends ConsumerState<AddApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyCtrl   = TextEditingController();
  final _roleCtrl      = TextEditingController();
  final _locationCtrl  = TextEditingController();
  final _sourceCtrl    = TextEditingController();
  final _recruiterCtrl = TextEditingController();

  ApplicationStatus _status = ApplicationStatus.saved;
  DateTime? _applicationDate;

  @override
  void dispose() {
    _companyCtrl.dispose();
    _roleCtrl.dispose();
    _locationCtrl.dispose();
    _sourceCtrl.dispose();
    _recruiterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _applicationDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = ApplicationCreate(
      companyName:     _companyCtrl.text.trim(),
      role:            _roleCtrl.text.trim(),
      status:          _status,
      applicationDate: _applicationDate,
      location:  _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
      source:    _sourceCtrl.text.trim().isEmpty ? null : _sourceCtrl.text.trim(),
      recruiterName: _recruiterCtrl.text.trim().isEmpty ? null : _recruiterCtrl.text.trim(),
    );

    final notifier = ref.read(addApplicationProvider.notifier);
    final result = await notifier.submit(body);
    if (!mounted) return;
    if (result != null) {
      context.pop();
      context.push(AppRoutes.applicationDetail(result.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors   = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final formState = ref.watch(addApplicationProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  gradient: AppGradients.heroBackground(colors)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ── AppBar ───────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: colors.foreground, size: 22),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Application',
                        style: AppTextStyles.headline
                            .copyWith(color: colors.foreground),
                      ),
                    ],
                  ),
                ),

                // ── Form ─────────────────────────────────────────────────
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfacePrimary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      boxShadow: AppShadows.elevated(brightness),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.pageH, vertical: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Required fields
                              TextFormField(
                                controller: _companyCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Company *',
                                  hintText: 'e.g. Google',
                                  prefixIcon: Icon(Icons.business_outlined),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _roleCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Role *',
                                  hintText: 'e.g. Software Engineer',
                                  prefixIcon: Icon(Icons.work_outline),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // Status picker
                              Text(
                                'Status',
                                style: AppTextStyles.title
                                    .copyWith(color: colors.foreground),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ApplicationStatus.values.map((s) {
                                  final active = _status == s;
                                  final fg = s.foreground(colors);
                                  final bg = s.background(colors);
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _status = s),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: active ? fg : bg,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: active
                                              ? fg
                                              : fg.withAlpha(60),
                                        ),
                                      ),
                                      child: Text(
                                        s.displayName,
                                        style: AppTextStyles.micro.copyWith(
                                          color: active ? Colors.white : fg,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 20),

                              // Optional fields
                              Text(
                                'Details (Optional)',
                                style: AppTextStyles.title
                                    .copyWith(color: colors.foreground),
                              ),
                              const SizedBox(height: 12),
                              _OptField(
                                  ctrl: _locationCtrl,
                                  label: 'Location',
                                  hint: 'e.g. Remote / New York, NY',
                                  icon: Icons.location_on_outlined),
                              const SizedBox(height: 10),
                              _OptField(
                                  ctrl: _sourceCtrl,
                                  label: 'Source',
                                  hint: 'e.g. LinkedIn, Referral',
                                  icon: Icons.link_rounded),
                              const SizedBox(height: 10),
                              _OptField(
                                  ctrl: _recruiterCtrl,
                                  label: 'Recruiter Name',
                                  hint: 'e.g. Jane Smith',
                                  icon: Icons.person_outline),
                              const SizedBox(height: 10),

                              // Date picker
                              OutlinedButton.icon(
                                onPressed: _pickDate,
                                icon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16),
                                label: Text(
                                  _applicationDate != null
                                      ? 'Applied: ${DateFormat('MMM d, yyyy').format(_applicationDate!)}'
                                      : 'Set Application Date',
                                ),
                              ),

                              if (formState.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.statusRejectedBg,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    formState.errorMessage!,
                                    style: AppTextStyles.caption.copyWith(
                                        color: colors.statusRejected),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              FilledButton(
                                onPressed:
                                    formState.isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(
                                      AppSpacing.buttonH),
                                ),
                                child: formState.isLoading
                                    ? const SizedBox.square(
                                        dimension: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white))
                                    : const Text('Add Application'),
                              ),

                              SizedBox(
                                  height: AppSpacing.bottomNavH +
                                      AppSpacing.cardPad),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptField extends StatelessWidget {
  const _OptField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      );
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 13. screens/application_detail_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/applications/screens/application_detail_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../models/reminder_note.dart';
import '../providers/application_detail_provider.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_states.dart';
import '../widgets/notes_editor.dart';
import '../widgets/reminders_widget.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_widget.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({super.key, required this.applicationId});

  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors     = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final detailAsync =
        ref.watch(applicationDetailProvider(applicationId));

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Gradient bg
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  gradient: AppGradients.heroBackground(colors)),
            ),
          ),
          Positioned(
            top: -40, right: -40,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.heroGlow1(colors),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── AppBar ───────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: colors.foreground, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: detailAsync.maybeWhen(
                          data: (d) => Text(
                            d.application.companyName,
                            style: AppTextStyles.headline
                                .copyWith(color: colors.foreground),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                      // Delete button
                      detailAsync.maybeWhen(
                        data: (d) => IconButton(
                          icon: Icon(Icons.delete_outline_rounded,
                              color: colors.destructive, size: 22),
                          onPressed: () =>
                              _confirmDelete(context, ref),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                // ── Content ──────────────────────────────────────────────
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfacePrimary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      boxShadow: AppShadows.elevated(brightness),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      child: detailAsync.when(
                        loading: () =>
                            const ApplicationDetailSkeleton(),
                        error: (e, _) => ApplicationErrorState(
                          error: e,
                          onRetry: () => ref.invalidate(
                              applicationDetailProvider(applicationId)),
                        ),
                        data: (detail) => _DetailContent(
                          detail: detail,
                          applicationId: applicationId,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text(
            'Are you sure you want to delete this application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).appColors.destructive),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await ref
          .read(applicationsProvider.notifier)
          .removeApplication(applicationId);
      if (context.mounted) context.pop();
    }
  }
}

// ── Detail content ─────────────────────────────────────────────────────────────

class _DetailContent extends ConsumerWidget {
  const _DetailContent({
    required this.detail,
    required this.applicationId,
  });

  final detail;
  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final app    = detail.application;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // ── Hero header ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.role,
                            style: AppTextStyles.display
                                .copyWith(color: colors.foreground),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.companyName,
                            style: AppTextStyles.title
                                .copyWith(color: colors.foregroundSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ApplicationStatusBadge(status: app.status),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (app.location != null)
                      _MetaTag(
                        icon: Icons.location_on_outlined,
                        label: app.location!,
                        colors: colors,
                      ),
                    if (app.applicationDate != null)
                      _MetaTag(
                        icon: Icons.calendar_today_outlined,
                        label: DateFormat('MMM d, yyyy')
                            .format(app.applicationDate!),
                        colors: colors,
                      ),
                    if (app.source != null)
                      _MetaTag(
                        icon: Icons.link_rounded,
                        label: app.source!,
                        colors: colors,
                      ),
                    if (app.recruiterName != null)
                      _MetaTag(
                        icon: Icons.person_outline,
                        label: app.recruiterName!,
                        colors: colors,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Status change ────────────────────────────────────────────────
        _Section(
          title: 'Update Status',
          child: _StatusPicker(
            current: app.status,
            applicationId: applicationId,
          ),
        ),

        // ── Timeline ────────────────────────────────────────────────────
        _Section(
          title: 'Activity',
          child: TimelineWidget(events: detail.timelineEvents),
        ),

        // ── Linked resume ────────────────────────────────────────────────
        if (detail.resumeVersion != null)
          _Section(
            title: 'Linked Resume',
            child: _LinkedResumeTile(
              version: detail.resumeVersion!,
              colors: colors,
            ),
          ),

        // ── Reminders ────────────────────────────────────────────────────
        _Section(
          title: 'Reminders',
          child: RemindersWidget(
            applicationId: applicationId,
            reminders: detail.reminders,
          ),
        ),

        // ── Notes ────────────────────────────────────────────────────────
        _Section(
          title: 'Notes',
          child: NotesEditor(
            applicationId: applicationId,
            notes: detail.notes,
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
              height: AppSpacing.bottomNavH + AppSpacing.cardPad),
        ),
      ],
    );
  }
}

// ── Section wrapper ───────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pageH, vertical: 0)
            .copyWith(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  AppTextStyles.title.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Meta tag ──────────────────────────────────────────────────────────────────

class _MetaTag extends StatelessWidget {
  const _MetaTag({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.foregroundSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: colors.foregroundSecondary),
          ),
        ],
      );
}

// ── Status picker ─────────────────────────────────────────────────────────────

class _StatusPicker extends ConsumerWidget {
  const _StatusPicker({required this.current, required this.applicationId});

  final ApplicationStatus current;
  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ApplicationStatus.values.map((s) {
        final active = current == s;
        final fg = s.foreground(colors);
        final bg = s.background(colors);
        return GestureDetector(
          onTap: active
              ? null
              : () => ref
                  .read(applicationDetailProvider(applicationId).notifier)
                  .updateStatus(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active ? fg : bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: active ? fg : fg.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(s.icon,
                    size: 13,
                    color: active ? Colors.white : fg),
                const SizedBox(width: 5),
                Text(
                  s.displayName,
                  style: AppTextStyles.micro.copyWith(
                    color: active ? Colors.white : fg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Linked resume tile ────────────────────────────────────────────────────────

class _LinkedResumeTile extends StatelessWidget {
  const _LinkedResumeTile({required this.version, required this.colors});

  final version;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
          AppRoutes.resumeDetail(version.resumeId ?? version.id)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: colors.primary.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined,
                color: colors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    version.versionName ??
                        version.targetRole ??
                        'Resume Version',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (version.targetRole != null)
                    Text(
                      version.targetRole!,
                      style: AppTextStyles.caption
                          .copyWith(color: colors.foregroundSecondary),
                    ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded,
                size: 16, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# Write all files
# ─────────────────────────────────────────────────────────────────────────────
for rel_path, content in files.items():
    abs_path = os.path.join(BASE, rel_path)
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)
    with open(abs_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"  wrote  {rel_path}")

print(f"\nDone — {len(files)} files written.")
