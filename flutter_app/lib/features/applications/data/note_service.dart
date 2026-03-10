import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/reminder_note.dart';

/// Handles all note CRUD for the ResumePilot API.
///
/// Notes are scoped to an application.  The full list is always available
/// inside [ApplicationDetailResponse.notes] — there is no standalone list
/// endpoint.  After any mutation, invalidate [applicationDetailProvider]
/// for the affected applicationId so the screen reloads the fresh payload.
class NoteService {
  const NoteService(this._dio);

  final Dio _dio;

  // ── Read ───────────────────────────────────────────────────────────────────

  /// GET /applications/{applicationId}/notes  → List<NoteResponse>
  Future<List<NoteResponse>> getNotes(int applicationId) async {
    final res = await _dio
        .get<List<dynamic>>('/applications/$applicationId/notes');
    return res.data!
        .map((e) => NoteResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  /// POST /applications/{applicationId}/notes
  /// Body: { content: String }  → NoteResponse
  Future<NoteResponse> createNote({
    required int applicationId,
    required String content,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/applications/$applicationId/notes',
      data: {'content': content},
    );
    return NoteResponse.fromJson(res.data!);
  }

  // ── Update ─────────────────────────────────────────────────────────────────

  /// PATCH /notes/{noteId}
  /// Body: { content: String }  → NoteResponse  (partial update)
  Future<NoteResponse> updateNote({
    required int noteId,
    required String content,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/notes/$noteId',
      data: {'content': content},
    );
    return NoteResponse.fromJson(res.data!);
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  /// DELETE /notes/{noteId}  → void (204)
  Future<void> deleteNote(int noteId) async {
    await _dio.delete('/notes/$noteId');
  }
}

final noteServiceProvider = Provider<NoteService>(
  (ref) => NoteService(ref.watch(dioProvider)),
);

