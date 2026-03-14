import re
path = "lib/features/resume/providers/upload_provider.dart"

with open(path, "r", encoding="utf-8") as f:
    content = f.read()

new_trigger_analyze = """  /// Primary entry point called by Upload button.
  Future<void> triggerAnalyze(UploadFilePicked? picked) async {
    if (!canAnalyze) return;
    state = const UploadLoading();
    try {
      final service = ref.read(resumeServiceProvider);
      AnalysisResultResponse result;

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

      // Polling logic for background processing
      while (result.status == 'processing') {
        await Future.delayed(const Duration(seconds: 2));
        result = await service.checkAnalysisStatus(result.id);
      }

      if (result.status == 'failed') {
        state = const UploadError('Analysis failed during background processing.');
        return;
      }

      state = UploadSuccess(analysis: result);
    } catch (e) {
      state = UploadError(
        e is AppException
            ? e.userMessage
            : 'Analysis failed. Please try again.',
      );
    }
  }"""

# regex search for future triggerAnalyze and replace
content = re.sub(r"  /// Primary entry point called by Upload button\..*?(?=^\}$)", new_trigger_analyze + "\n", content, flags=re.MULTILINE | re.DOTALL)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
