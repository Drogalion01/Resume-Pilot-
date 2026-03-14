import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LoadingSkeletons  — shimmer placeholder layouts
// ─────────────────────────────────────────────────────────────────────────────

class LoadingSkeletons extends StatelessWidget {
  const LoadingSkeletons._({required Widget child}) : _child = child;

  factory LoadingSkeletons.dashboard() => LoadingSkeletons._(
        child: _DashboardSkeleton(),
      );
  factory LoadingSkeletons.resumeList() => LoadingSkeletons._(
        child: _ResumeListSkeleton(),
      );
  factory LoadingSkeletons.applicationList() => LoadingSkeletons._(
        child: _ApplicationListSkeleton(),
      );
  factory LoadingSkeletons.analysisResult() => LoadingSkeletons._(
        child: _AnalysisSkeleton(),
      );
  factory LoadingSkeletons.detail() => LoadingSkeletons._(
        child: _DetailSkeleton(),
      );

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.surfacePrimary,
      child: _child,
    );
  }
}

// ── Skeleton shapes ──────────────────────────────────────────────────────────

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = AppRadii.md,
  });
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _SkeletonFlex extends StatelessWidget {
  const _SkeletonFlex({required this.height, this.radius = AppRadii.md});
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

// ── Dashboard skeleton ───────────────────────────────────────────────────────

class _DashboardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.px16),
            // Score card placeholder
            const _SkeletonFlex(height: 110, radius: AppRadii.card),
            const SizedBox(height: AppSpacing.px24),
            const _SkeletonBox(width: 120, height: 18),
            const SizedBox(height: AppSpacing.px12),
            for (var i = 0; i < 3; i++) ...[
              const _SkeletonFlex(height: 72, radius: AppRadii.cardSm),
              const SizedBox(height: AppSpacing.cardGap),
            ],
            const SizedBox(height: AppSpacing.px16),
            const _SkeletonBox(width: 140, height: 18),
            const SizedBox(height: AppSpacing.px12),
            for (var i = 0; i < 2; i++) ...[
              const _SkeletonFlex(height: 72, radius: AppRadii.cardSm),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Resume list skeleton ──────────────────────────────────────────────────────

class _ResumeListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px8),
            for (var i = 0; i < 4; i++) ...[
              Container(
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                ),
                padding: const EdgeInsets.all(AppSpacing.cardPad),
                child: const Row(
                  children: [
                    _SkeletonBox(width: 52, height: 52, radius: AppRadii.md),
                    SizedBox(width: AppSpacing.px12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SkeletonFlex(height: 14),
                          SizedBox(height: 8),
                          _SkeletonBox(width: 80, height: 10),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.px12),
                    _SkeletonBox(width: 44, height: 44, radius: 22),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Application list skeleton ──────────────────────────────────────────────────

class _ApplicationListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px8),
            for (var i = 0; i < 5; i++) ...[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                ),
                padding: const EdgeInsets.all(AppSpacing.cardPad),
                child: const Row(
                  children: [
                    _SkeletonBox(width: 40, height: 40, radius: AppRadii.md),
                    SizedBox(width: AppSpacing.px12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SkeletonFlex(height: 14),
                          SizedBox(height: 6),
                          _SkeletonBox(
                              width: 60,
                              height: 18,
                              radius: AppRadii.badgePill),
                        ],
                      ),
                    ),
                    _SkeletonBox(width: 40, height: 10),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Analysis result skeleton ──────────────────────────────────────────────────

class _AnalysisSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px24),
            const Center(
              child: _SkeletonBox(width: 120, height: 120, radius: 60),
            ),
            const SizedBox(height: AppSpacing.px24),
            for (var i = 0; i < 4; i++) ...[
              const _SkeletonFlex(height: 18, radius: AppRadii.sm),
              const SizedBox(height: AppSpacing.px8),
            ],
            const SizedBox(height: AppSpacing.px16),
            for (var i = 0; i < 3; i++) ...[
              const _SkeletonFlex(height: 80, radius: AppRadii.card),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Generic detail skeleton ───────────────────────────────────────────────────

class _DetailSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.px16),
            _SkeletonBox(width: 180, height: 24),
            SizedBox(height: AppSpacing.px8),
            _SkeletonBox(width: 100, height: 16),
            SizedBox(height: AppSpacing.px24),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px12),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px12),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px24),
            _SkeletonFlex(height: 160, radius: AppRadii.card),
          ],
        ),
      );
}
