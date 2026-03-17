import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../providers/resume_list_provider.dart';
import '../providers/upload_provider.dart';

class ResumeUploadScreen extends ConsumerStatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  ConsumerState<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends ConsumerState<ResumeUploadScreen> {
  final _pasteController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _jdController = TextEditingController();

  @override
  void dispose() {
    _pasteController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  void _onAnalyze(UploadNotifier notifier, UploadState state) {
    notifier.setTargetRole(_roleController.text.trim().isEmpty
        ? null
        : _roleController.text.trim());
    notifier.setCompanyName(_companyController.text.trim().isEmpty
        ? null
        : _companyController.text.trim());
    notifier.setJdText(
        _jdController.text.trim().isEmpty ? null : _jdController.text.trim());

    notifier.triggerAnalyze(
      state is UploadFilePicked ? state : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final notifier = ref.read(uploadProvider.notifier);
    final state = ref.watch(uploadProvider);

    // Navigate on success
    ref.listen<UploadState>(uploadProvider, (_, next) {
      if (next is UploadSuccess) {
        ref.invalidate(resumeListProvider);
            ref.invalidate(dashboardProvider);
            context.pushReplacement(
          AppRoutes.resumeAnalysis(next.analysis.resumeId),
        );
      }
    });

    final isLoading = state is UploadLoading;
    final isFileMode = notifier.isFileMode;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  // ── Custom AppBar ──────────────────────────────────────────
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
                        const SizedBox(width: 4),
                        Text(
                          'Upload Resume',
                          style: AppTextStyles.headline
                              .copyWith(color: colors.foreground),
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
                        boxShadow:
                            AppShadows.elevated(Theme.of(context).brightness),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadii.xl2)),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.pageH, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ── Input mode toggle ──────────────────────────
                              SegmentedButton<bool>(
                                segments: const [
                                  ButtonSegment(
                                    value: true,
                                    label: Text('Upload File'),
                                    icon: Icon(Icons.upload_file_outlined),
                                  ),
                                  ButtonSegment(
                                    value: false,
                                    label: Text('Paste Text'),
                                    icon: Icon(Icons.text_snippet_outlined),
                                  ),
                                ],
                                selected: {isFileMode},
                                onSelectionChanged: (s) =>
                                    notifier.setMode(s.first),
                              ),

                              const SizedBox(height: 20),

                              // ── File zone or paste ─────────────────────────
                              if (isFileMode)
                                _FileZone(state: state, notifier: notifier)
                              else
                                _PasteZone(
                                  controller: _pasteController,
                                  onChanged: notifier.setPastedText,
                                ),

                              const SizedBox(height: 20),

                              // ── Optional fields ────────────────────────────
                              Text(
                                'Improve Analysis (Optional)',
                                style: AppTextStyles.title
                                    .copyWith(color: colors.foreground),
                              ),
                              const SizedBox(height: 12),
                              _OptionalField(
                                controller: _roleController,
                                label: 'Target Role',
                                hint: 'e.g. Senior Product Manager',
                                icon: Icons.work_outline,
                              ),
                              const SizedBox(height: 10),
                              _OptionalField(
                                controller: _companyController,
                                label: 'Company',
                                hint: 'e.g. Google',
                                icon: Icons.business_outlined,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _jdController,
                                onChanged: notifier.setJdText,
                                maxLines: 5,
                                maxLength: 3000,
                                decoration: const InputDecoration(
                                  labelText: 'Paste Job Description',
                                  hintText:
                                      'Paste the job posting here to improve keyword matching…',
                                  alignLabelWithHint: true,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 64),
                                    child: Icon(Icons.article_outlined),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              // ── Error banner ───────────────────────────────
                              if (state is UploadError)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.statusRejectedBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: colors.statusRejected,
                                          size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          (state).message,
                                          style: AppTextStyles.caption.copyWith(
                                              color: colors.statusRejected),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // ── Analyze button ─────────────────────────────
                              if (isLoading)
                                const Column(
                                  children: [
                                    LinearProgressIndicator(),
                                    SizedBox(height: 8),
                                    Text(
                                      'Analyzing your resume…',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              else
                                FilledButton.icon(
                                  onPressed: notifier.canAnalyze
                                      ? () => _onAnalyze(notifier, state)
                                      : null,
                                  icon: const Icon(Icons.auto_awesome_outlined,
                                      size: 18),
                                  label: const Text('Analyze Resume'),
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(
                                        AppSpacing.buttonH),
                                  ),
                                ),

                              const SizedBox(
                                  height: AppSpacing.bottomNavH +
                                      AppSpacing.cardPad),
                            ],
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
    );
  }
}

// ── File zone widget ──────────────────────────────────────────────────────────

class _FileZone extends StatelessWidget {
  const _FileZone({required this.state, required this.notifier});

  final UploadState state;
  final UploadNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    if (state is UploadFilePicked) {
      final picked = state as UploadFilePicked;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: colors.primary.withAlpha(80)),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file_outlined,
                color: colors.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    picked.fileName,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.foreground, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    picked.extension.toUpperCase(),
                    style: AppTextStyles.micro
                        .copyWith(color: colors.foregroundSecondary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: notifier.clearFile,
              child: const Text('Change'),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: notifier.pickFile,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(
            color: colors.primaryMuted,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: colors.primary, size: 36),
            const SizedBox(height: 8),
            Text(
              'Tap to select a file',
              style:
                  AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF • DOCX  ·  Max 10 MB',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Paste zone widget ─────────────────────────────────────────────────────────

class _PasteZone extends StatelessWidget {
  const _PasteZone({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 10,
      maxLength: 10000,
      decoration: const InputDecoration(
        labelText: 'Resume Text',
        hintText: 'Paste your full resume content here…',
        alignLabelWithHint: true,
      ),
    );
  }
}

// ── Optional field ────────────────────────────────────────────────────────────

class _OptionalField extends StatelessWidget {
  const _OptionalField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
