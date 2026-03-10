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
