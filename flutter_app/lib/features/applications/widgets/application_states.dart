import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// List skeleton
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationListSkeleton extends StatelessWidget {
  const ApplicationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail skeleton
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationDetailSkeleton extends StatelessWidget {
  const ApplicationDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(double.infinity, 24),
            const SizedBox(height: 8),
            _box(180, 16),
            const SizedBox(height: 24),
            _box(double.infinity, 48, radius: 12),
            const SizedBox(height: 20),
            _box(120, 14),
            const SizedBox(height: 12),
            ..._bars(3, 56),
            const SizedBox(height: 20),
            _box(140, 14),
            const SizedBox(height: 12),
            ..._bars(2, 48),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double radius = 8}) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );

  List<Widget> _bars(int n, double h) => List.generate(
        n,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _box(double.infinity, h),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationsEmptyState extends StatelessWidget {
  const ApplicationsEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.work_outline, color: colors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'No applications yet',
              style: AppTextStyles.headline.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your job search by adding your first application.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Application'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────

class ApplicationErrorState extends StatelessWidget {
  const ApplicationErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                color: colors.foregroundSecondary, size: 48),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.title.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
              maxLines: 3,
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
