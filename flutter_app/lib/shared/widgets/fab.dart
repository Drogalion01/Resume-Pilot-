import 'package:flutter/material.dart';

import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppFAB  — branded Floating Action Button
//
// extended = false  → 56×56 icon-only pill
// extended = true   → icon + label extended pill
// ─────────────────────────────────────────────────────────────────────────────

class AppFAB extends StatefulWidget {
  const AppFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.label = 'Add',
    this.extended = true,
    this.visible = true,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool extended;
  final bool visible;

  @override
  State<AppFAB> createState() => _AppFABState();
}

class _AppFABState extends State<AppFAB> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack)
        .drive(Tween(begin: 0.6, end: 1.0));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    if (widget.visible) _ctrl.forward();
  }

  @override
  void didUpdateWidget(AppFAB old) {
    super.didUpdateWidget(old);
    if (old.visible != widget.visible) {
      widget.visible ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: DecoratedBox(
            decoration: widget.extended
                ? AppDecorations.fabExtended(colors, brightness)
                : AppDecorations.fab(colors, brightness),
            child: widget.extended
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.px20,
                      vertical: AppSpacing.px14,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.icon,
                            color: colors.primaryForeground, size: 22),
                        const SizedBox(width: AppSpacing.px8),
                        Text(
                          widget.label,
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: colors.primaryForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: AppSpacing.fabSize,
                    height: AppSpacing.fabSize,
                    child: Center(
                      child: Icon(
                        widget.icon,
                        color: colors.primaryForeground,
                        size: 26,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
