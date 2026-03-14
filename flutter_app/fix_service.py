import re
path = "lib/features/resume/data/resume_service.dart"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

new_method = """
  // --- NEW: Polling route ---
  Future<AnalysisResultResponse> checkAnalysisStatus(int analysisId) async {
    return _run(() async {
      final res = await _dio.get<Map<String, dynamic>>('resumes/analyze/$analysisId/status');
      return AnalysisResultResponse.fromJson(res.data!);
    });
  }
}
"""

content = content.replace("  }\n}", "  }\n" + new_method)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
