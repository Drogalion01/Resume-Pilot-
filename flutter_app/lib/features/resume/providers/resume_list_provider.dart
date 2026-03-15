import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/resume_service.dart';
import '../models/resume_version.dart';

const _kResumeListCacheKey = 'resume_list_cache';

class ResumeListNotifier extends AsyncNotifier<List<ResumeResponse>> {
  @override
  Future<List<ResumeResponse>> build() async {
    final prefs = await SharedPreferences.getInstance();
    List<ResumeResponse>? cachedResumes;

    final cachedData = prefs.getString(_kResumeListCacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        cachedResumes = jsonList.map((j) => ResumeResponse.fromJson(j)).toList();
      } catch (_) {}
    }

    final service = ref.watch(resumeServiceProvider);

    final fetchFuture = service.getResumes().then((resumes) async {
      await prefs.setString(
          _kResumeListCacheKey, jsonEncode(resumes.map((r) => r.toJson()).toList()));
      if (cachedResumes != null) state = AsyncData(resumes);
      return resumes;
    }).catchError((error, stackTrace) {
      if (cachedResumes != null) return cachedResumes;
      throw error;
    });

    if (cachedResumes != null) {
      return cachedResumes;
    }

    return await fetchFuture;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final resumeListProvider =
    AsyncNotifierProvider<ResumeListNotifier, List<ResumeResponse>>(
  ResumeListNotifier.new,
);
