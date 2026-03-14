import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../models/dashboard_response.dart';
import '../../../shared/widgets/backgrounds/breathing_background.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_content_widgets.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withAlpha(80),
              blurRadius: 24,
              spreadRadius: 4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.upload),
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          extendedPadding: EdgeInsets.zero,
          label: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: AppGradients.primaryButton(colors),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Analyze Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BreathingBackground(
        child: Stack(
          children: [
            // ── Gradient background ──────────────────────────────────────────
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.heroBackground(colors),
                ),
              ),
            ),

            // ── Ambient glow blobs ───────────────────────────────────────────
            Positioned(
              top: -60,
              right: -60,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow1(colors),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: -40,
              child: IgnorePointer(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow2(colors),
                  ),
                ),
              ),
            ),

            // ── Main content ─────────────────────────────────────────────────
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Header section (fixed height)
                    SizedBox(
                      height: 110,
                      child: state.whenOrNull(
                            data: (data) => DashboardHeader(user: data.user),
                          ) ??
                          // Skeleton / error: show placeholder row
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.pageH)
                                .copyWith(top: 16, bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: colors.primaryLight,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 140,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: colors.primaryMuted,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),

                    // Content surface
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surfacePrimary.withOpacity(0.55),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadii.xl2),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: state.when(
                              loading: () => const DashboardSkeleton(),
                              error: (e, _) => DashboardError(
                                error: e,
                                onRetry: () =>
                                    ref.invalidate(dashboardProvider),
                              ),
                              data: (data) => _DashboardContent(data: data),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DashboardContent — the scrollable body for the success state
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final DashboardResponse data;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = data.recentResumes.isEmpty &&
        data.recentApplications.isEmpty &&
        data.upcomingInterviews.isEmpty;

    if (isEmpty) return const DashboardEmpty();

    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // Top padding
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Insight card
        SliverToBoxAdapter(
          child: InsightCard(insight: data.insight),
        ),

        // Quick stats
        SliverToBoxAdapter(
          child: QuickStatsRow(summary: data.summary),
        ),

        // Quick actions
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        const SliverToBoxAdapter(child: QuickActionsRow()),

        // ── Recent Resumes ───────────────────────────────────────────────
        if (data.recentResumes.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recent Resumes',
              seeAllRoute: AppRoutes.resumes,
            ),
          ),
          SliverList.builder(
            itemCount: data.recentResumes.length,
            itemBuilder: (_, i) => ResumeTile(resume: data.recentResumes[i]),
          ),
        ],

        // ── Upcoming Interviews ──────────────────────────────────────────
        if (data.upcomingInterviews.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Upcoming Interviews',
            ),
          ),
          SliverList.builder(
            itemCount: data.upcomingInterviews.length,
            itemBuilder: (_, i) =>
                InterviewTile(interview: data.upcomingInterviews[i]),
          ),
        ],

        // ── Recent Applications ──────────────────────────────────────────
        if (data.recentApplications.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recent Applications',
              seeAllRoute: AppRoutes.applications,
            ),
          ),
          SliverList.builder(
            itemCount: data.recentApplications.length,
            itemBuilder: (_, i) =>
                ApplicationTile(application: data.recentApplications[i]),
          ),
        ],

        // Bottom padding  (account for bottom nav bar)
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.bottomNavH + AppSpacing.cardPad,
          ),
        ),
      ],
    );
  }
}
