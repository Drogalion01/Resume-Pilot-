import re
path = "lib/features/resume/models/analysis_result.dart"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# Add status field
old_root = """@JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AnalysisResultResponse;"""

new_root = """@JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default('completed') String status,
  }) = _AnalysisResultResponse;"""

content = content.replace(old_root, new_root)
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
