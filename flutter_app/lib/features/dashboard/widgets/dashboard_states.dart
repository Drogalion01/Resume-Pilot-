import 'package:flutter/material.dart';
import '../../../shared/widgets/animations/premium_shimmer.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../app/router/routes.dart';
import 'package:go_router/go_router.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.8,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your dashboard…',
              style:
                  AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'If this takes more than a few seconds, tap retry.',
              style: AppTextStyles.caption
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
// DashboardSkeleton
// ─────────────────────────────────────────────────────────────────────────────

/// Shimmer placeholder that matches the real dashboard layout.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumShimmer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH,
          vertical: 16,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Insight card placeholder
          const _ShimmerBox(height: 76, radius: AppRadii.card),
          const SizedBox(height: 12),

          // Stat chips
          Row(
            children: List.generate(
              3,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _ShimmerBox(height: 72, radius: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick actions
          Row(
            children: List.generate(
              3,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _ShimmerBox(height: 80, radius: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section label
          const _ShimmerBox(height: 14, width: 120, radius: 6),
          const SizedBox(height: 10),

          // 3 list tiles
          ..._shimmerTiles(3),

          const SizedBox(height: 20),
          const _ShimmerBox(height: 14, width: 140, radius: 6),
          const SizedBox(height: 10),
          ..._shimmerTiles(3),

          const SizedBox(height: 20),
          const _ShimmerBox(height: 14, width: 160, radius: 6),
          const SizedBox(height: 10),
          ..._shimmerTiles(3),
        ],
      ),
    );
  }

  List<Widget> _shimmerTiles(int count) {
    return List.generate(count, (_) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            _ShimmerBox(height: 42, width: 42, radius: 10),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(height: 14, radius: 6),
                  SizedBox(height: 6),
                  _ShimmerBox(height: 12, width: 100, radius: 4),
                ],
              ),
            ),
            SizedBox(width: 12),
            _ShimmerBox(height: 24, width: 60, radius: 6),
          ],
        ),
      );
    });
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    this.width,
    required this.radius,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardEmpty
// ─────────────────────────────────────────────────────────────────────────────

/// Shown when the dashboard returns no resumes or applications yet.
class DashboardEmpty extends StatelessWidget {
  const DashboardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.rocket_launch_outlined,
                  color: colors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              "Let's get you started!",
              style: AppTextStyles.headline.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first resume to unlock AI-powered insights and start tracking your job applications.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.upload),
              icon: const Icon(Icons.upload_file_outlined, size: 18),
              label: const Text('Upload Resume'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardError
// ─────────────────────────────────────────────────────────────────────────────

/// Shown on network / server errors with a retry affordance.
class DashboardError extends StatelessWidget {
  const DashboardError({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final message = error is AppException
        ? (error as AppException).userMessage
        : 'Something went wrong. Please try again.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                color: colors.foregroundSecondary, size: 52),
            const SizedBox(height: 16),
            Text(
              'Could not load dashboard',
              style: AppTextStyles.title.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
