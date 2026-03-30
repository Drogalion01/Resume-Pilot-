import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/dashboard_provider.dart';
import '../models/dashboard_response.dart';
import '../../interviews/models/interview.dart';
import '../../applications/models/application.dart';
import '../../profile/models/user_profile.dart';
import '../../resume/models/resume_version.dart';
import '../../../shared/widgets/backgrounds/breathing_background.dart';
import '../widgets/dashboard_states.dart';

/// The home tab — displayed when route is [AppRoutes.home] ('/').
///
/// Layout:
///   Stack [
///     gradient background + glow blobs,
///     SafeArea → Column [
///       DashboardHeader (fixed ~110 px),
///       Expanded → rounded surface → scrollable content
///     ]
///   ]
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _kPageRadius = 20.0;

  BoxDecoration _sectionDecoration(Color bg, Color border) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(_kPageRadius),
      border: Border.all(color: border, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x16000000),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BreathingBackground(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.heroBackground(colors),
          ),
          child: SafeArea(
            bottom: false,
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => DashboardError(
                error: e,
                onRetry: () => ref.invalidate(dashboardProvider),
              ),
              data: (data) => ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageH,
                  4,
                  AppSpacing.pageH,
                  AppSpacing.bottomNavH + 18,
                ),
                children: [
                  _HomeHero(user: data.user, summary: data.summary),

                  // ATS improvement banner
                  if (data.insight.trendingStat.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: _sectionDecoration(
                        colors.statusOfferBg,
                        colors.primaryLight,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.trending_up,
                                color: colors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              data.insight.trendingStat,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.foreground,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Stats + quick actions block (solid premium surface, no glass effect)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: colors.surfacePrimary,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.borderSubtle),
                      boxShadow: [
                        BoxShadow(
                          color: colors.foreground.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: _StatCard(
                                label: 'Resumes',
                                value: data.summary.totalResumes,
                                icon: Icons.description_outlined,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: _StatCard(
                                label: 'Applications',
                                value: data.summary.totalApplications,
                                icon: Icons.work_outline,
                                color: colors.statusOffer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: _StatCard(
                                label: 'Interviews',
                                value: data.summary.totalInterviews,
                                icon: Icons.calendar_today_outlined,
                                color: colors.statusApplied,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => context.push(AppRoutes.upload),
                                icon: const Icon(Icons.upload_file_outlined,
                                    size: 20),
                                label: const Text('Upload Resume'),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                  backgroundColor: colors.primary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  textStyle: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () =>
                                    context.push(AppRoutes.addApplication),
                                icon: const Icon(Icons.add, size: 20),
                                label: const Text('Add Application'),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side:
                                        BorderSide(color: colors.primaryLight),
                                  ),
                                  elevation: 0,
                                  backgroundColor: colors.surfaceSecondary,
                                  foregroundColor: colors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  textStyle: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Resume Health section
                  if (data.recentResumes.isNotEmpty)
                    _PremiumSectionCard(
                      title: 'Resume Health',
                      actionLabel: 'All resumes',
                      onActionTap: () => context.push(AppRoutes.resumes),
                      children: data.recentResumes
                          .take(2)
                          .map((resume) => _ResumeHealthTile(resume: resume))
                          .toList(),
                    ),

                  // Upcoming Interviews
                  if (data.upcomingInterviews.isNotEmpty)
                    _PremiumSectionCard(
                      title: 'Upcoming Interviews',
                      children: data.upcomingInterviews
                          .map((interview) =>
                              _InterviewPreviewTile(interview: interview))
                          .toList(),
                    ),

                  // Recent Applications
                  if (data.recentApplications.isNotEmpty)
                    _PremiumSectionCard(
                      title: 'Recent Applications',
                      actionLabel: 'See all',
                      onActionTap: () => context.push(AppRoutes.applications),
                      children: data.recentApplications
                          .map((application) =>
                              _ApplicationPreviewTile(application: application))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Card-based stat widget
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: colors.surfacePrimary,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colors.surfacePrimary,
          border: Border.all(color: colors.borderSubtle, width: 1),
          boxShadow: [
            BoxShadow(
              color: colors.foreground.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: AppTextStyles.scoreNumber.copyWith(
                fontSize: 22,
                height: 1.0,
                letterSpacing: -0.35,
                fontWeight: FontWeight.w900,
                color: colors.foreground,
                shadows: [
                  Shadow(
                    color: colors.foreground.withValues(alpha: 0.10),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro
                  .copyWith(color: colors.foregroundSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// Resume Health tile with circular indicators
class _ResumeHealthTile extends StatelessWidget {
  final ResumeResponse resume;
  const _ResumeHealthTile({required this.resume});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final ats = scoreFromResume(resume, 'ats');
    final recruiter = scoreFromResume(resume, 'recruiter');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (ats != null)
            _ScoreCircle(score: ats, label: 'ATS', color: colors.primary)
          else
            _PendingScoreIndicator(label: 'ATS', color: colors.primary),
          const SizedBox(width: 12),
          if (recruiter != null)
            _ScoreCircle(
              score: recruiter,
              label: 'Recruiter',
              color: colors.statusOffer,
            )
          else
            _PendingScoreIndicator(
                label: 'Recruiter', color: colors.statusOffer),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resume.title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                Text('Updated ${formatDate(resume.updatedAt)}',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.foregroundSecondary),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int? scoreFromResume(ResumeResponse value, String kind) {
    final parsed = value.parsedJson;
    if (parsed is Map<String, dynamic>) {
      final candidates = kind == 'ats'
          ? ['ats_score', 'atsScore', 'matching_score', 'score']
          : ['recruiter_score', 'recruiterScore'];

      for (final key in candidates) {
        final dynamic raw = parsed[key];
        if (raw is num) return raw.round().clamp(0, 100);
        if (raw is String) {
          final parsedNum = num.tryParse(raw);
          if (parsedNum != null) return parsedNum.round().clamp(0, 100);
        }
      }
    }

    return null;
  }
}

class _ScoreCircle extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  const _ScoreCircle(
      {required this.score, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(
                value: (score.clamp(0, 100)) / 100.0,
                strokeWidth: 4,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text('$score',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.micro),
      ],
    );
  }
}

class _PendingScoreIndicator extends StatelessWidget {
  final String label;
  final Color color;

  const _PendingScoreIndicator({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.10),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          alignment: Alignment.center,
          child: Text('..',
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.bold, color: color)),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.micro),
      ],
    );
  }
}

class _InterviewPreviewTile extends StatelessWidget {
  const _InterviewPreviewTile({required this.interview});

  final InterviewResponse interview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(interview.interviewType.icon,
                color: colors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  interview.roundName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  interview.interviewType.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foregroundSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('MMM d').format(interview.date.toLocal()),
            style: AppTextStyles.caption
                .copyWith(color: colors.foregroundSecondary),
          ),
        ],
      ),
    );
  }
}

class _ApplicationPreviewTile extends StatelessWidget {
  const _ApplicationPreviewTile({required this.application});

  final ApplicationResponse application;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final String company = application.companyName;
    final String role = application.role;
    final String status = application.status.displayName;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.work_outline, color: colors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foregroundSecondary),
                ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                status,
                style: AppTextStyles.micro.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PremiumSectionCard extends StatelessWidget {
  const _PremiumSectionCard({
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
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: colors.surfacePrimary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primaryLight, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (actionLabel != null && onActionTap != null)
                TextButton(
                  onPressed: onActionTap,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel!,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.user, required this.summary});

  final UserProfile user;
  final DashboardSummary summary;

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String name() {
    final full = (user.fullName ?? '').trim();
    if (full.isEmpty) return 'Alex';
    return full.split(RegExp(r'\s+')).first;
  }

  String initials() {
    final explicit = (user.initials ?? '').trim();
    if (explicit.isNotEmpty) return explicit;
    final full = (user.fullName ?? '').trim();
    if (full.isEmpty) return 'A';
    final parts = full.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surfacePrimary.withValues(alpha: 0.98),
            colors.primaryLight.withValues(alpha: 0.68),
          ],
        ),
        border: Border.all(color: colors.primaryLight, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting(),
                      style: AppTextStyles.body.copyWith(
                        color: colors.foregroundSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name(),
                      style: AppTextStyles.headline.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfacePrimary,
                  border: Border.all(color: colors.primaryLight, width: 1),
                ),
                child: Text(
                  initials(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${summary.totalInterviews} interviews · ${summary.totalApplications} applications tracked.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
