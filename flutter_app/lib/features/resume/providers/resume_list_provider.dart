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
