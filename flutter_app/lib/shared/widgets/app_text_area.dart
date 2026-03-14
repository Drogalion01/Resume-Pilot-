import 'package:flutter/material.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTextArea  — multi-line text input with optional character counter
// ─────────────────────────────────────────────────────────────────────────────

class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  late final TextEditingController _ctrl;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _charCount = _ctrl.text.length;
    _ctrl.addListener(_onTextChange);
  }

  void _onTextChange() {
    final len = _ctrl.text.length;
    if (len != _charCount) setState(() => _charCount = len);
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label row
        if (widget.label != null || widget.maxLength != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.px6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: AppTextStyles.inputLabel
                        .copyWith(color: colors.foregroundSecondary),
                  ),
                if (widget.maxLength != null)
                  Text(
                    '$_charCount / ${widget.maxLength}',
                    style: AppTextStyles.micro.copyWith(
                      color: _charCount > widget.maxLength!
                          ? colors.destructive
                          : colors.foregroundTertiary,
                    ),
                  ),
              ],
            ),
          ),

        // Text area
        TextFormField(
          controller: _ctrl,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          style: AppTextStyles.inputText.copyWith(color: colors.foreground),
          decoration: AppDecorations.inputDecoration(
            colors: colors,
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            enabled: widget.enabled,
          ).copyWith(
            // hide the built-in counter since we draw our own
            counterText: '',
          ),
        ),
      ],
    );
  }
}
