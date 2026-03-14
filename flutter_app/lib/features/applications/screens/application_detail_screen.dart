import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../models/application_detail.dart';
import '../../resume/models/resume_version.dart';
import '../providers/application_detail_provider.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_states.dart';
import '../widgets/notes_editor.dart';
import '../widgets/reminders_widget.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_widget.dart';
import '../../interviews/widgets/interviews_section.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({super.key, required this.applicationId});

  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final detailAsync = ref.watch(applicationDetailProvider(applicationId));

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Gradient bg
          Positioned.fill(
            child: Container(
              decoration:
                  BoxDecoration(gradient: AppGradients.heroBackground(colors)),
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.heroGlow1(colors),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── AppBar ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: colors.foreground, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: detailAsync.maybeWhen(
                          data: (d) => Text(
                            d.application.companyName,
                            style: AppTextStyles.headline
                                .copyWith(color: colors.foreground),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                      // Delete button
                      detailAsync.maybeWhen(
                        data: (d) => IconButton(
                          icon: Icon(Icons.delete_outline_rounded,
                              color: colors.destructive, size: 22),
                          onPressed: () => _confirmDelete(context, ref),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                // ── Content ──────────────────────────────────────────────
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfacePrimary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      boxShadow: AppShadows.elevated(brightness),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xl2)),
                      child: detailAsync.when(
                        loading: () => const ApplicationDetailSkeleton(),
                        error: (e, _) => ApplicationErrorState(
                          error: e,
                          onRetry: () => ref.invalidate(
                              applicationDetailProvider(applicationId)),
                        ),
                        data: (detail) => _DetailContent(
                          detail: detail,
                          applicationId: applicationId,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text(
            'Are you sure you want to delete this application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).appColors.destructive),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await ref
          .read(applicationsProvider.notifier)
          .removeApplication(applicationId);
      if (context.mounted) context.pop();
    }
  }
}

// ── Detail content ─────────────────────────────────────────────────────────────

class _DetailContent extends ConsumerWidget {
  const _DetailContent({
    required this.detail,
    required this.applicationId,
  });

  final ApplicationDetailResponse detail;
  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final app = detail.application;

    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // ── Hero header ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.role,
                            style: AppTextStyles.display
                                .copyWith(color: colors.foreground),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.companyName,
                            style: AppTextStyles.title
                                .copyWith(color: colors.foregroundSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ApplicationStatusBadge(status: app.status),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (app.location != null)
                      _MetaTag(
                        icon: Icons.location_on_outlined,
                        label: app.location!,
                        colors: colors,
                      ),
                    if (app.applicationDate != null)
                      _MetaTag(
                        icon: Icons.calendar_today_outlined,
                        label: DateFormat('MMM d, yyyy')
                            .format(app.applicationDate!),
                        colors: colors,
                      ),
                    if (app.source != null)
                      _MetaTag(
                        icon: Icons.link_rounded,
                        label: app.source!,
                        colors: colors,
                      ),
                    if (app.recruiterName != null)
                      _MetaTag(
                        icon: Icons.person_outline,
                        label: app.recruiterName!,
                        colors: colors,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Status change ────────────────────────────────────────────────
        _Section(
          title: 'Update Status',
          child: _StatusPicker(
            current: app.status,
            applicationId: applicationId,
          ),
        ),

        // ── Timeline ────────────────────────────────────────────────────
        _Section(
          title: 'Activity',
          child: TimelineWidget(events: detail.timelineEvents),
        ),

        // ── Linked resume ────────────────────────────────────────────────
        if (detail.resumeVersion != null)
          _Section(
            title: 'Linked Resume',
            child: _LinkedResumeTile(
              version: detail.resumeVersion!,
              colors: colors,
            ),
          ),

        // ── Interviews ───────────────────────────────────────────────────
        _Section(
          title: 'Interviews',
          child: InterviewsSection(
            applicationId: applicationId,
            interviews: detail.interviews,
          ),
        ),

        // ── Reminders ────────────────────────────────────────────────────
        _Section(
          title: 'Reminders',
          child: RemindersWidget(
            applicationId: applicationId,
            reminders: detail.reminders,
          ),
        ),

        // ── Notes ────────────────────────────────────────────────────────
        _Section(
          title: 'Notes',
          child: NotesEditor(
            applicationId: applicationId,
            notes: detail.notes,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.bottomNavH + AppSpacing.cardPad),
        ),
      ],
    );
  }
}

// ── Section wrapper ───────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageH, vertical: 0)
            .copyWith(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.title.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Meta tag ──────────────────────────────────────────────────────────────────

class _MetaTag extends StatelessWidget {
  const _MetaTag({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.foregroundSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: colors.foregroundSecondary),
          ),
        ],
      );
}

// ── Status picker ─────────────────────────────────────────────────────────────

class _StatusPicker extends ConsumerWidget {
  const _StatusPicker({required this.current, required this.applicationId});

  final ApplicationStatus current;
  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ApplicationStatus.values.map((s) {
        final active = current == s;
        final fg = s.foreground(colors);
        final bg = s.background(colors);
        return GestureDetector(
          onTap: active
              ? null
              : () => ref
                  .read(applicationDetailProvider(applicationId).notifier)
                  .updateStatus(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active ? fg : bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? fg : fg.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(s.icon, size: 13, color: active ? Colors.white : fg),
                const SizedBox(width: 5),
                Text(
                  s.displayName,
                  style: AppTextStyles.micro.copyWith(
                    color: active ? Colors.white : fg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Linked resume tile ────────────────────────────────────────────────────────

class _LinkedResumeTile extends StatelessWidget {
  const _LinkedResumeTile({required this.version, required this.colors});

  // ignore: avoid_annotating_with_dynamic
  final ResumeVersionResponse version;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.resumeDetail(version.resumeId)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: colors.primary.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: colors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    version.versionName ??
                        version.targetRole ??
                        'Resume Version',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.foreground, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (version.targetRole != null)
                    Text(
                      version.targetRole!,
                      style: AppTextStyles.caption
                          .copyWith(color: colors.foregroundSecondary),
                    ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, size: 16, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
