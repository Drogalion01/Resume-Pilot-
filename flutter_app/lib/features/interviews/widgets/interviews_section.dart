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
          onPressed: () => context.push(AppRoutes.addInterview(applicationId)),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Schedule Interview'),
          style:
              OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
        ),
      ],
    );
  }

  int _rank(InterviewStatus s) => switch (s) {
        InterviewStatus.scheduled => 0,
        InterviewStatus.rescheduled => 1,
        InterviewStatus.completed => 2,
        InterviewStatus.cancelled => 3,
      };
}
