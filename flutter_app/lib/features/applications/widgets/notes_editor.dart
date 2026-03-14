import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/reminder_note.dart';
import '../providers/application_detail_provider.dart';

class NotesEditor extends ConsumerStatefulWidget {
  const NotesEditor({
    super.key,
    required this.applicationId,
    required this.notes,
  });

  final int applicationId;
  final List<NoteResponse> notes;

  @override
  ConsumerState<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends ConsumerState<NotesEditor> {
  late final TextEditingController _ctrl;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.notes.isNotEmpty ? widget.notes.first.content : '');
  }

  @override
  void didUpdateWidget(NotesEditor old) {
    super.didUpdateWidget(old);
    if (old.notes != widget.notes && !_editing) {
      _ctrl.text = widget.notes.isNotEmpty ? widget.notes.first.content : '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(applicationDetailProvider(widget.applicationId).notifier)
        .saveNote(_ctrl.text);
    setState(() {
      _saving = false;
      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_editing)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _ctrl,
                maxLines: 8,
                autofocus: true,
                style: AppTextStyles.body.copyWith(color: colors.foreground),
                decoration: const InputDecoration(
                  hintText: 'Write notes about this application…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _editing = false);
                        _ctrl.text = widget.notes.isNotEmpty
                            ? widget.notes.first.content
                            : '';
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          )
        else if (widget.notes.isNotEmpty &&
            widget.notes.first.content.isNotEmpty)
          GestureDetector(
            onTap: () => setState(() => _editing = true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notes.first.content,
                    style:
                        AppTextStyles.body.copyWith(color: colors.foreground),
                    maxLines: 6,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to edit',
                    style: AppTextStyles.micro
                        .copyWith(color: colors.foregroundTertiary),
                  ),
                ],
              ),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => setState(() => _editing = true),
            icon: const Icon(Icons.edit_note_outlined, size: 16),
            label: const Text('Add Notes'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40)),
          ),
      ],
    );
  }
}
