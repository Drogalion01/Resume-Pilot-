import 'package:flutter/material.dart';
import '../../../shared/widgets/backgrounds/breathing_background.dart';
import 'dart:ui';
import '../../../core/theme/app_gradients.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_states.dart';
import '../widgets/status_badge.dart';

class ApplicationsTrackerScreen extends ConsumerWidget {
  const ApplicationsTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final stateAsync = ref.watch(applicationsProvider);

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
            SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 16)
                  .copyWith(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Applications',
                      style: AppTextStyles.headline
                          .copyWith(color: colors.foreground),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: colors.primary),
                    onPressed: () => context.push(AppRoutes.addApplication),
                  ),
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageH, vertical: 8),
              child: TextField(
                onChanged: (q) =>
                    ref.read(applicationsProvider.notifier).setSearch(q),
                decoration: InputDecoration(
                  hintText: 'Search company or role…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: colors.surfaceSecondary,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),

            // ── Status filter chips ──────────────────────────────────────
            stateAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (s) => _StatusFilterRow(
                activeFilter: s.activeFilter,
                counts: s.statusCounts,
                onSelect: (status) =>
                    ref.read(applicationsProvider.notifier).setFilter(status),
              ),
            ),

            const SizedBox(height: 4),

            // ── List ─────────────────────────────────────────────────────
            Expanded(
              child: stateAsync.when(
                loading: () => const ApplicationListSkeleton(),
                error: (e, _) => ApplicationErrorState(
                  error: e,
                  onRetry: () => ref.invalidate(applicationsProvider),
                ),
                data: (s) {
                  final list = s.filtered;
                  if (list.isEmpty && s.applications.isEmpty) {
                    return ApplicationsEmptyState(
                      onAdd: () => context.push(AppRoutes.addApplication),
                    );
                  }
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No matching applications.',
                        style: AppTextStyles.caption
                            .copyWith(color: colors.foregroundSecondary),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(applicationsProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pageH, vertical: 8),
                      itemCount: list.length,
                      itemBuilder: (_, i) => _ApplicationCard(app: list[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
        ],
      )),
    );
  }
}

// ── Status filter row ─────────────────────────────────────────────────────────

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.activeFilter,
    required this.counts,
    required this.onSelect,
  });

  final ApplicationStatus? activeFilter;
  final Map<ApplicationStatus, int> counts;
  final ValueChanged<ApplicationStatus?> onSelect;

  static const _statuses = ApplicationStatus.values;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final total = counts.values.fold(0, (a, b) => a + b);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        children: [
          _Chip(
            label: 'All',
            count: total,
            active: activeFilter == null,
            foreground: colors.primary,
            background: colors.primaryLight,
            onTap: () => onSelect(null),
          ),
          ..._statuses.map((s) => _Chip(
                label: s.displayName,
                count: counts[s] ?? 0,
                active: activeFilter == s,
                foreground: s.foreground(colors),
                background: s.background(colors),
                onTap: () => onSelect(activeFilter == s ? null : s),
              )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.active,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active ? foreground : background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? foreground : foreground.withAlpha(60),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? Colors.white : foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: AppTextStyles.micro.copyWith(
                    color: active
                        ? Colors.white.withAlpha(180)
                        : foreground.withAlpha(180),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Application card ──────────────────────────────────────────────────────────

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app});

  final ApplicationResponse app;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = app.applicationDate != null
        ? DateFormat('MMM d, yyyy').format(app.applicationDate!)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card)),
      elevation: 0,
      color: colors.surfaceSecondary,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: () => context.push(AppRoutes.applicationDetail(app.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
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
                          app.companyName,
                          style: AppTextStyles.title
                              .copyWith(color: colors.foreground),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          app.role,
                          style: AppTextStyles.caption
                              .copyWith(color: colors.foregroundSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ApplicationStatusBadge(status: app.status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (app.location != null) ...[
                    Icon(Icons.location_on_outlined,
                        size: 13, color: colors.foregroundTertiary),
                    const SizedBox(width: 3),
                    Text(
                      app.location!,
                      style: AppTextStyles.micro
                          .copyWith(color: colors.foregroundTertiary),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (dateLabel != null) ...[
                    Icon(Icons.calendar_today_outlined,
                        size: 13, color: colors.foregroundTertiary),
                    const SizedBox(width: 3),
                    Text(
                      dateLabel,
                      style: AppTextStyles.micro
                          .copyWith(color: colors.foregroundTertiary),
                    ),
                  ],
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: colors.foregroundSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
