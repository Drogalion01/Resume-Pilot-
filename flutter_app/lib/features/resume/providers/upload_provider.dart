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
