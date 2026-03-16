import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/backgrounds/breathing_background.dart';
import '../../applications/models/application.dart';
import '../../interviews/models/interview.dart';
import '../../resume/models/resume_version.dart';
import '../models/dashboard_response.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_states.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: BreathingBackground(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.heroBackground(colors),
          ),
          child: SafeArea(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => DashboardError(
                error: e,
                onRetry: () => ref.invalidate(dashboardProvider),
              ),
              data: (data) => _DashboardView(data: data),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.data});

  final DashboardResponse data;

  String _firstName(String? fullName) {
    final name = (fullName ?? '').trim();
    if (name.isEmpty) return 'User';
    return name.split(RegExp(r'\\s+')).first;
  }

  String _initials(String? initials, String? fullName) {
    final explicit = (initials ?? '').trim();
    if (explicit.isNotEmpty) return explicit;
    final name = (fullName ?? '').trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '\\'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, AppSpacing.bottomNavH + 20),
      children: [
        _HeaderCard(userName: _firstName(data.user.fullName), initials: _initials(data.user.initials, data.user.fullName)),
        const SizedBox(height: 12),
        if (data.insight.trendingStat.isNotEmpty)
          _InsightBanner(text: data.insight.trendingStat),
        const SizedBox(height: 12),
        _StatsGrid(summary: data.summary),
        const SizedBox(height: 12),
        _ActionButtons(colors: colors),
        const SizedBox(height: 16),
        if (data.recentResumes.isNotEmpty)
          _SectionCard(
            title: 'Resume Health',
            actionLabel: 'All resumes',
            onActionTap: () => context.push(AppRoutes.resumes),
            children: data.recentResumes
                .take(2)
                .map((resume) => _ResumeHealthRow(resume: resume))
                .toList(),
          ),
        if (data.upcomingInterviews.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Upcoming Interviews',
            children: data.upcomingInterviews
                .take(3)
                .map((item) => _InterviewRow(interview: item))
                .toList(),
          ),
        ],
        if (data.recentApplications.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Recent Applications',
            actionLabel: 'See all',
            onActionTap: () => context.push(AppRoutes.applications),
            children: data.recentApplications
                .take(4)
                .map((item) => _ApplicationRow(application: item))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.userName, required this.initials});

  final String userName;
  final String initials;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfacePrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: AppTextStyles.body.copyWith(color: colors.foregroundSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headline.copyWith(color: colors.foreground),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primaryButton(colors),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  const _InsightBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.statusOfferBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.82,
      children: [
        _StatItem(
          label: 'Resumes',
          value: summary.totalResumes,
          icon: Icons.description_outlined,
          color: colors.primary,
        ),
        _StatItem(
          label: 'Applications',
          value: summary.totalApplications,
          icon: Icons.work_outline,
          color: colors.primary,
        ),
        _StatItem(
          label: 'Interviews',
          value: summary.totalInterviews,
          icon: Icons.calendar_today_outlined,
          color: colors.primary,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: AppTextStyles.title.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: colors.foregroundSecondary),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.colors});

  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push(AppRoutes.upload),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Upload Resume'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push(AppRoutes.addApplication),
            icon: const Icon(Icons.add),
            label: const Text('Add Application'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.title.copyWith(color: colors.foreground),
                ),
              ),
              if (actionLabel != null && onActionTap != null)
                TextButton(
                  onPressed: onActionTap,
                  child: Text(actionLabel!),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }
}

class _ResumeHealthRow extends StatelessWidget {
  const _ResumeHealthRow({required this.resume});

  final ResumeResponse resume;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final ats = _scoreFromParsed(resume.parsedJson, 'ats');
    final recruiter = _scoreFromParsed(resume.parsedJson, 'recruiter');

    return InkWell(
      onTap: () => context.push(AppRoutes.resumeDetail(resume.id)),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _ScoreBadge(score: ats, label: 'ATS', color: colors.primary),
            const SizedBox(width: 10),
            _ScoreBadge(score: recruiter, label: 'Recruiter', color: colors.statusOffer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Updated ${DateFormat('MMM d, yyyy').format(resume.updatedAt.toLocal())}',
                    style: AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.foregroundSecondary),
          ],
        ),
      ),
    );
  }

  int _scoreFromParsed(dynamic parsed, String kind) {
    if (parsed is Map<String, dynamic>) {
      final keys = kind == 'ats'
          ? const ['ats_score', 'atsScore', 'matching_score', 'score']
          : const ['recruiter_score', 'recruiterScore'];
      for (final key in keys) {
        final raw = parsed[key];
        if (raw is num) return raw.round().clamp(0, 100);
        if (raw is String) {
          final v = num.tryParse(raw);
          if (v != null) return v.round().clamp(0, 100);
        }
      }
    }
    return kind == 'ats' ? 78 : 82;
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({
    required this.score,
    required this.label,
    required this.color,
  });

  final int score;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  value: score.clamp(0, 100) / 100,
                  strokeWidth: 4,
                  backgroundColor: color.withValues(alpha: 0.18),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '$score',
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro,
          ),
        ],
      ),
    );
  }
}

class _InterviewRow extends StatelessWidget {
  const _InterviewRow({required this.interview});

  final InterviewResponse interview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(interview.interviewType.icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              interview.roundName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('MMM d').format(interview.date.toLocal()),
            style: AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
          ),
        ],
      ),
    );
  }
}

class _ApplicationRow extends StatelessWidget {
  const _ApplicationRow({required this.application});

  final ApplicationResponse application;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return InkWell(
      onTap: () => context.push(AppRoutes.applicationDetail(application.id)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.work_outline, size: 18, color: colors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    application.companyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    application.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                application.status.displayName,
                style: AppTextStyles.micro.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


