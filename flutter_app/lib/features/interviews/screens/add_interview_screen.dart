import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
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
  ConsumerState<AddInterviewScreen> createState() => _AddInterviewScreenState();
}

class _AddInterviewScreenState extends ConsumerState<AddInterviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final _roundNameCtrl = TextEditingController();
  final _interviewerCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  final _timezoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  InterviewType _type = InterviewType.video;
  InterviewStatus _status = InterviewStatus.scheduled;
  DateTime? _date;
  TimeOfDay? _time;
  bool _reminder = false;
  bool _initialised = false;

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
    _roundNameCtrl.text = iv.roundName;
    _interviewerCtrl.text = iv.interviewerName ?? '';
    _linkCtrl.text = iv.meetingLink ?? '';
    _timezoneCtrl.text = iv.timezone ?? '';
    _notesCtrl.text = iv.notes ?? '';
    _type = iv.interviewType;
    _status = iv.status;
    _date = iv.date;
    _time = iv.parsedTime;
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
        'round_name': _roundNameCtrl.text.trim(),
        'interview_type': _type.name,
        'date': InterviewService.formatDate(_date!),
        if (_time != null) 'time': InterviewService.formatTime(_time!),
        if (_timezoneCtrl.text.trim().isNotEmpty)
          'timezone': _timezoneCtrl.text.trim(),
        if (_interviewerCtrl.text.trim().isNotEmpty)
          'interviewer_name': _interviewerCtrl.text.trim(),
        if (_linkCtrl.text.trim().isNotEmpty)
          'meeting_link': _linkCtrl.text.trim(),
        'status': _status.name,
        'notes': _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        'reminder_enabled': _reminder,
      };
      ok = await notifier.update(widget.interviewId!, fields);
    } else {
      ok = await notifier.create(
        roundName: _roundNameCtrl.text.trim(),
        interviewType: _type,
        date: _date!,
        time: _time,
        timezone: _timezoneCtrl.text.trim().isEmpty
            ? null
            : _timezoneCtrl.text.trim(),
        interviewerName: _interviewerCtrl.text.trim().isEmpty
            ? null
            : _interviewerCtrl.text.trim(),
        meetingLink:
            _linkCtrl.text.trim().isEmpty ? null : _linkCtrl.text.trim(),
        status: _status,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        reminderEnabled: _reminder,
      );
    }

    if (ok && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final formState = ref.watch(interviewFormProvider(widget.applicationId));

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
              decoration:
                  BoxDecoration(gradient: AppGradients.heroBackground(colors)),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  // ── AppBar ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
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
                            ? const Center(child: CircularProgressIndicator())
                            : _buildForm(context, formState, colors),
                      ),
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Interview type ─────────────────────────────────────────
            Text('Interview Type',
                style: AppTextStyles.title.copyWith(color: colors.foreground)),
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
                style: AppTextStyles.title.copyWith(color: colors.foreground)),
            const SizedBox(height: 10),
            _StatusSelector(
              selected: _status,
              onChanged: (s) => setState(() => _status = s),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // ── Optional fields ────────────────────────────────────────
            Text('Details (Optional)',
                style: AppTextStyles.title.copyWith(color: colors.foreground)),
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
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: colors.foreground),
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
            const SizedBox(height: AppSpacing.bottomNavH + AppSpacing.cardPad),
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
                      color: active ? colors.primary : colors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        t.icon,
                        size: 20,
                        color:
                            active ? Colors.white : colors.foregroundSecondary,
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
                border: Border.all(color: active ? fg : fg.withAlpha(60)),
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

  (Color, Color) _statusColors(InterviewStatus s, AppColors c) => switch (s) {
        InterviewStatus.scheduled => (c.statusApplied, c.statusAppliedBg),
        InterviewStatus.completed => (c.statusOffer, c.statusOfferBg),
        InterviewStatus.rescheduled => (
            c.statusAssessment,
            c.statusAssessmentBg
          ),
        InterviewStatus.cancelled => (c.statusRejected, c.statusRejectedBg),
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
