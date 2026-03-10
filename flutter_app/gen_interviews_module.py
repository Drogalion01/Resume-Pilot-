"""
ResumePilot Flutter — Interviews module generator.
Run from flutter_app/ directory: python gen_interviews_module.py
"""
import os

BASE = r"f:\Resume Pilot app\flutter_app\lib"

files = {}

# ─────────────────────────────────────────────────────────────────────────────
# 1. data/interview_service.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/interviews/data/interview_service.dart"] = r"""
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/interview.dart';

class InterviewService {
  const InterviewService(this._dio);
  final Dio _dio;

  /// GET /interviews/{id}
  Future<InterviewResponse> getInterview(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/interviews/$id');
    return InterviewResponse.fromJson(res.data!);
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
  }

  /// PATCH /interviews/{id}  — partial update
  Future<InterviewResponse> updateInterview(
    int id,
    Map<String, dynamic> fields,
  ) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/interviews/$id',
      data: fields,
    );
    return InterviewResponse.fromJson(res.data!);
  }

  /// DELETE /interviews/{id}
  Future<void> deleteInterview(int id) async {
    await _dio.delete('/interviews/$id');
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 2. providers/interviews_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/interviews/providers/interviews_provider.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../applications/models/application_detail.dart';
import '../../applications/providers/application_detail_provider.dart';
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
class InterviewFormNotifier
    extends FamilyNotifier<InterviewFormState, int> {
  @override
  InterviewFormState build(int applicationId) =>
      const InterviewFormState();

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
        applicationId: applicationId,
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
      ref.invalidate(applicationDetailProvider(applicationId));
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
      ref.invalidate(applicationDetailProvider(applicationId));
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
}

/// Updates the status of an interview.
Future<void> updateInterviewStatus(
  WidgetRef ref, {
  required int applicationId,
  required int interviewId,
  required InterviewStatus newStatus,
}) async {
  await ref.read(interviewServiceProvider).updateInterview(
      interviewId, {'status': newStatus.name});
  ref.invalidate(applicationDetailProvider(applicationId));
}

/// Deletes an interview.
Future<void> deleteInterview(
  WidgetRef ref, {
  required int applicationId,
  required int interviewId,
}) async {
  await ref.read(interviewServiceProvider).deleteInterview(interviewId);
  ref.invalidate(applicationDetailProvider(applicationId));
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 3. widgets/interview_card.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/interviews/widgets/interview_card.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/interview.dart';
import '../providers/interviews_provider.dart';

class InterviewCard extends ConsumerWidget {
  const InterviewCard({
    super.key,
    required this.interview,
    required this.applicationId,
  });

  final InterviewResponse interview;
  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors   = Theme.of(context).appColors;
    final dateLabel = DateFormat('EEE, MMM d yyyy').format(interview.date);
    final timeLabel = interview.parsedTime != null
        ? interview.parsedTime!.format(context)
        : null;

    final (statusColor, statusBg) = _statusColors(interview.status, colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    interview.interviewType.icon,
                    size: 18,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interview.roundName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        interview.interviewType.displayName,
                        style: AppTextStyles.caption
                            .copyWith(color: colors.foregroundSecondary),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    interview.status.displayName,
                    style: AppTextStyles.micro.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Date/time row ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 14,
              runSpacing: 4,
              children: [
                _MetaChip(
                  icon: Icons.calendar_today_outlined,
                  label: dateLabel,
                  colors: colors,
                ),
                if (timeLabel != null)
                  _MetaChip(
                    icon: Icons.schedule_outlined,
                    label: timeLabel,
                    colors: colors,
                  ),
                if (interview.interviewerName != null)
                  _MetaChip(
                    icon: Icons.person_outline,
                    label: interview.interviewerName!,
                    colors: colors,
                  ),
              ],
            ),
          ),

          // ── Notes preview ────────────────────────────────────────────
          if (interview.notes != null &&
              interview.notes!.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                interview.notes!,
                style: AppTextStyles.caption
                    .copyWith(color: colors.foregroundSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          const Divider(height: 1, thickness: 1),

          // ── Action row ───────────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                // Reminder toggle
                _ReminderToggle(
                  interview: interview,
                  applicationId: applicationId,
                ),
                const Spacer(),
                // Edit
                TextButton.icon(
                  onPressed: () => context.push(
                      AppRoutes.editInterview(applicationId, interview.id)),
                  icon: Icon(Icons.edit_outlined,
                      size: 15, color: colors.primary),
                  label: Text(
                    'Edit',
                    style: AppTextStyles.caption
                        .copyWith(color: colors.primary),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                  ),
                ),
                // Delete
                _DeleteButton(
                  interview: interview,
                  applicationId: applicationId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _statusColors(InterviewStatus s, AppColors c) =>
      switch (s) {
        InterviewStatus.scheduled   => (c.statusApplied, c.statusAppliedBg),
        InterviewStatus.completed   => (c.statusOffer, c.statusOfferBg),
        InterviewStatus.rescheduled => (c.statusAssessment, c.statusAssessmentBg),
        InterviewStatus.cancelled   => (c.statusRejected, c.statusRejectedBg),
      };
}

// ── Reminder toggle ───────────────────────────────────────────────────────────

class _ReminderToggle extends ConsumerStatefulWidget {
  const _ReminderToggle({
    required this.interview,
    required this.applicationId,
  });

  final InterviewResponse interview;
  final int applicationId;

  @override
  ConsumerState<_ReminderToggle> createState() => _ReminderToggleState();
}

class _ReminderToggleState extends ConsumerState<_ReminderToggle> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_loading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colors.primary),
            ),
          )
        else
          Switch.adaptive(
            value: widget.interview.reminderEnabled,
            onChanged: (v) async {
              setState(() => _loading = true);
              await toggleInterviewReminder(
                ref,
                applicationId: widget.applicationId,
                interviewId: widget.interview.id,
                enabled: v,
              );
              if (mounted) setState(() => _loading = false);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        const SizedBox(width: 2),
        Text(
          'Reminder',
          style: AppTextStyles.micro
              .copyWith(color: colors.foregroundSecondary),
        ),
      ],
    );
  }
}

// ── Delete button ─────────────────────────────────────────────────────────────

class _DeleteButton extends ConsumerStatefulWidget {
  const _DeleteButton({
    required this.interview,
    required this.applicationId,
  });

  final InterviewResponse interview;
  final int applicationId;

  @override
  ConsumerState<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends ConsumerState<_DeleteButton> {
  bool _loading = false;

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Interview'),
        content: Text(
            'Remove "${widget.interview.roundName}" interview?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(ctx).appColors.destructive),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() => _loading = true);
      await deleteInterview(
        ref,
        applicationId: widget.applicationId,
        interviewId: widget.interview.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return _loading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: colors.destructive),
            ),
          )
        : IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 18, color: colors.destructive),
            onPressed: _confirmDelete,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          );
  }
}

// ── Meta chip ─────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  const _MetaChip({
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
          Icon(icon, size: 13, color: colors.foregroundSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: colors.foregroundSecondary),
          ),
        ],
      );
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 4. widgets/interviews_section.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/interviews/widgets/interviews_section.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/interview.dart';
import 'interview_card.dart';

class InterviewsSection extends StatelessWidget {
  const InterviewsSection({
    super.key,
    required this.applicationId,
    required this.interviews,
  });

  final int applicationId;
  final List<InterviewResponse> interviews;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    // Sort: upcoming first, then past, then cancelled
    final sorted = [...interviews]..sort((a, b) {
        final rank = _rank(a.status);
        final rankB = _rank(b.status);
        if (rank != rankB) return rank.compareTo(rankB);
        return a.date.compareTo(b.date);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sorted.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 8),
            child: Text(
              'No interviews scheduled.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
            ),
          )
        else
          ...sorted.map(
            (iv) => InterviewCard(
              interview: iv,
              applicationId: applicationId,
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () =>
              context.push(AppRoutes.addInterview(applicationId)),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Schedule Interview'),
          style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40)),
        ),
      ],
    );
  }

  int _rank(InterviewStatus s) => switch (s) {
        InterviewStatus.scheduled   => 0,
        InterviewStatus.rescheduled => 1,
        InterviewStatus.completed   => 2,
        InterviewStatus.cancelled   => 3,
      };
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 5. screens/add_interview_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/interviews/screens/add_interview_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../data/interview_service.dart';
import '../models/interview.dart';
import '../providers/interviews_provider.dart';

class AddInterviewScreen extends ConsumerStatefulWidget {
  const AddInterviewScreen({
    super.key,
    required this.applicationId,
    this.interviewId, // non-null → edit mode
  });

  final int applicationId;
  final int? interviewId;

  @override
  ConsumerState<AddInterviewScreen> createState() =>
      _AddInterviewScreenState();
}

class _AddInterviewScreenState extends ConsumerState<AddInterviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final _roundNameCtrl    = TextEditingController();
  final _interviewerCtrl  = TextEditingController();
  final _linkCtrl         = TextEditingController();
  final _timezoneCtrl     = TextEditingController();
  final _notesCtrl        = TextEditingController();

  InterviewType    _type     = InterviewType.video;
  InterviewStatus  _status   = InterviewStatus.scheduled;
  DateTime?        _date;
  TimeOfDay?       _time;
  bool             _reminder = false;
  bool             _initialised = false;

  bool get _isEdit => widget.interviewId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(interviewFormProvider(widget.applicationId).notifier)
            .loadForEdit(widget.interviewId!);
      });
    }
  }

  @override
  void dispose() {
    _roundNameCtrl.dispose();
    _interviewerCtrl.dispose();
    _linkCtrl.dispose();
    _timezoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _prefillFromState(InterviewResponse iv) {
    if (_initialised) return;
    _initialised = true;
    _roundNameCtrl.text   = iv.roundName;
    _interviewerCtrl.text = iv.interviewerName ?? '';
    _linkCtrl.text        = iv.meetingLink ?? '';
    _timezoneCtrl.text    = iv.timezone ?? '';
    _notesCtrl.text       = iv.notes ?? '';
    _type    = iv.interviewType;
    _status  = iv.status;
    _date    = iv.date;
    _time    = iv.parsedTime;
    _reminder = iv.reminderEnabled;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an interview date.')),
      );
      return;
    }

    final notifier =
        ref.read(interviewFormProvider(widget.applicationId).notifier);

    bool ok;
    if (_isEdit) {
      // Build partial-update payload
      final fields = <String, dynamic>{
        'round_name':      _roundNameCtrl.text.trim(),
        'interview_type':  _type.name,
        'date':            InterviewService.formatDate(_date!),
        if (_time != null) 'time': InterviewService.formatTime(_time!),
        if (_timezoneCtrl.text.trim().isNotEmpty)
          'timezone': _timezoneCtrl.text.trim(),
        if (_interviewerCtrl.text.trim().isNotEmpty)
          'interviewer_name': _interviewerCtrl.text.trim(),
        if (_linkCtrl.text.trim().isNotEmpty)
          'meeting_link': _linkCtrl.text.trim(),
        'status':           _status.name,
        'notes':            _notesCtrl.text.trim().isEmpty
            ? null
            : _notesCtrl.text.trim(),
        'reminder_enabled': _reminder,
      };
      ok = await notifier.update(widget.interviewId!, fields);
    } else {
      ok = await notifier.create(
        roundName:       _roundNameCtrl.text.trim(),
        interviewType:   _type,
        date:            _date!,
        time:            _time,
        timezone:        _timezoneCtrl.text.trim().isEmpty
            ? null
            : _timezoneCtrl.text.trim(),
        interviewerName: _interviewerCtrl.text.trim().isEmpty
            ? null
            : _interviewerCtrl.text.trim(),
        meetingLink:     _linkCtrl.text.trim().isEmpty
            ? null
            : _linkCtrl.text.trim(),
        status:          _status,
        notes:           _notesCtrl.text.trim().isEmpty
            ? null
            : _notesCtrl.text.trim(),
        reminderEnabled: _reminder,
      );
    }

    if (ok && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final formState  =
        ref.watch(interviewFormProvider(widget.applicationId));

    // Prefill when edit data arrives
    if (_isEdit && formState.prefill != null && !_initialised) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => _prefillFromState(formState.prefill!)));
    }

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
                // ── AppBar ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: colors.foreground),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isEdit ? 'Edit Interview' : 'Schedule Interview',
                        style: AppTextStyles.headline
                            .copyWith(color: colors.foreground),
                      ),
                    ],
                  ),
                ),

                // ── Form shell ─────────────────────────────────────────
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
                      child: _isEdit && formState.isLoading && !_initialised
                          ? const Center(
                              child: CircularProgressIndicator())
                          : _buildForm(context, formState, colors),
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

  Widget _buildForm(
    BuildContext context,
    InterviewFormState formState,
    AppColors colors,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Interview type ─────────────────────────────────────────
            Text('Interview Type',
                style:
                    AppTextStyles.title.copyWith(color: colors.foreground)),
            const SizedBox(height: 10),
            _TypeSelector(
              selected: _type,
              onChanged: (t) => setState(() => _type = t),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // ── Round name ─────────────────────────────────────────────
            TextFormField(
              controller: _roundNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Round Name *',
                hintText: 'e.g. Technical Round 1',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // ── Date ───────────────────────────────────────────────────
            _PickerTile(
              label: 'Interview Date *',
              value: _date != null
                  ? DateFormat('EEE, MMM d yyyy').format(_date!)
                  : null,
              placeholder: 'Select date',
              icon: Icons.calendar_today_outlined,
              onTap: _pickDate,
              colors: colors,
              hasError: false,
            ),
            const SizedBox(height: 10),

            // ── Time ───────────────────────────────────────────────────
            _PickerTile(
              label: 'Time (optional)',
              value: _time?.format(context),
              placeholder: 'Select time',
              icon: Icons.schedule_outlined,
              onTap: _pickTime,
              trailing: _time != null
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => setState(() => _time = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : null,
              colors: colors,
              hasError: false,
            ),
            const SizedBox(height: 20),

            // ── Status ─────────────────────────────────────────────────
            Text('Status',
                style:
                    AppTextStyles.title.copyWith(color: colors.foreground)),
            const SizedBox(height: 10),
            _StatusSelector(
              selected: _status,
              onChanged: (s) => setState(() => _status = s),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // ── Optional fields ────────────────────────────────────────
            Text('Details (Optional)',
                style:
                    AppTextStyles.title.copyWith(color: colors.foreground)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _interviewerCtrl,
              decoration: const InputDecoration(
                labelText: 'Interviewer Name',
                hintText: 'e.g. Alice Johnson',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _linkCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Meeting Link / Location',
                hintText: 'Zoom link or office address',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _timezoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Timezone',
                hintText: 'e.g. America/New_York',
                prefixIcon: Icon(Icons.public_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Topics to prepare, questions to ask…',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // ── Reminder toggle ────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile.adaptive(
                title: Text(
                  'Enable Reminder',
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
                ),
                subtitle: Text(
                  'Get notified before this interview',
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foregroundSecondary),
                ),
                value: _reminder,
                onChanged: (v) => setState(() => _reminder = v),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            // ── Error ──────────────────────────────────────────────────
            if (formState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.statusRejectedBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  formState.errorMessage!,
                  style: AppTextStyles.caption
                      .copyWith(color: colors.statusRejected),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // ── Submit ─────────────────────────────────────────────────
            FilledButton(
              onPressed: formState.isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.buttonH),
              ),
              child: formState.isLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white))
                  : Text(_isEdit ? 'Save Changes' : 'Schedule Interview'),
            ),
            SizedBox(height: AppSpacing.bottomNavH + AppSpacing.cardPad),
          ],
        ),
      ),
    );
  }
}

// ── Type selector (segmented-style chips) ─────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.onChanged,
    required this.colors,
  });

  final InterviewType selected;
  final ValueChanged<InterviewType> onChanged;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Row(
        children: InterviewType.values.map((t) {
          final active = selected == t;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? colors.primary : colors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: active
                          ? colors.primary
                          : colors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        t.icon,
                        size: 20,
                        color: active
                            ? Colors.white
                            : colors.foregroundSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.displayName,
                        style: AppTextStyles.micro.copyWith(
                          color: active
                              ? Colors.white
                              : colors.foregroundSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
}

// ── Status selector (chips) ───────────────────────────────────────────────────

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.selected,
    required this.onChanged,
    required this.colors,
  });

  final InterviewStatus selected;
  final ValueChanged<InterviewStatus> onChanged;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: InterviewStatus.values.map((s) {
          final active = selected == s;
          final (fg, bg) = _statusColors(s, colors);
          return GestureDetector(
            onTap: () => onChanged(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? fg : bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? fg : fg.withAlpha(60)),
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
      );

  (Color, Color) _statusColors(InterviewStatus s, AppColors c) =>
      switch (s) {
        InterviewStatus.scheduled   => (c.statusApplied, c.statusAppliedBg),
        InterviewStatus.completed   => (c.statusOffer, c.statusOfferBg),
        InterviewStatus.rescheduled => (c.statusAssessment, c.statusAssessmentBg),
        InterviewStatus.cancelled   => (c.statusRejected, c.statusRejectedBg),
      };
}

// ── Picker tile ───────────────────────────────────────────────────────────────

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
    required this.colors,
    required this.hasError,
    this.trailing,
  });

  final String label;
  final String? value;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final AppColors colors;
  final bool hasError;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(
              color: hasError ? colors.destructive : colors.borderSubtle,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors.foregroundSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.micro
                          .copyWith(color: colors.foregroundSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value ?? placeholder,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: value != null
                            ? colors.foreground
                            : colors.foregroundTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: colors.foregroundSecondary),
            ],
          ),
        ),
      );
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# Write files
# ─────────────────────────────────────────────────────────────────────────────
for rel_path, content in files.items():
    abs_path = os.path.join(BASE, rel_path)
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)
    with open(abs_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"  wrote  {rel_path}")

print(f"\nDone — {len(files)} files written.")
