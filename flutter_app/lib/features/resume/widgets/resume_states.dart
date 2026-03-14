import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Analysis loading skeleton
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisSkeleton extends StatelessWidget {
  const AnalysisSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dual rings placeholder
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Box(width: 110, height: 110, radius: 55),
                _Box(width: 110, height: 110, radius: 55),
              ],
            ),
            const SizedBox(height: 24),
            const _Box(width: 160, height: 14, radius: 6),
            const SizedBox(height: 12),
            ..._bars(4),
            const SizedBox(height: 20),
            const _Box(width: 120, height: 14, radius: 6),
            const SizedBox(height: 12),
            ..._bars(3),
            const SizedBox(height: 20),
            const _Box(width: 140, height: 14, radius: 6),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                6,
                (_) => const _Box(width: 72, height: 28, radius: AppRadii.chip),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _bars(int n) => List.generate(
        n,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Box(width: double.infinity, height: 10, radius: 4),
              SizedBox(height: 4),
              _Box(width: 200, height: 8, radius: 4),
            ],
          ),
        ),
      );
}

class _Box extends StatelessWidget {
  const _Box({required this.width, required this.height, required this.radius});

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

// ─────────────────────────────────────────────────────────────────────────────
// Resume list skeleton
// ─────────────────────────────────────────────────────────────────────────────

class ResumeListSkeleton extends StatelessWidget {
  const ResumeListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.primaryLight,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 16),
        itemCount: 5,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              _Box(width: 48, height: 48, radius: 10),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Box(width: double.infinity, height: 14, radius: 6),
                    SizedBox(height: 6),
                    _Box(width: 120, height: 12, radius: 4),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _Box(width: 40, height: 24, radius: 6),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class ResumesEmptyState extends StatelessWidget {
  const ResumesEmptyState({super.key, required this.onUpload});

  final VoidCallback onUpload;

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
              child: Icon(Icons.description_outlined,
                  color: colors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'No resumes yet',
              style: AppTextStyles.headline.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a resume to get ATS and recruiter scores, keyword analysis, and rewrite suggestions.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onUpload,
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
// Error state
// ─────────────────────────────────────────────────────────────────────────────

class ResumeErrorState extends StatelessWidget {
  const ResumeErrorState({
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
