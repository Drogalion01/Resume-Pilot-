import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../data/resume_service.dart';
import '../models/resume_version.dart';
import '../providers/resume_detail_provider.dart';
import '../widgets/resume_states.dart';

class ResumeVersionDetailScreen extends ConsumerWidget {
  const ResumeVersionDetailScreen({super.key, required this.resumeId});

  final int resumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final resumeAsync = ref.watch(resumeDetailProvider(resumeId));
    final versionsAsync = ref.watch(resumeVersionsProvider(resumeId));

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      appBar: AppBar(
        backgroundColor: colors.surfacePrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: resumeAsync.maybeWhen(
          data: (r) => Text(
            r.title,
            style: AppTextStyles.title.copyWith(color: colors.foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          orElse: () => const SizedBox.shrink(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome_outlined, color: colors.primary),
            tooltip: 'View analysis',
            onPressed: () => context.push(AppRoutes.resumeAnalysis(resumeId)),
          ),
          IconButton(
            icon: Icon(Icons.add_outlined, color: colors.foreground),
            tooltip: 'Save new version',
            onPressed: () => _showSaveSheet(context, ref, resumeId),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Resume metadata ──────────────────────────────────────────
          resumeAsync.maybeWhen(
            data: (resume) => _MetaRow(resume: resume, colors: colors),
            orElse: () => const SizedBox.shrink(),
          ),

          // ── Versions list ────────────────────────────────────────────
          Expanded(
            child: versionsAsync.when(
              loading: () => const ResumeListSkeleton(),
              error: (e, _) => ResumeErrorState(
                error: e,
                onRetry: () => ref.invalidate(resumeVersionsProvider(resumeId)),
              ),
              data: (versions) {
                if (versions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.layers_outlined,
                              color: colors.foregroundSecondary, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'No saved versions',
                            style: AppTextStyles.title
                                .copyWith(color: colors.foreground),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Save a version to track iterations targeted at specific roles or companies.',
                            style: AppTextStyles.caption
                                .copyWith(color: colors.foregroundSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 12),
                  itemCount: versions.length,
                  itemBuilder: (_, i) => _VersionTile(
                    version: versions[i],
                    resumeId: resumeId,
                    onDuplicate: () => ref
                        .read(resumeVersionsProvider(resumeId).notifier)
                        .duplicateVersion(versions[i].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveSheet(BuildContext ctx, WidgetRef ref, int resumeId) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) => _SaveVersionSheet(resumeId: resumeId),
    );
  }
}

// ── Metadata row ──────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.resume, required this.colors});

  final ResumeResponse resume;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d, yyyy').format(resume.createdAt.toLocal());
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: colors.primaryMuted.withAlpha(60), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined,
              color: colors.foregroundSecondary, size: 16),
          const SizedBox(width: 6),
          Text(date,
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadii.badge),
            ),
            child: Text(
              resume.fileTypeLabel,
              style: AppTextStyles.micro
                  .copyWith(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Version tile ──────────────────────────────────────────────────────────────

class _VersionTile extends StatelessWidget {
  const _VersionTile({
    required this.version,
    required this.resumeId,
    required this.onDuplicate,
  });

  final ResumeVersionResponse version;
  final int resumeId;
  final VoidCallback onDuplicate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final displayName =
        version.versionName ?? version.targetRole ?? 'Version #${version.id}';
    final subtitle = [
      if (version.targetRole != null) version.targetRole!,
      if (version.companyName != null) version.companyName!,
    ].join(' · ');
    final date = DateFormat('MMM d').format(version.createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card)),
      elevation: 0,
      color: colors.surfaceSecondary,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.primaryMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.layers_outlined, color: colors.primary, size: 20),
        ),
        title: Text(
          displayName,
          style: AppTextStyles.bodyMedium
              .copyWith(color: colors.foreground, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: AppTextStyles.caption
                    .copyWith(color: colors.foregroundSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                date,
                style: AppTextStyles.caption
                    .copyWith(color: colors.foregroundSecondary),
              ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded,
              color: colors.foregroundSecondary, size: 20),
          onSelected: (v) {
            if (v == 'duplicate') onDuplicate();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.copy_all_outlined),
                title: Text('Duplicate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Save version sheet ────────────────────────────────────────────────────────

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
  String? _err;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _err = null;
    });
    try {
      final svc = ref.read(resumeServiceProvider);
      await svc.createResumeVersion(
        widget.resumeId,
        versionName:
            _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        targetRole:
            _roleCtrl.text.trim().isEmpty ? null : _roleCtrl.text.trim(),
        companyName:
            _companyCtrl.text.trim().isEmpty ? null : _companyCtrl.text.trim(),
      );
      ref.invalidate(resumeVersionsProvider(widget.resumeId));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _saving = false;
        _err = e.toString();
      });
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
            decoration: const InputDecoration(labelText: 'Version Name'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _roleCtrl,
            decoration: const InputDecoration(labelText: 'Target Role'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _companyCtrl,
            decoration: const InputDecoration(labelText: 'Company'),
          ),
          if (_err != null) ...[
            const SizedBox(height: 8),
            Text(_err!,
                style: AppTextStyles.caption
                    .copyWith(color: colors.statusRejected)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Save Version'),
          ),
        ],
      ),
    );
  }
}
