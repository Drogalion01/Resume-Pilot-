import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTextField  — single-line text input with label + optional helper
// ─────────────────────────────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
  });

  final TextEditingController?   controller;
  final String?                  label;
  final String?                  hint;
  final String?                  helperText;
  final String?                  errorText;
  final Widget?                  prefixIcon;
  final Widget?                  suffixIcon;
  final bool                     obscureText;
  final TextInputType?           keyboardType;
  final TextCapitalization       textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>?    onChanged;
  final ValueChanged<String>?    onSubmitted;
  final bool                     autofocus;
  final bool                     enabled;
  final int?                     maxLength;
  final TextInputAction?         textInputAction;
  final FocusNode?               focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    Widget? builtPrefix = prefixIcon;
    Widget? builtSuffix = suffixIcon;

    // Wrap bare IconData into an Icon with correct color
    if (prefixIcon is Icon) {
      final i = prefixIcon as Icon;
      builtPrefix = Icon(i.icon, size: 18, color: colors.foregroundTertiary);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel
                .copyWith(color: colors.foregroundSecondary),
          ),
          const SizedBox(height: AppSpacing.px6),
        ],
        TextFormField(
          controller:            controller,
          obscureText:           obscureText,
          keyboardType:          keyboardType,
          textCapitalization:    textCapitalization,
          inputFormatters:       inputFormatters,
          validator:             validator,
          onChanged:             onChanged,
          onFieldSubmitted:      onSubmitted,
          autofocus:             autofocus,
          enabled:               enabled,
          maxLength:             maxLength,
          textInputAction:       textInputAction,
          focusNode:             focusNode,
          style: AppTextStyles.inputText.copyWith(color: colors.foreground),
          decoration: AppDecorations.inputDecoration(
            colors:      colors,
            hintText:    hint,
            prefixIcon:  builtPrefix,
            suffixIcon:  builtSuffix,
            helperText:  helperText,
            errorText:   errorText,
            enabled:     enabled,
          ),
        ),
      ],
    );
  }
}
