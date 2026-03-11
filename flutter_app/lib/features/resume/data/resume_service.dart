import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../models/analysis_result.dart';
import '../models/resume_version.dart';

class ResumeService {
  const ResumeService(this._dio);

  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  // ── List & Detail ──────────────────────────────────────────────────────────

  Future<List<ResumeResponse>> getResumes() async {
    return _run(() async {
      final res = await _dio.get<List<dynamic>>('/resumes');
      return res.data!
          .map((e) => ResumeResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ResumeResponse> getResumeById(int id) async {
    return _run(() async {
      final res = await _dio.get<Map<String, dynamic>>('/resumes/$id');
      return ResumeResponse.fromJson(res.data!);
    });
  }

  // ── Versions ───────────────────────────────────────────────────────────────

  Future<List<ResumeVersionResponse>> getResumeVersions(int resumeId) async {
    return _run(() async {
      final res =
          await _dio.get<List<dynamic>>('/resumes/$resumeId/versions');
      return res.data!
          .map((e) => ResumeVersionResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ResumeVersionResponse> createResumeVersion(
    int resumeId, {
    String? versionName,
    String? targetRole,
    String? companyName,
    String? tag,
    String? editedText,
  }) async {
    return _run(() async {
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
    });
  }

  Future<ResumeVersionResponse> updateResumeVersion(
    int versionId, {
    String? versionName,
    String? targetRole,
    String? companyName,
    String? tag,
    String? editedText,
  }) async {
    return _run(() async {
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
    });
  }

  Future<ResumeVersionResponse> duplicateResumeVersion(int versionId) async {
    return _run(() async {
      final res = await _dio.post<Map<String, dynamic>>(
        '/resume-versions/$versionId/duplicate',
      );
      return ResumeVersionResponse.fromJson(res.data!);
    });
  }

  // ── Analysis ───────────────────────────────────────────────────────────────

  Future<AnalysisResultResponse> getResumeAnalysis(int resumeId) async {
    return _run(() async {
      final res =
          await _dio.get<Map<String, dynamic>>('/resumes/$resumeId/analysis');
      return AnalysisResultResponse.fromJson(res.data!);
    });
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
    return _run(() async {
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
    });
  }
}

final resumeServiceProvider = Provider<ResumeService>(
  (ref) => ResumeService(ref.watch(dioProvider)),
);
