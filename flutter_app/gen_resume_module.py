"""
ResumePilot Flutter — Resume module generator.
Run from flutter_app/ directory: python gen_resume_module.py
"""
import os

BASE = r"f:\Resume Pilot app\flutter_app\lib"

files = {}

# ─────────────────────────────────────────────────────────────────────────────
# 1. score_helper.dart
# ─────────────────────────────────────────────────────────────────────────────
files["core/utils/score_helper.dart"] = r"""
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum ScoreTier { excellent, good, average, poor }

abstract class ScoreHelper {
  static ScoreTier tierFromScore(num score) {
    if (score >= 80) return ScoreTier.excellent;
    if (score >= 65) return ScoreTier.good;
    if (score >= 45) return ScoreTier.average;
    return ScoreTier.poor;
  }

  static ScoreTier tierFromLabel(String? label) {
    switch (label?.toLowerCase()) {
      case 'excellent':
        return ScoreTier.excellent;
      case 'good':
        return ScoreTier.good;
      case 'average':
        return ScoreTier.average;
      default:
        return ScoreTier.poor;
    }
  }

  static Color colorFromScore(num score, AppColors colors) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => colors.scoreExcellent,
        ScoreTier.good      => colors.scoreGood,
        ScoreTier.average   => colors.scoreAverage,
        ScoreTier.poor      => colors.scorePoor,
      };

  static Color bgColorFromScore(num score, AppColors colors) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => colors.scoreExcellentBg,
        ScoreTier.good      => colors.scoreGoodBg,
        ScoreTier.average   => colors.scoreAverageBg,
        ScoreTier.poor      => colors.scorePoorBg,
      };

  static String labelFromScore(num score) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => 'Excellent',
        ScoreTier.good      => 'Good',
        ScoreTier.average   => 'Average',
        ScoreTier.poor      => 'Poor',
      };
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 2. score_ring.dart
# ─────────────────────────────────────────────────────────────────────────────
files["shared/widgets/score_ring.dart"] = r"""
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/score_helper.dart';

/// Animated arc score ring.
///
/// [score] is 0–100. The arc starts at 135° and sweeps 270° clockwise.
class ScoreRing extends StatefulWidget {
  const ScoreRing({
    super.key,
    required this.score,
    this.size = 80.0,
    this.strokeWidth = 7.0,
    this.showLabel = true,
    this.showTier = false,
    this.animated = true,
    this.centerLabel,
  });

  final double score;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final bool showTier;
  final bool animated;

  /// Optional extra label shown below the score number (e.g. "ATS Score").
  final String? centerLabel;

  @override
  State<ScoreRing> createState() => _ScoreRingState();
}

class _ScoreRingState extends State<ScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration:
          widget.animated ? const Duration(milliseconds: 900) : Duration.zero,
      vsync: this,
    );
    _anim = Tween<double>(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(ScoreRing old) {
    super.didUpdateWidget(old);
    if (old.score != widget.score) {
      _anim = Tween<double>(begin: old.score, end: widget.score).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final v = _anim.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RingPainter(
              score: v,
              strokeWidth: widget.strokeWidth,
              fillColor: ScoreHelper.colorFromScore(v, colors),
              trackColor: ScoreHelper.bgColorFromScore(v, colors),
            ),
            child: widget.showLabel
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          v.round().toString(),
                          style: AppTextStyles.scoreNumber
                              .copyWith(color: colors.foreground),
                        ),
                        if (widget.showTier)
                          Text(
                            ScoreHelper.labelFromScore(v),
                            style: AppTextStyles.micro.copyWith(
                              color: ScoreHelper.colorFromScore(v, colors),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (widget.centerLabel != null)
                          Text(
                            widget.centerLabel!,
                            style: AppTextStyles.micro.copyWith(
                              color: colors.foregroundSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.score,
    required this.strokeWidth,
    required this.fillColor,
    required this.trackColor,
  });

  final double score;
  final double strokeWidth;
  final Color fillColor;
  final Color trackColor;

  static const double _start = 135 * math.pi / 180;
  static const double _total = 270 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: c, radius: r);

    final base = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _start, _total, false, base);
    final sweep = (score / 100).clamp(0.0, 1.0) * _total;
    if (sweep > 0) canvas.drawArc(rect, _start, sweep, false, fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.score != score || old.fillColor != fillColor;
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 3. analysis_result.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/models/analysis_result.dart"] = r"""
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

// ── Nested items ─────────────────────────────────────────────────────────────

@freezed
class BreakdownItem with _$BreakdownItem {
  const factory BreakdownItem({
    required String category,
    required int score,
    @JsonKey(name: 'max_score') required int maxScore,
  }) = _BreakdownItem;

  factory BreakdownItem.fromJson(Map<String, dynamic> json) =>
      _$BreakdownItemFromJson(json);
}

extension BreakdownItemX on BreakdownItem {
  double get fraction =>
      maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class IssueItem with _$IssueItem {
  const factory IssueItem({
    required String severity,
    required String description,
  }) = _IssueItem;

  factory IssueItem.fromJson(Map<String, dynamic> json) =>
      _$IssueItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class MissingKeywordItem with _$MissingKeywordItem {
  const factory MissingKeywordItem({
    required String word,
    required String priority,
  }) = _MissingKeywordItem;

  factory MissingKeywordItem.fromJson(Map<String, dynamic> json) =>
      _$MissingKeywordItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class RewriteItem with _$RewriteItem {
  const factory RewriteItem({
    required String original,
    required String improved,
  }) = _RewriteItem;

  factory RewriteItem.fromJson(Map<String, dynamic> json) =>
      _$RewriteItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class ActionPlanItem with _$ActionPlanItem {
  const factory ActionPlanItem({
    required int step,
    required String description,
    @JsonKey(name: 'potential_gain') String? potentialGain,
  }) = _ActionPlanItem;

  factory ActionPlanItem.fromJson(Map<String, dynamic> json) =>
      _$ActionPlanItemFromJson(json);
}

// ── Root response ─────────────────────────────────────────────────────────────

@freezed
class AnalysisResultResponse with _$AnalysisResultResponse {
  const factory AnalysisResultResponse({
    required int id,
    @JsonKey(name: 'resume_id') required int resumeId,
    @JsonKey(name: 'resume_version_id') int? resumeVersionId,
    @JsonKey(name: 'overall_score') int? overallScore,
    @JsonKey(name: 'ats_score') int? atsScore,
    @JsonKey(name: 'recruiter_score') int? recruiterScore,
    @JsonKey(name: 'overall_label') String? overallLabel,
    @Default([]) List<BreakdownItem> breakdown,
    @Default([]) List<IssueItem> issues,
    @JsonKey(name: 'missing_keywords')
    @Default([])
    List<MissingKeywordItem> missingKeywords,
    @Default([]) List<RewriteItem> rewrites,
    @JsonKey(name: 'action_plan')
    @Default([])
    List<ActionPlanItem> actionPlan,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AnalysisResultResponse;

  factory AnalysisResultResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultResponseFromJson(json);
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 4. resume_service.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/data/resume_service.dart"] = r"""
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/analysis_result.dart';
import '../models/resume_version.dart';

class ResumeService {
  const ResumeService(this._dio);

  final Dio _dio;

  // ── List & Detail ──────────────────────────────────────────────────────────

  Future<List<ResumeResponse>> getResumes() async {
    final res = await _dio.get<List<dynamic>>('/resumes');
    return res.data!
        .map((e) => ResumeResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ResumeResponse> getResumeById(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/resumes/$id');
    return ResumeResponse.fromJson(res.data!);
  }

  // ── Versions ───────────────────────────────────────────────────────────────

  Future<List<ResumeVersionResponse>> getResumeVersions(int resumeId) async {
    final res =
        await _dio.get<List<dynamic>>('/resumes/$resumeId/versions');
    return res.data!
        .map((e) => ResumeVersionResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ResumeVersionResponse> createResumeVersion(
    int resumeId, {
    String? versionName,
    String? targetRole,
    String? companyName,
    String? tag,
    String? editedText,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/resumes/$resumeId/versions',
      data: {
        if (versionName != null) 'version_name': versionName,
        if (targetRole != null) 'target_role': targetRole,
        if (companyName != null) 'company_name': companyName,
        if (tag != null) 'tag': tag,
        if (editedText != null) 'edited_text': editedText,
      },
    );
    return ResumeVersionResponse.fromJson(res.data!);
  }

  Future<ResumeVersionResponse> updateResumeVersion(
    int versionId, {
    String? versionName,
    String? targetRole,
    String? companyName,
    String? tag,
    String? editedText,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/resume-versions/$versionId',
      data: {
        if (versionName != null) 'version_name': versionName,
        if (targetRole != null) 'target_role': targetRole,
        if (companyName != null) 'company_name': companyName,
        if (tag != null) 'tag': tag,
        if (editedText != null) 'edited_text': editedText,
      },
    );
    return ResumeVersionResponse.fromJson(res.data!);
  }

  Future<ResumeVersionResponse> duplicateResumeVersion(int versionId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/resume-versions/$versionId/duplicate',
    );
    return ResumeVersionResponse.fromJson(res.data!);
  }

  // ── Analysis ───────────────────────────────────────────────────────────────

  Future<AnalysisResultResponse> getResumeAnalysis(int resumeId) async {
    final res =
        await _dio.get<Map<String, dynamic>>('/resumes/$resumeId/analysis');
    return AnalysisResultResponse.fromJson(res.data!);
  }

  /// Uploads a resume file or pasted text and triggers AI analysis.
  ///
  /// [fileBytes] + [fileName] → multipart file upload.
  /// [pastedText]            → plain-text path.
  /// At least one of [fileBytes] or [pastedText] is required.
  Future<AnalysisResultResponse> analyzeResume({
    List<int>? fileBytes,
    String? fileName,
    String? pastedText,
    String? targetRole,
    String? companyName,
    String? jdText,
  }) async {
    final form = FormData();

    if (fileBytes != null && fileName != null) {
      form.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(fileBytes, filename: fileName),
      ));
    }
    if (pastedText != null) form.fields.add(MapEntry('pasted_text', pastedText));
    if (targetRole != null) form.fields.add(MapEntry('target_role', targetRole));
    if (companyName != null) {
      form.fields.add(MapEntry('company_name', companyName));
    }
    if (jdText != null) form.fields.add(MapEntry('jd_text', jdText));

    final res = await _dio.post<Map<String, dynamic>>(
      '/resumes/analyze',
      data: form,
    );
    return AnalysisResultResponse.fromJson(res.data!);
  }
}

final resumeServiceProvider = Provider<ResumeService>(
  (ref) => ResumeService(ref.watch(dioProvider)),
);
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 5. upload_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/providers/upload_provider.dart"] = r"""
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/resume_service.dart';
import '../models/analysis_result.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class UploadState {
  const UploadState();
}

class UploadIdle extends UploadState {
  const UploadIdle();
}

class UploadFilePicked extends UploadState {
  const UploadFilePicked({
    required this.fileName,
    required this.fileBytes,
    required this.extension,
  });

  final String fileName;
  final List<int> fileBytes;
  final String extension;
}

class UploadLoading extends UploadState {
  const UploadLoading();
}

class UploadSuccess extends UploadState {
  const UploadSuccess({required this.analysis});

  final AnalysisResultResponse analysis;
}

class UploadError extends UploadState {
  const UploadError(this.message);

  final String message;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class UploadNotifier extends AutoDisposeNotifier<UploadState> {
  // Persisted across state changes
  String? _pastedText;
  String? targetRole;
  String? companyName;
  String? jdText;
  bool _fileMode = true; // true = file picker, false = paste text

  @override
  UploadState build() => const UploadIdle();

  bool get isFileMode => _fileMode;

  void setMode(bool fileMode) {
    _fileMode = fileMode;
    if (fileMode) {
      state = const UploadIdle();
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) {
      state = const UploadError('Could not read file. Try again.');
      return;
    }
    final sizeMb = file.size / (1024 * 1024);
    if (sizeMb > 10) {
      state = const UploadError('File too large. Maximum size is 10 MB.');
      return;
    }
    state = UploadFilePicked(
      fileName: file.name,
      fileBytes: file.bytes!,
      extension: file.extension ?? 'pdf',
    );
  }

  void clearFile() => state = const UploadIdle();

  void setPastedText(String text) => _pastedText = text;
  void setTargetRole(String? v) => targetRole = v;
  void setCompanyName(String? v) => companyName = v;
  void setJdText(String? v) => jdText = v;

  bool get canAnalyze {
    if (_fileMode) return state is UploadFilePicked;
    return _pastedText != null && _pastedText!.trim().isNotEmpty;
  }

  Future<void> analyze() async {
    if (!canAnalyze) return;
    state = const UploadLoading();
    try {
      final service = ref.read(resumeServiceProvider);
      final AnalysisResultResponse result;

      if (_fileMode && state is! UploadLoading) {
        // state was replaced — shouldn't happen but guard
        return;
      }

      if (_fileMode) {
        // Re-read the picked file from the previous state value
        // (state is now UploadLoading; fileBytes were stored before)
        // We store fileBytes in local variable before transitioning:
        // This will be resolved in triggerAnalyze below.
        return;
      }

      result = await service.analyzeResume(
        pastedText: _pastedText,
        targetRole: targetRole,
        companyName: companyName,
        jdText: jdText,
      );

      ref.invalidateSelf(); // will be rebuilt with success
      state = UploadSuccess(analysis: result);
    } catch (e) {
      state = UploadError(
        e is AppException ? e.userMessage : 'Analysis failed. Please try again.',
      );
    }
  }

  /// Primary entry point called by Upload button.
  Future<void> triggerAnalyze(UploadFilePicked? picked) async {
    if (!canAnalyze) return;
    state = const UploadLoading();
    try {
      final service = ref.read(resumeServiceProvider);
      final AnalysisResultResponse result;

      if (_fileMode && picked != null) {
        result = await service.analyzeResume(
          fileBytes: picked.fileBytes,
          fileName: picked.fileName,
          targetRole: targetRole,
          companyName: companyName,
          jdText: jdText,
        );
      } else {
        result = await service.analyzeResume(
          pastedText: _pastedText,
          targetRole: targetRole,
          companyName: companyName,
          jdText: jdText,
        );
      }

      state = UploadSuccess(analysis: result);
    } catch (e) {
      state = UploadError(
        e is AppException ? e.userMessage : 'Analysis failed. Please try again.',
      );
    }
  }
}

final uploadProvider =
    AutoDisposeNotifierProvider<UploadNotifier, UploadState>(
  UploadNotifier.new,
);
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 6. resume_list_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/providers/resume_list_provider.dart"] = r"""
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/resume_service.dart';
import '../models/resume_version.dart';

class ResumeListNotifier
    extends AsyncNotifier<List<ResumeResponse>> {
  @override
  Future<List<ResumeResponse>> build() =>
      ref.watch(resumeServiceProvider).getResumes();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final resumeListProvider =
    AsyncNotifierProvider<ResumeListNotifier, List<ResumeResponse>>(
  ResumeListNotifier.new,
);
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 7. resume_detail_provider.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/providers/resume_detail_provider.dart"] = r"""
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/resume_service.dart';
import '../models/analysis_result.dart';
import '../models/resume_version.dart';

// ── Resume versions for a specific base resume ────────────────────────────────

class ResumeVersionsNotifier
    extends FamilyAsyncNotifier<List<ResumeVersionResponse>, int> {
  @override
  Future<List<ResumeVersionResponse>> build(int resumeId) =>
      ref.watch(resumeServiceProvider).getResumeVersions(resumeId);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> duplicateVersion(int versionId) async {
    final newVersion = await ref
        .read(resumeServiceProvider)
        .duplicateResumeVersion(versionId);
    state = AsyncData([...?state.valueOrNull, newVersion]);
  }
}

final resumeVersionsProvider = AsyncNotifierProviderFamily<
    ResumeVersionsNotifier, List<ResumeVersionResponse>, int>(
  ResumeVersionsNotifier.new,
);

// ── Single resume detail ───────────────────────────────────────────────────────

class ResumeDetailNotifier
    extends FamilyAsyncNotifier<ResumeResponse, int> {
  @override
  Future<ResumeResponse> build(int resumeId) =>
      ref.watch(resumeServiceProvider).getResumeById(resumeId);
}

final resumeDetailProvider =
    AsyncNotifierProviderFamily<ResumeDetailNotifier, ResumeResponse, int>(
  ResumeDetailNotifier.new,
);

// ── Analysis for a specific resume ────────────────────────────────────────────

class ResumeAnalysisNotifier
    extends FamilyAsyncNotifier<AnalysisResultResponse, int> {
  @override
  Future<AnalysisResultResponse> build(int resumeId) =>
      ref.watch(resumeServiceProvider).getResumeAnalysis(resumeId);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final resumeAnalysisProvider = AsyncNotifierProviderFamily<
    ResumeAnalysisNotifier, AnalysisResultResponse, int>(
  ResumeAnalysisNotifier.new,
);

// ── Save version action ────────────────────────────────────────────────────────

typedef SaveVersionParams = ({
  int resumeId,
  String? versionName,
  String? targetRole,
  String? companyName,
  String? tag,
});

final saveVersionProvider = FutureProvider.autoDispose
    .family<ResumeVersionResponse, SaveVersionParams>((ref, params) async {
  final svc = ref.read(resumeServiceProvider);
  final version = await svc.createResumeVersion(
    params.resumeId,
    versionName: params.versionName,
    targetRole: params.targetRole,
    companyName: params.companyName,
    tag: params.tag,
  );
  ref.invalidate(resumeVersionsProvider(params.resumeId));
  return version;
});
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 8. resume_states.dart  (new — widgets folder)
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/widgets/resume_states.dart"] = r"""
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Box(width: 110, height: 110, radius: 55),
                _Box(width: 110, height: 110, radius: 55),
              ],
            ),
            const SizedBox(height: 24),
            _Box(width: 160, height: 14, radius: 6),
            const SizedBox(height: 12),
            ..._bars(4),
            const SizedBox(height: 20),
            _Box(width: 120, height: 14, radius: 6),
            const SizedBox(height: 12),
            ..._bars(3),
            const SizedBox(height: 20),
            _Box(width: 140, height: 14, radius: 6),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                6,
                (_) => _Box(width: 72, height: 28, radius: AppRadii.chip),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _bars(int n) => List.generate(
        n,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Box(width: double.infinity, height: 10, radius: 4),
              const SizedBox(height: 4),
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
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageH, vertical: 16),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              _Box(width: 48, height: 48, radius: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Box(width: double.infinity, height: 14, radius: 6),
                    const SizedBox(height: 6),
                    _Box(width: 120, height: 12, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
              style: AppTextStyles.headline
                  .copyWith(color: colors.foreground),
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 9. resume_upload_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/screens/resume_upload_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/resume_list_provider.dart';
import '../providers/upload_provider.dart';

class ResumeUploadScreen extends ConsumerStatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  ConsumerState<ResumeUploadScreen> createState() =>
      _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends ConsumerState<ResumeUploadScreen> {
  final _pasteController = TextEditingController();
  final _roleController  = TextEditingController();
  final _companyController = TextEditingController();
  final _jdController    = TextEditingController();

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
    notifier.setJdText(_jdController.text.trim().isEmpty
        ? null
        : _jdController.text.trim());

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

          SafeArea(
            child: Column(
              children: [
                // ── Custom AppBar ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
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
                        padding: EdgeInsets.symmetric(
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
                              decoration: InputDecoration(
                                labelText: 'Paste Job Description',
                                hintText:
                                    'Paste the job posting here to improve keyword matching…',
                                alignLabelWithHint: true,
                                prefixIcon: const Padding(
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

                            SizedBox(
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
                        color: colors.foreground,
                        fontWeight: FontWeight.w600),
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
              style: AppTextStyles.bodyMedium
                  .copyWith(color: colors.foreground),
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 10. resume_analysis_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/screens/resume_analysis_screen.dart"] = r"""
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
                  padding: EdgeInsets.symmetric(
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
          _SectionHeader('Score Breakdown'),
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
          _SectionHeader('Issues'),
          SliverList.builder(
            itemCount: analysis.issues.length,
            itemBuilder: (_, i) =>
                _IssueRow(item: analysis.issues[i], colors: colors),
          ),
        ],

        // ── Missing Keywords ─────────────────────────────────────────────
        if (analysis.missingKeywords.isNotEmpty) ...[
          _SectionHeader('Missing Keywords'),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
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
          _SectionHeader('Suggested Rewrites'),
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
          _SectionHeader('Action Plan'),
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
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pageH, vertical: 20),
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.push(AppRoutes.resumeVersions(resumeId)),
              icon: const Icon(Icons.history_outlined, size: 18),
              label: const Text('View Versions'),
            ),
          ),
        ),

        SliverToBoxAdapter(
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
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageH)
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
      padding: EdgeInsets.symmetric(
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
      padding: EdgeInsets.symmetric(
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
      padding: EdgeInsets.symmetric(
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
      padding: EdgeInsets.symmetric(
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 11. resume_versions_screen.dart  (the main /resumes tab)
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/screens/resume_versions_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
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
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH, vertical: 16)
                  .copyWith(bottom: 8),
              child: Row(
                children: [
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
                      padding: EdgeInsets.symmetric(
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: () => context.push(AppRoutes.resumeDetail(resume.id)),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primaryMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.description_outlined,
              color: colors.primary, size: 22),
        ),
        title: Text(
          resume.title,
          style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          dateLabel,
          style: AppTextStyles.caption
              .copyWith(color: colors.foregroundSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Badge(
                label: resume.fileTypeLabel, colors: colors),
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
          style: AppTextStyles.micro.copyWith(
              color: colors.primary, fontWeight: FontWeight.w600),
        ),
      );
}
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# 12. resume_version_detail_screen.dart
# ─────────────────────────────────────────────────────────────────────────────
files["features/resume/screens/resume_version_detail_screen.dart"] = r"""
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
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
            onPressed: () =>
                context.push(AppRoutes.resumeAnalysis(resumeId)),
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
                onRetry: () =>
                    ref.invalidate(resumeVersionsProvider(resumeId)),
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
                            style: AppTextStyles.caption.copyWith(
                                color: colors.foregroundSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
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
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pageH, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: colors.primaryMuted.withAlpha(60), width: 1),
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
              style: AppTextStyles.micro.copyWith(
                  color: colors.primary, fontWeight: FontWeight.w600),
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
    final displayName = version.versionName ??
        version.targetRole ??
        'Version #${version.id}';
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground, fontWeight: FontWeight.w600),
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
  final _nameCtrl    = TextEditingController();
  final _roleCtrl    = TextEditingController();
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
    setState(() { _saving = true; _err = null; });
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
      setState(() { _saving = false; _err = e.toString(); });
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
""".lstrip()

# ─────────────────────────────────────────────────────────────────────────────
# Write all files
# ─────────────────────────────────────────────────────────────────────────────
for rel_path, content in files.items():
    abs_path = os.path.join(BASE, rel_path)
    os.makedirs(os.path.dirname(abs_path), exist_ok=True)
    with open(abs_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"  wrote  {rel_path}")

print(f"\nDone — {len(files)} files written.")
