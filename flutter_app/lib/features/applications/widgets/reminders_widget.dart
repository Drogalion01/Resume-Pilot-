import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/reminder_note.dart';
import '../providers/application_detail_provider.dart';

class RemindersWidget extends ConsumerWidget {
  const RemindersWidget({
    super.key,
    required this.applicationId,
    required this.reminders,
  });

  final int applicationId;
  final List<ReminderResponse> reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final notifier =
        ref.read(applicationDetailProvider(applicationId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reminders.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              'No reminders set.',
              style: AppTextStyles.caption
                  .copyWith(color: colors.foregroundSecondary),
            ),
          )
        else
          ...reminders.map(
            (r) => _ReminderTile(
              reminder: r,
              onToggle: (v) => notifier.toggleReminder(r.id, v),
              onDelete: () => notifier.deleteReminder(r.id),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () =>
              _showAddReminderSheet(context, notifier),
          icon: const Icon(Icons.alarm_add_outlined, size: 16),
          label: const Text('Add Reminder'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
        ),
      ],
    );
  }

  void _showAddReminderSheet(
      BuildContext context, ApplicationDetailNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddReminderSheet(notifier: notifier),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  final ReminderResponse reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = reminder.scheduledFor != null
        ? DateFormat('MMM d, h:mm a')
            .format(reminder.scheduledFor!.toLocal())
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: Checkbox(
            value: reminder.completed,
            onChanged: (v) => onToggle(v ?? false),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          title: Text(
            reminder.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: reminder.completed
                  ? colors.foregroundSecondary
                  : colors.foreground,
              decoration:
                  reminder.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: dateLabel != null
              ? Text(
                  dateLabel,
                  style: AppTextStyles.micro
                      .copyWith(color: colors.foregroundTertiary),
                )
              : null,
          trailing: IconButton(
            icon: Icon(Icons.close_rounded,
                size: 18, color: colors.foregroundSecondary),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet({required this.notifier});

  final ApplicationDetailNotifier notifier;

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleCtrl = TextEditingController();
  DateTime? _scheduledFor;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await widget.notifier.addReminder(
      title: _titleCtrl.text.trim(),
      scheduledFor: _scheduledFor,
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    setState(() {
      _scheduledFor = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add Reminder',
              style: AppTextStyles.headline
                  .copyWith(color: colors.foreground)),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Reminder',
              hintText: 'e.g. Follow up with recruiter',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDateTime,
            icon: const Icon(Icons.schedule_outlined, size: 16),
            label: Text(
              _scheduledFor != null
                  ? DateFormat('MMM d, h:mm a').format(_scheduledFor!)
                  : 'Set Date & Time (optional)',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed:
                _saving || _titleCtrl.text.trim().isEmpty ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Save Reminder'),
          ),
        ],
      ),
    );
  }
}
