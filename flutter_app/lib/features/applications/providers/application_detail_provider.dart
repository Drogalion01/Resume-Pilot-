import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/application_service.dart';
import '../models/application.dart';
import '../models/application_detail.dart';
import 'applications_provider.dart';

// ── Detail (mega-payload) ─────────────────────────────────────────────────────

class ApplicationDetailNotifier
    extends FamilyAsyncNotifier<ApplicationDetailResponse, int> {
  @override
  Future<ApplicationDetailResponse> build(int applicationId) =>
      ref.watch(applicationServiceProvider).getApplicationDetail(applicationId);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  // ── Status update ────────────────────────────────────────────────────────

  Future<void> updateStatus(ApplicationStatus newStatus) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref.read(applicationServiceProvider).updateApplication(
      current.application.id,
      {'status': newStatus.apiValue},
    );
    state = AsyncData(current.copyWith(
      application: updated,
    ));
  }

  // ── Reminders ────────────────────────────────────────────────────────────

  Future<void> addReminder({
    required String title,
    DateTime? scheduledFor,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final reminder = await ref.read(applicationServiceProvider).createReminder(
      current.application.id,
      title: title,
      scheduledFor: scheduledFor,
    );
    state = AsyncData(current.copyWith(
      reminders: [...current.reminders, reminder],
    ));
  }

  Future<void> toggleReminder(int reminderId, bool completed) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref
        .read(applicationServiceProvider)
        .updateReminder(reminderId, {'completed': completed});
    state = AsyncData(current.copyWith(
      reminders: current.reminders
          .map((r) => r.id == reminderId ? updated : r)
          .toList(),
    ));
  }

  Future<void> deleteReminder(int reminderId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await ref.read(applicationServiceProvider).deleteReminder(reminderId);
    state = AsyncData(current.copyWith(
      reminders: current.reminders.where((r) => r.id != reminderId).toList(),
    ));
  }

  // ── Notes ────────────────────────────────────────────────────────────────

  Future<void> saveNote(String content) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final note = await ref
        .read(applicationServiceProvider)
        .upsertNote(current.application.id, content);
    final existingIdx =
        current.notes.indexWhere((n) => n.id == note.id);
    final updatedNotes = existingIdx >= 0
        ? current.notes
            .map((n) => n.id == note.id ? note : n)
            .toList()
        : [...current.notes, note];
    state = AsyncData(current.copyWith(notes: updatedNotes));
  }

  // ── General field update ─────────────────────────────────────────────────

  Future<void> updateFields(Map<String, dynamic> fields) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = await ref
        .read(applicationServiceProvider)
        .updateApplication(current.application.id, fields);
    state = AsyncData(current.copyWith(application: updated));
  }
}

final applicationDetailProvider = AsyncNotifierProviderFamily<
    ApplicationDetailNotifier, ApplicationDetailResponse, int>(
  ApplicationDetailNotifier.new,
);

// ── Add application form state ────────────────────────────────────────────────

class AddApplicationState {
  const AddApplicationState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  AddApplicationState copyWith({bool? isLoading, String? errorMessage}) =>
      AddApplicationState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

class AddApplicationNotifier extends AutoDisposeNotifier<AddApplicationState> {
  @override
  AddApplicationState build() => const AddApplicationState();

  Future<ApplicationResponse?> submit(ApplicationCreate body) async {
    state = state.copyWith(isLoading: true);
    try {
      final result =
          await ref.read(applicationServiceProvider).createApplication(body);
      ref.invalidate(applicationsProvider);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add application. Please try again.',
      );
      return null;
    }
  }
}

final addApplicationProvider =
    AutoDisposeNotifierProvider<AddApplicationNotifier, AddApplicationState>(
  AddApplicationNotifier.new,
);
