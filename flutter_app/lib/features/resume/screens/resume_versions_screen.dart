import 'package:flutter/material.dart';
import '../../../shared/widgets/backgrounds/breathing_background.dart';
import '../../../core/theme/app_gradients.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/resume_version.dart';
import '../providers/resume_list_provider.dart';
import '../widgets/resume_states.dart';

class ResumeVersionsScreen extends ConsumerWidget {
  const ResumeVersionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final resumesAsync = ref.watch(resumeListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BreathingBackground(
          child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
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
          Positioned.fill(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.pageH, vertical: 16)
                        .copyWith(bottom: 8),
                    child: Row(
                      children: [
                        if (context.canPop())
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              color: colors.foreground,
                              onPressed: () => context.pop(),
                              tooltip: 'Back',
                            ),
                          ),
                        Expanded(
                          child: Text(
                            'My Resumes',
                            style: AppTextStyles.headline
                                .copyWith(color: colors.foreground),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.upload_file_outlined,
                              color: colors.primary),
                          tooltip: 'Upload new resume',
                          onPressed: () => context.push(AppRoutes.upload),
                        ),
                      ],
                    ),
                  ),

                  // ── List ────────────────────────────────────────────────────
                  Expanded(
                    child: resumesAsync.when(
                      loading: () => const ResumeListSkeleton(),
                      error: (e, _) => ResumeErrorState(
                        error: e,
                        onRetry: () => ref.invalidate(resumeListProvider),
                      ),
                      data: (resumes) {
                        if (resumes.isEmpty) {
                          return ResumesEmptyState(
                            onUpload: () => context.push(AppRoutes.upload),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () =>
                              ref.read(resumeListProvider.notifier).refresh(),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.pageH, vertical: 8),
                            itemCount: resumes.length,
                            itemBuilder: (_, i) =>
                                _ResumeTile(resume: resumes[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class _ResumeTile extends StatelessWidget {
  const _ResumeTile({required this.resume});

  final ResumeResponse resume;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel =
        DateFormat('MMM d, yyyy').format(resume.createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card)),
      elevation: 0,
      color: colors.surfaceSecondary,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: () => context.push(AppRoutes.resumeDetail(resume.id)),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primaryMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child:
              Icon(Icons.description_outlined, color: colors.primary, size: 22),
        ),
        title: Text(
          resume.title,
          style: AppTextStyles.bodyMedium
              .copyWith(color: colors.foreground, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          dateLabel,
          style:
              AppTextStyles.caption.copyWith(color: colors.foregroundSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Badge(label: resume.fileTypeLabel, colors: colors),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: colors.foregroundSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.colors});

  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadii.badge),
        ),
        child: Text(
          label,
          style: AppTextStyles.micro
              .copyWith(color: colors.primary, fontWeight: FontWeight.w600),
        ),
      );
}
