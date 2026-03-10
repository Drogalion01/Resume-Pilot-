import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/score_helper.dart';
import '../../../shared/widgets/score_ring.dart';
import '../data/resume_service.dart';
import '../models/analysis_result.dart';
import '../providers/resume_detail_provider.dart';
import '../widgets/resume_states.dart';

class ResumeAnalysisScreen extends ConsumerWidget {
  const ResumeAnalysisScreen({super.key, required this.resumeId});

  final int resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final analysisAsync = ref.watch(resumeAnalysisProvider(resumeId));

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
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
                // ── AppBar ─────────────────────────────────────────────────
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
                        child: Text(
                          'Analysis Results',
                          style: AppTextStyles.headline
                              .copyWith(color: colors.foreground),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.save_outlined, color: colors.foreground),
                        tooltip: 'Save version',
                        onPressed: () =>
                            _showSaveVersionSheet(context, ref, resumeId),
                      ),
                    ],
                  ),
                ),

                // ── Content ────────────────────────────────────────────────
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
                      child: analysisAsync.when(
                        loading: () => const AnalysisSkeleton(),
                        error: (e, _) => ResumeErrorState(
                          error: e,
                          onRetry: () =>
                              ref.invalidate(resumeAnalysisProvider(resumeId)),
                        ),
                        data: (analysis) =>
                            _AnalysisContent(analysis: analysis, resumeId: resumeId),
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

  void _showSaveVersionSheet(
      BuildContext context, WidgetRef ref, int resumeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SaveVersionSheet(resumeId: resumeId),
    );
  }
}

// ── Analysis content ──────────────────────────────────────────────────────────

class _AnalysisContent extends StatelessWidget {
  const _AnalysisContent({required this.analysis, required this.resumeId});

  final AnalysisResultResponse analysis;
  final int resumeId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final ats = (analysis.atsScore ?? 0).toDouble();
    final rec = (analysis.recruiterScore ?? 0).toDouble();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // ── Dual score hero ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              children: [
                Text(
                  analysis.overallLabel ?? ScoreHelper.labelFromScore(ats),
                  style: AppTextStyles.display
                      .copyWith(color: colors.foreground),
                ),
                const SizedBox(height: 4),
                Text(
                  'Resume Analysis',
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foregroundSecondary),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ScoreCol(
                      score: ats,
                      label: 'ATS Score',
                      size: 110,
                      strokeWidth: 9,
                    ),
                    _ScoreCol(
                      score: rec,
                      label: 'Recruiter Score',
                      size: 110,
                      strokeWidth: 9,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Score Breakdown ──────────────────────────────────────────────
        if (analysis.breakdown.isNotEmpty) ...[
          const _SectionHeader('Score Breakdown'),
          SliverList.builder(
            itemCount: analysis.breakdown.length,
            itemBuilder: (_, i) => _BreakdownBar(
              item: analysis.breakdown[i],
              colors: colors,
            ),
          ),
        ],

        // ── Issues ───────────────────────────────────────────────────────
        if (analysis.issues.isNotEmpty) ...[
          const _SectionHeader('Issues'),
          SliverList.builder(
            itemCount: analysis.issues.length,
            itemBuilder: (_, i) =>
                _IssueRow(item: analysis.issues[i], colors: colors),
          ),
        ],

        // ── Missing Keywords ─────────────────────────────────────────────
        if (analysis.missingKeywords.isNotEmpty) ...[
          const _SectionHeader('Missing Keywords'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageH, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: analysis.missingKeywords
                    .map((k) => _KeywordChip(item: k, colors: colors))
                    .toList(),
              ),
            ),
          ),
        ],

        // ── Rewrites ─────────────────────────────────────────────────────
        if (analysis.rewrites.isNotEmpty) ...[
          const _SectionHeader('Suggested Rewrites'),
          SliverList.builder(
            itemCount: analysis.rewrites.length,
            itemBuilder: (_, i) => _RewriteCard(
              item: analysis.rewrites[i],
              index: i,
              colors: colors,
            ),
          ),
        ],

        // ── Action Plan ───────────────────────────────────────────────────
        if (analysis.actionPlan.isNotEmpty) ...[
          const _SectionHeader('Action Plan'),
          SliverList.builder(
            itemCount: analysis.actionPlan.length,
            itemBuilder: (_, i) => _ActionStep(
              item: analysis.actionPlan[i],
              colors: colors,
            ),
          ),
        ],

        // ── Bottom CTA ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageH, vertical: 20),
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.push(AppRoutes.resumeVersions(resumeId)),
              icon: const Icon(Icons.history_outlined, size: 18),
              label: const Text('View Versions'),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
              height: AppSpacing.bottomNavH + AppSpacing.cardPad),
        ),
      ],
    );
  }
}

// ── Score column ──────────────────────────────────────────────────────────────

class _ScoreCol extends StatelessWidget {
  const _ScoreCol({
    required this.score,
    required this.label,
    required this.size,
    required this.strokeWidth,
  });

  final double score;
  final String label;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      children: [
        ScoreRing(
          score: score,
          size: size,
          strokeWidth: strokeWidth,
          showTier: false,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption
              .copyWith(color: colors.foregroundSecondary),
        ),
      ],
    );
  }
}

// ── Section header sliver ─────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH)
            .copyWith(top: 24, bottom: 10),
        child: Text(
          title,
          style: AppTextStyles.title.copyWith(color: colors.foreground),
        ),
      ),
    );
  }
}

// ── Breakdown bar ─────────────────────────────────────────────────────────────

class _BreakdownBar extends StatelessWidget {
  const _BreakdownBar({required this.item, required this.colors});

  final BreakdownItem item;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final barColor = ScoreHelper.colorFromScore(
      item.maxScore > 0 ? (item.score / item.maxScore * 100) : 0,
      colors,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.category,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: colors.foreground)),
              ),
              Text(
                '${item.score}/${item.maxScore}',
                style: AppTextStyles.caption
                    .copyWith(color: colors.foregroundSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.fraction,
              backgroundColor: colors.surfaceSecondary,
              valueColor: AlwaysStoppedAnimation(barColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Issue row ─────────────────────────────────────────────────────────────────

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.item, required this.colors});

  final IssueItem item;
  final AppColors colors;

  static Color _severityColor(String s, AppColors c) => switch (s) {
        'high'   => c.statusRejected,
        'medium' => c.statusAssessment,
        _        => c.statusApplied,
      };

  static Color _severityBg(String s, AppColors c) => switch (s) {
        'high'   => c.statusRejectedBg,
        'medium' => c.statusAssessmentBg,
        _        => c.statusAppliedBg,
      };

  static IconData _severityIcon(String s) => switch (s) {
        'high'   => Icons.error_outline,
        'medium' => Icons.warning_amber_outlined,
        _        => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final fg = _severityColor(item.severity, colors);
    final bg = _severityBg(item.severity, colors);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(_severityIcon(item.severity), color: fg, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppRadii.badge),
                  ),
                  child: Text(
                    item.severity.toUpperCase(),
                    style: AppTextStyles.micro.copyWith(
                        color: fg, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: AppTextStyles.caption
                      .copyWith(color: colors.foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Keyword chip ──────────────────────────────────────────────────────────────

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.item, required this.colors});

  final MissingKeywordItem item;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (item.priority) {
      'high' => (colors.statusRejectedBg, colors.statusRejected),
      'medium' => (colors.statusAssessmentBg, colors.statusAssessment),
      _ => (colors.surfaceSecondary, colors.foregroundSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Text(
        item.word,
        style: AppTextStyles.caption
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Rewrite card ──────────────────────────────────────────────────────────────

class _RewriteCard extends StatefulWidget {
  const _RewriteCard({
    required this.item,
    required this.index,
    required this.colors,
  });

  final RewriteItem item;
  final int index;
  final AppColors colors;

  @override
  State<_RewriteCard> createState() => _RewriteCardState();
}

class _RewriteCardState extends State<_RewriteCard> {
  bool _expanded = false;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(AppRadii.card),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rewrite ${widget.index + 1}',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.foreground,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: colors.foregroundSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(
                  height: 1,
                  color: colors.primaryMuted.withAlpha(80)),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Original',
                        style: AppTextStyles.micro.copyWith(
                            color: colors.foregroundSecondary,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(widget.item.original,
                        style: AppTextStyles.caption.copyWith(
                            color: colors.foreground)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Improved',
                              style: AppTextStyles.micro.copyWith(
                                  color: colors.scoreExcellent,
                                  fontWeight: FontWeight.w700)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: widget.item.improved));
                            setState(() => _copied = true);
                            await Future.delayed(
                                const Duration(seconds: 2));
                            if (mounted) {
                              setState(() => _copied = false);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _copied
                                    ? Icons.check_rounded
                                    : Icons.copy_outlined,
                                size: 16,
                                color: _copied
                                    ? colors.scoreExcellent
                                    : colors.foregroundSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _copied ? 'Copied!' : 'Copy',
                                style: AppTextStyles.micro.copyWith(
                                  color: _copied
                                      ? colors.scoreExcellent
                                      : colors.foregroundSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.scoreExcellentBg,
                        borderRadius:
                            BorderRadius.circular(AppRadii.cardSm),
                      ),
                      child: Text(
                        widget.item.improved,
                        style: AppTextStyles.caption
                            .copyWith(color: colors.scoreExcellent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Action step ───────────────────────────────────────────────────────────────

class _ActionStep extends StatelessWidget {
  const _ActionStep({required this.item, required this.colors});

  final ActionPlanItem item;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryButton(colors),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.step}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description,
                    style: AppTextStyles.caption
                        .copyWith(color: colors.foreground)),
                if (item.potentialGain != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.potentialGain!,
                    style: AppTextStyles.micro.copyWith(
                        color: colors.scoreExcellent,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Save version bottom sheet ─────────────────────────────────────────────────

class _SaveVersionSheet extends ConsumerStatefulWidget {
  const _SaveVersionSheet({required this.resumeId});

  final int resumeId;

  @override
  ConsumerState<_SaveVersionSheet> createState() => _SaveVersionSheetState();
}

class _SaveVersionSheetState extends ConsumerState<_SaveVersionSheet> {
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  bool _saving = false;
  String? _errorMsg;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() { _saving = true; _errorMsg = null; });
    try {
      final svc = ref.read(resumeServiceProvider);
      await svc.createResumeVersion(
        widget.resumeId,
        versionName: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        targetRole:  _roleCtrl.text.trim().isEmpty ? null : _roleCtrl.text.trim(),
        companyName: _companyCtrl.text.trim().isEmpty ? null : _companyCtrl.text.trim(),
      );
      ref.invalidate(resumeVersionsProvider(widget.resumeId));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() { _saving = false; _errorMsg = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Save Version',
              style: AppTextStyles.headline.copyWith(color: colors.foreground)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Version Name',
              hintText: 'e.g. Google SWE v2',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _roleCtrl,
            decoration: const InputDecoration(
              labelText: 'Target Role',
              hintText: 'e.g. Senior Engineer',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _companyCtrl,
            decoration: const InputDecoration(
              labelText: 'Company',
              hintText: 'e.g. Google',
            ),
          ),
          if (_errorMsg != null) ...[
            const SizedBox(height: 8),
            Text(_errorMsg!,
                style: AppTextStyles.caption.copyWith(color: colors.statusRejected)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
