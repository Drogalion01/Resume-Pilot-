import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
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
    final colors = Theme.of(context).appColors;
    final dateLabel = DateFormat('EEE, MMM d yyyy').format(interview.date);
    final timeLabel = interview.parsedTime?.format(context);

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
          if (interview.notes != null && interview.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                    style:
                        AppTextStyles.caption.copyWith(color: colors.primary),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          style:
              AppTextStyles.micro.copyWith(color: colors.foregroundSecondary),
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
        content: Text('Remove "${widget.interview.roundName}" interview?'),
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
            style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
