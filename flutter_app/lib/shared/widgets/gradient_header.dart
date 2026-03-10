import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GradientHeader
//
// Full-bleed gradient background header for tab screens (Dashboard, Resumes,
// etc.).  Renders the heroBackground gradient + gold glow blob behind content.
// Wrap screens in a Stack:
//   Stack([
//     GradientHeader(),        ← fills behind content
//     SafeArea(child: ...)     ← your screen content
//   ])
//
// Or use GradientHeaderScaffold for the full-page pre-composed layout.
// ─────────────────────────────────────────────────────────────────────────────

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    this.height,
  });

  /// Optional fixed height — null = fill parent (use inside Positioned.fill).
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox(
      height: height,
      child: Stack(
        fit: height != null ? StackFit.loose : StackFit.expand,
        children: [
          // Base gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
          // Top-right primary glow
          Positioned(
            top: -60,
            right: -60,
            child: IgnorePointer(
              child: SizedBox(
                width: 220,
                height: 220,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow1(colors),
                  ),
                ),
              ),
            ),
          ),
          // Bottom-left secondary glow
          Positioned(
            bottom: -40,
            left: -40,
            child: IgnorePointer(
              child: SizedBox(
                width: 180,
                height: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow2(colors),
                  ),
                ),
              ),
            ),
          ),
          // Gold shimmer
          Positioned(
            top: 10,
            right: MediaQuery.sizeOf(context).width * 0.3,
            child: IgnorePointer(
              child: SizedBox(
                width: 140,
                height: 140,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGoldGlow(colors),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppScaffold
//
// Full-page scaffold that composes:
//   • GradientHeader background (full screen, behind everything)
//   • SafeArea > Column [ header?, Expanded > body ]
//
// Used by all tab screens and most full-screen routes.
// ─────────────────────────────────────────────────────────────────────────────

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.header,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget  body;
  final Widget? header;
  final Widget? floatingActionButton;
  final bool    resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          const Positioned.fill(child: GradientHeader()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) header!,
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GradientPageTitle
//
// Large display title + subtitle line used at the top of tab screens.
// ─────────────────────────────────────────────────────────────────────────────

class GradientPageTitle extends StatelessWidget {
  const GradientPageTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String  title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageH, AppSpacing.px20, AppSpacing.pageH, AppSpacing.px8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.display
                      .copyWith(color: colors.foreground),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.body.copyWith(
                      color: colors.foregroundSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
