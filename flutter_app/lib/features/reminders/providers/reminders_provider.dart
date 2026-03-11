import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../applications/models/reminder_note.dart';
import '../data/reminder_service.dart';

// ── RemindersNotifier ─────────────────────────────────────────────────────────

class RemindersNotifier extends AsyncNotifier<List<ReminderResponse>> {
  @override
  Future<List<ReminderResponse>> build() =>
      ref.watch(reminderServiceProvider).getReminders();

  // ── Computed views ───────────────────────────────────────────────────────

  /// Reminders not yet completed, due in the future (or with no due date).
  List<ReminderResponse> get upcoming {
    final now = DateTime.now();
    final list = (state.valueOrNull ?? [])
        .where((r) =>
            !r.completed &&
            (r.scheduledFor == null || r.scheduledFor!.isAfter(now)))
        .toList()
      ..sort((a, b) {
        if (a.scheduledFor == null) return 1;
        if (b.scheduledFor == null) return -1;
        return a.scheduledFor!.compareTo(b.scheduledFor!);
      });
    return list;
  }

  /// Reminders not completed with a past due date.
  List<ReminderResponse> get overdue {
    final now = DateTime.now();
    return (state.valueOrNull ?? [])
        .where((r) =>
            !r.completed &&
            r.scheduledFor != null &&
            r.scheduledFor!.isBefore(now))
        .toList()
      ..sort((a, b) => a.scheduledFor!.compareTo(b.scheduledFor!));
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// PATCH /reminders/{id} with completed=true.
  Future<void> markComplete(int reminderId) async {
    final updated = await ref
        .read(reminderServiceProvider)
        .updateReminder(reminderId, {'completed': true});
    state = AsyncData(
      (state.valueOrNull ?? [])
          .map((r) => r.id == reminderId ? updated : r)
          .toList(),
    );
  }

  /// DELETE /reminders/{id} with optimistic removal.
  Future<void> deleteReminder(int reminderId) async {
    // Optimistic update
    state = AsyncData(
      (state.valueOrNull ?? []).where((r) => r.id != reminderId).toList(),
    );
    try {
      await ref.read(reminderServiceProvider).deleteReminder(reminderId);
    } catch (_) {
      // Revert by refetching on error
      ref.invalidateSelf();
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final remindersProvider =
    AsyncNotifierProvider<RemindersNotifier, List<ReminderResponse>>(
  RemindersNotifier.new,
);
