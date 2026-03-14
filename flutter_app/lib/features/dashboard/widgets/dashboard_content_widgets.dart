import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../applications/models/application.dart';
import '../../interviews/models/interview.dart';
import '../../resume/models/resume_version.dart';
import '../models/dashboard_response.dart';
import '../../../shared/widgets/animations/animated_counter_text.dart';
import '../../../shared/widgets/cards/glass_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// InsightCard
// ─────────────────────────────────────────────────────────────────────────────

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.insight});

  final DashboardInsight insight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: 8,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.lightbulb_outline,
                  color: colors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.trendingStat,
                    style:
                        AppTextStyles.title.copyWith(color: colors.foreground),
                  ),
                  if (insight.description != null &&
                      insight.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      insight.description!,
                      style: AppTextStyles.caption
                          .copyWith(color: colors.foregroundSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QuickStatsRow
// ─────────────────────────────────────────────────────────────────────────────

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: 4,
      ),
      child: Row(
        children: [
          _StatChip(
            label: 'Resumes',
            value: summary.totalResumes,
            icon: Icons.description_outlined,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'Applications',
            value: summary.totalApplications,
            icon: Icons.work_outline,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'Interviews',
            value: summary.totalInterviews,
            icon: Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: colors.primary),
            const SizedBox(height: 4),
            AnimatedCounterText(
              targetValue: value.toDouble(),
              textStyle: AppTextStyles.title.copyWith(color: colors.foreground),
            ),
            Text(
              label,
              style: AppTextStyles.micro
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QuickActionsRow
// ─────────────────────────────────────────────────────────────────────────────

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: 4,
      ),
      child: Row(
        children: [
          _QuickActionTile(
            label: 'Upload Resume',
            icon: Icons.upload_file_outlined,
            onTap: () => context.push(AppRoutes.upload),
          ),
          const SizedBox(width: 8),
          _QuickActionTile(
            label: 'Add Application',
            icon: Icons.add_circle_outline,
            onTap: () => context.push(AppRoutes.addApplication),
          ),
          const SizedBox(width: 8),
          _QuickActionTile(
            label: 'All Applications',
            icon: Icons.list_alt_outlined,
            onTap: () => context.push(AppRoutes.applications),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            gradient: AppGradients.primaryButton(colors),
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppShadows.card(Theme.of(context).brightness),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: Colors.white),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SectionHeader
// ─────────────────────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.seeAllRoute,
  });

  final String title;
  final String? seeAllRoute;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH)
          .copyWith(top: 20, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.title.copyWith(color: colors.foreground),
            ),
          ),
          if (seeAllRoute != null)
            TextButton(
              onPressed: () => context.push(seeAllRoute!),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See all',
                style: AppTextStyles.caption.copyWith(color: colors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ResumeTile
// ─────────────────────────────────────────────────────────────────────────────

class ResumeTile extends StatelessWidget {
  const ResumeTile({super.key, required this.resume});

  final ResumeResponse resume;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel =
        DateFormat('MMM d, yyyy').format(resume.createdAt.toLocal());

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.pageH, vertical: 4),
      onTap: () => context.push(AppRoutes.resumeDetail(resume.id)),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colors.primaryMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child:
            Icon(Icons.description_outlined, color: colors.primary, size: 20),
      ),
      title: Text(
        resume.title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        dateLabel,
        style:
            AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
      ),
      trailing: _FileTypeBadge(label: resume.fileTypeLabel, colors: colors),
    );
  }
}

class _FileTypeBadge extends StatelessWidget {
  const _FileTypeBadge({required this.label, required this.colors});

  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// InterviewTile
// ─────────────────────────────────────────────────────────────────────────────

class InterviewTile extends StatelessWidget {
  const InterviewTile({super.key, required this.interview});

  final InterviewResponse interview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = DateFormat('MMM d').format(interview.date.toLocal());
    final dayLabel = DateFormat('EEE').format(interview.date.toLocal());
    final typeLabel = interview.interviewType.displayName;
    final isToday = interview.isToday;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.pageH, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isToday ? colors.primary : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dateLabel.split(' ').last,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isToday ? Colors.white : colors.foreground,
              ),
            ),
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isToday ? Colors.white70 : colors.foregroundSecondary,
              ),
            ),
          ],
        ),
      ),
      title: Text(
        interview.roundName,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        typeLabel,
        style:
            AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
      ),
      trailing: _InterviewStatusBadge(status: interview.status, colors: colors),
    );
  }
}

class _InterviewStatusBadge extends StatelessWidget {
  const _InterviewStatusBadge({required this.status, required this.colors});

  final InterviewStatus status;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case InterviewStatus.scheduled:
        bg = colors.statusAppliedBg;
        fg = colors.statusApplied;
      case InterviewStatus.completed:
        bg = colors.statusOfferBg;
        fg = colors.statusOffer;
      case InterviewStatus.rescheduled:
        bg = colors.statusHrBg;
        fg = colors.statusHr;
      case InterviewStatus.cancelled:
        bg = colors.statusRejectedBg;
        fg = colors.statusRejected;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.micro
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ApplicationTile
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationTile extends StatelessWidget {
  const ApplicationTile({super.key, required this.application});

  final ApplicationResponse application;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final initials = application.companyName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.pageH, vertical: 4),
      onTap: () => context.push(AppRoutes.applicationDetail(application.id)),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colors.primaryMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
      ),
      title: Text(
        application.companyName,
        style: AppTextStyles.bodyMedium.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        application.role,
        style:
            AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing:
          _ApplicationStatusBadge(status: application.status, colors: colors),
    );
  }
}

class _ApplicationStatusBadge extends StatelessWidget {
  const _ApplicationStatusBadge({required this.status, required this.colors});

  final ApplicationStatus status;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case ApplicationStatus.saved:
        bg = colors.statusSavedBg;
        fg = colors.statusSaved;
      case ApplicationStatus.applied:
        bg = colors.statusAppliedBg;
        fg = colors.statusApplied;
      case ApplicationStatus.assessment:
        bg = colors.statusAssessmentBg;
        fg = colors.statusAssessment;
      case ApplicationStatus.hr:
        bg = colors.statusHrBg;
        fg = colors.statusHr;
      case ApplicationStatus.technical:
        bg = colors.statusTechnicalBg;
        fg = colors.statusTechnical;
      case ApplicationStatus.finalRound:
        bg = colors.statusFinalBg;
        fg = colors.statusFinal;
      case ApplicationStatus.offer:
        bg = colors.statusOfferBg;
        fg = colors.statusOffer;
      case ApplicationStatus.rejected:
        bg = colors.statusRejectedBg;
        fg = colors.statusRejected;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.micro
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
