import 'package:flutter/material.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppSearchBar
//
// Frosted pill search input with animated clear button.
// Caller is responsible for debounce / filtering.
// ─────────────────────────────────────────────────────────────────────────────

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search…',
    this.onChanged,
    this.controller,
    this.autofocus = false,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(_onTextChange);
  }

  void _onTextChange() {
    final has = _ctrl.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: AppDecorations.searchBar(colors),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px12),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 18,
                color: colors.foregroundTertiary,
              ),
              const SizedBox(width: AppSpacing.px8),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autofocus: widget.autofocus,
                  onChanged: widget.onChanged,
                  style: AppTextStyles.body.copyWith(
                    color: colors.foreground,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppTextStyles.body.copyWith(
                      color: colors.foregroundQuaternary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: _hasText
                    ? GestureDetector(
                        onTap: () {
                          _ctrl.clear();
                          widget.onChanged?.call('');
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: colors.foregroundTertiary,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
