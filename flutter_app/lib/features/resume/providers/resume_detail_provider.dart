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
    final newVersion =
        await ref.read(resumeServiceProvider).duplicateResumeVersion(versionId);
    state = AsyncData([...?state.valueOrNull, newVersion]);
  }
}

final resumeVersionsProvider = AsyncNotifierProviderFamily<
    ResumeVersionsNotifier, List<ResumeVersionResponse>, int>(
  ResumeVersionsNotifier.new,
);

// ── Single resume detail ───────────────────────────────────────────────────────

class ResumeDetailNotifier extends FamilyAsyncNotifier<ResumeResponse, int> {
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
