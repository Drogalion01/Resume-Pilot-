"""
gen_shared_widgets.py
Generates the ResumePilot shared widget library.
Run from:  f:\\Resume Pilot app\\flutter_app\\
           python gen_shared_widgets.py
"""

from pathlib import Path

ROOT = Path(__file__).parent / "lib"
SKIP = {"score_ring.dart", "bottom_nav.dart"}   # already fully implemented

FILES: dict[str, str] = {}

# ─────────────────────────────────────────────────────────────────────────────
# screen_header.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/screen_header.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScreenHeader
//
// Thin app-bar style header used on full-screen push routes (no bottom-nav).
// Transparent background — scrolls behind gradient when used inside
// CustomScrollView; sticky when used as standalone column header.
// ─────────────────────────────────────────────────────────────────────────────

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
  });

  final String       title;
  final String?      subtitle;
  final Widget?      leading;
  final List<Widget> actions;
  final bool         centerTitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final canPop = Navigator.of(context).canPop();

    final backBtn = canPop
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: colors.foreground,
            ),
            onPressed: Navigator.of(context).pop,
          )
        : null;

    final effectiveLeading = leading ?? backBtn;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.px4,
        right: AppSpacing.px4,
        top: AppSpacing.px4,
        bottom: AppSpacing.px4,
      ),
      child: Row(
        children: [
          if (effectiveLeading != null) effectiveLeading,
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: AppTextStyles.title.copyWith(color: colors.foreground),
              child: centerTitle
                  ? Text(title, textAlign: TextAlign.center)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.foregroundSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# gradient_header.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/gradient_header.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_shadows.dart';
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
'''

# ─────────────────────────────────────────────────────────────────────────────
# mobile_card.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/mobile_card.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MobileCard  — base elevated content card
//
// Variants:
//   default     → white/dark-surface + card shadow
//   outlined    → transparent + 1px border, no shadow
//   elevated    → surface + stronger primary-tinted shadow
//   sunken      → surfaceSunken background
//   interactive → default shadow; pressed = hover shadow + scale 0.98
// ─────────────────────────────────────────────────────────────────────────────

enum CardVariant { basic, outlined, elevated, sunken, interactive }

class MobileCard extends StatefulWidget {
  const MobileCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.variant = CardVariant.basic,
    this.radius,
    this.color,
  });

  final Widget         child;
  final VoidCallback?  onTap;
  final EdgeInsets?    padding;
  final EdgeInsets?    margin;
  final CardVariant    variant;
  final double?        radius;
  final Color?         color;

  @override
  State<MobileCard> createState() => _MobileCardState();
}

class _MobileCardState extends State<MobileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final isInteractive =
        widget.variant == CardVariant.interactive || widget.onTap != null;

    final radius = widget.radius ?? AppRadii.card;
    final padding = widget.padding ?? const EdgeInsets.all(AppSpacing.cardPad);

    BoxDecoration decoration;
    switch (widget.variant) {
      case CardVariant.outlined:
        decoration = AppDecorations.cardOutlined(colors);
      case CardVariant.elevated:
        decoration = AppDecorations.cardElevated(colors, brightness);
      case CardVariant.sunken:
        decoration = AppDecorations.cardSunken(colors);
      case CardVariant.interactive:
        decoration = AppDecorations.cardInteractive(colors, brightness,
            pressed: _pressed);
      case CardVariant.basic:
        decoration = AppDecorations.card(colors, brightness);
    }

    if (widget.color != null) {
      decoration = decoration.copyWith(color: widget.color);
    }
    if (widget.radius != null) {
      decoration = decoration.copyWith(
        borderRadius: BorderRadius.circular(radius),
      );
    }

    Widget content = Padding(padding: padding, child: widget.child);

    if (isInteractive) {
      content = GestureDetector(
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        onTap:       widget.onTap,
        child: AnimatedScale(
          scale: (_pressed && isInteractive) ? 0.975 : 1.0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: content,
        ),
      );
    }

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# section_header.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/section_header.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SectionHeader  — row with title + optional action link
// ─────────────────────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String    title;
  final String?   actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.title.copyWith(color: colors.foreground),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.buttonLabelSm
                  .copyWith(color: colors.primary),
            ),
          ),
      ],
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# status_badge.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/status_badge.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StatusBadge  — colored pill chip for ApplicationStatus
// ─────────────────────────────────────────────────────────────────────────────

enum BadgeSize { small, medium, large }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.size = BadgeSize.medium,
  });

  final ApplicationStatus status;
  final BadgeSize         size;

  double get _fontSize => switch (size) {
        BadgeSize.small  => 10.0,
        BadgeSize.medium => 11.0,
        BadgeSize.large  => 12.0,
      };

  EdgeInsets get _padding => switch (size) {
        BadgeSize.small  => const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        BadgeSize.medium => const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        BadgeSize.large  => const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final pair   = AppStatusColors.forStatus(status, colors);

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: pair.background,
        borderRadius: BorderRadius.circular(AppRadii.badgePill),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.overline.copyWith(
          color: pair.foreground,
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# score_card.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/score_card.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_status_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import 'score_ring.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScoreCard  — ScoreRing + tier label + title + optional subtitle
// ─────────────────────────────────────────────────────────────────────────────

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.score,
    required this.title,
    this.subtitle,
    this.ringSize = 80.0,
    this.onTap,
  });

  final double        score;
  final String        title;
  final String?       subtitle;
  final double        ringSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final scorePair  = AppScoreColors.forScore(score.round(), colors);
    final band       = AppScoreColors.bandFor(score.round());

    Widget card = DecoratedBox(
      decoration: AppDecorations.cardElevated(colors, brightness),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPad),
        child: Row(
          children: [
            ScoreRing(
              score: score,
              size: ringSize,
              showLabel: true,
              showTier: false,
              animated: true,
            ),
            const SizedBox(width: AppSpacing.px16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tier chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.px8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: scorePair.background,
                      borderRadius:
                          BorderRadius.circular(AppRadii.badgePill),
                    ),
                    child: Text(
                      band.label,
                      style: AppTextStyles.overline.copyWith(
                        color: scorePair.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.px6),
                  Text(
                    title,
                    style: AppTextStyles.title
                        .copyWith(color: colors.foreground),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.foregroundSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: colors.foregroundQuaternary,
                size: 20,
              ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# search_bar.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/search_bar.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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

  final String                   hint;
  final ValueChanged<String>?    onChanged;
  final TextEditingController?   controller;
  final bool                     autofocus;

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
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.px12),
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
'''

# ─────────────────────────────────────────────────────────────────────────────
# empty_state.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/empty_state.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EmptyState  — centered icon + title + description + optional CTA
// ─────────────────────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData     icon;
  final String       title;
  final String?      description;
  final String?      actionLabel;
  final VoidCallback? onAction;

  /// Smaller layout for inline empty sections inside a card.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final iconSize  = compact ? 36.0 : 52.0;
    final boxSize   = compact ? 72.0 : 100.0;
    final vPad      = compact ? AppSpacing.px24 : AppSpacing.px48;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: vPad,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primaryLight, colors.primaryMuted],
              ),
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: iconSize,
              color: colors.primary,
            ),
          ),

          SizedBox(height: compact ? AppSpacing.px16 : AppSpacing.px20),

          // Title
          Text(
            title,
            style: compact
                ? AppTextStyles.title.copyWith(color: colors.foreground)
                : AppTextStyles.headline.copyWith(color: colors.foreground),
            textAlign: TextAlign.center,
          ),

          if (description != null) ...[
            SizedBox(height: compact ? AppSpacing.px6 : AppSpacing.px8),
            Text(
              description!,
              style: AppTextStyles.body.copyWith(
                color: colors.foregroundSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? AppSpacing.px16 : AppSpacing.px24),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(actionLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.primaryForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.px24,
                  vertical: AppSpacing.px12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.button),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# loading_skeletons.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/loading_skeletons.dart"] = '''\
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LoadingSkeletons  — shimmer placeholder layouts
// ─────────────────────────────────────────────────────────────────────────────

class LoadingSkeletons extends StatelessWidget {
  const LoadingSkeletons._({required Widget child}) : _child = child;

  factory LoadingSkeletons.dashboard() => LoadingSkeletons._(
        child: _DashboardSkeleton(),
      );
  factory LoadingSkeletons.resumeList() => LoadingSkeletons._(
        child: _ResumeListSkeleton(),
      );
  factory LoadingSkeletons.applicationList() => LoadingSkeletons._(
        child: _ApplicationListSkeleton(),
      );
  factory LoadingSkeletons.analysisResult() => LoadingSkeletons._(
        child: _AnalysisSkeleton(),
      );
  factory LoadingSkeletons.detail() => LoadingSkeletons._(
        child: _DetailSkeleton(),
      );

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Shimmer.fromColors(
      baseColor: colors.surfaceSecondary,
      highlightColor: colors.surfacePrimary,
      child: _child,
    );
  }
}

// ── Skeleton shapes ──────────────────────────────────────────────────────────

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = AppRadii.md,
  });
  final double  width;
  final double  height;
  final double  radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _SkeletonFlex extends StatelessWidget {
  const _SkeletonFlex({required this.height, this.radius = AppRadii.md});
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

// ── Dashboard skeleton ───────────────────────────────────────────────────────

class _DashboardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.px16),
            // Score card placeholder
            const _SkeletonFlex(height: 110, radius: AppRadii.card),
            const SizedBox(height: AppSpacing.px24),
            const _SkeletonBox(width: 120, height: 18),
            const SizedBox(height: AppSpacing.px12),
            for (var i = 0; i < 3; i++) ...[
              const _SkeletonFlex(height: 72, radius: AppRadii.cardSm),
              const SizedBox(height: AppSpacing.cardGap),
            ],
            const SizedBox(height: AppSpacing.px16),
            const _SkeletonBox(width: 140, height: 18),
            const SizedBox(height: AppSpacing.px12),
            for (var i = 0; i < 2; i++) ...[
              const _SkeletonFlex(height: 72, radius: AppRadii.cardSm),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Resume list skeleton ──────────────────────────────────────────────────────

class _ResumeListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px8),
            for (var i = 0; i < 4; i++) ...[
              Container(
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                ),
                padding: const EdgeInsets.all(AppSpacing.cardPad),
                child: Row(
                  children: [
                    const _SkeletonBox(width: 52, height: 52, radius: AppRadii.md),
                    const SizedBox(width: AppSpacing.px12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _SkeletonFlex(height: 14),
                          SizedBox(height: 8),
                          _SkeletonBox(width: 80, height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.px12),
                    const _SkeletonBox(width: 44, height: 44, radius: 22),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Application list skeleton ──────────────────────────────────────────────────

class _ApplicationListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px8),
            for (var i = 0; i < 5; i++) ...[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                ),
                padding: const EdgeInsets.all(AppSpacing.cardPad),
                child: Row(
                  children: [
                    const _SkeletonBox(width: 40, height: 40, radius: AppRadii.md),
                    const SizedBox(width: AppSpacing.px12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _SkeletonFlex(height: 14),
                          SizedBox(height: 6),
                          _SkeletonBox(width: 60, height: 18, radius: AppRadii.badgePill),
                        ],
                      ),
                    ),
                    const _SkeletonBox(width: 40, height: 10),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Analysis result skeleton ──────────────────────────────────────────────────

class _AnalysisSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.px24),
            const Center(
              child: _SkeletonBox(width: 120, height: 120, radius: 60),
            ),
            const SizedBox(height: AppSpacing.px24),
            for (var i = 0; i < 4; i++) ...[
              const _SkeletonFlex(height: 18, radius: AppRadii.sm),
              const SizedBox(height: AppSpacing.px8),
            ],
            const SizedBox(height: AppSpacing.px16),
            for (var i = 0; i < 3; i++) ...[
              const _SkeletonFlex(height: 80, radius: AppRadii.card),
              const SizedBox(height: AppSpacing.cardGap),
            ],
          ],
        ),
      );
}

// ── Generic detail skeleton ───────────────────────────────────────────────────

class _DetailSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: AppSpacing.px16),
            _SkeletonBox(width: 180, height: 24),
            SizedBox(height: AppSpacing.px8),
            _SkeletonBox(width: 100, height: 16),
            SizedBox(height: AppSpacing.px24),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px12),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px12),
            _SkeletonFlex(height: 52, radius: AppRadii.card),
            SizedBox(height: AppSpacing.px24),
            _SkeletonFlex(height: 160, radius: AppRadii.card),
          ],
        ),
      );
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# fab.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/fab.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
  final IconData     icon;
  final String       label;
  final bool         extended;
  final bool         visible;

  @override
  State<AppFAB> createState() => _AppFABState();
}

class _AppFABState extends State<AppFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>    _scale;
  late final Animation<double>    _fade;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack)
        .drive(Tween(begin: 0.6, end: 1.0));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
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
    final colors     = Theme.of(context).appColors;
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
                        Icon(widget.icon, color: colors.primaryForeground, size: 22),
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
'''

# ─────────────────────────────────────────────────────────────────────────────
# list_item.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/list_item.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppListItem  — general-purpose row list item
// ─────────────────────────────────────────────────────────────────────────────

class AppListItem extends StatelessWidget {
  const AppListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
  });

  final String       title;
  final String?      subtitle;
  final Widget?      leading;
  final Widget?      trailing;
  final VoidCallback? onTap;
  final EdgeInsets?  padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final content = Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.px16,
            vertical: AppSpacing.px12,
          ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.px12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: colors.foreground),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.foregroundSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.px8),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        splashColor: colors.primaryMuted.withValues(alpha: 0.25),
        highlightColor: colors.primaryLight.withValues(alpha: 0.3),
        child: content,
      );
    }
    return content;
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# chip.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/chip.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppChip  — filter / tag pill chip
// ─────────────────────────────────────────────────────────────────────────────

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.count,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String       label;
  final bool         selected;
  final VoidCallback? onTap;
  final IconData?    icon;
  final int?         count;

  /// Override foreground — defaults to primary (selected) / foreground-secondary
  final Color? foregroundColor;

  /// Override background — defaults to primaryLight (selected) / surfaceSecondary
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final fg = foregroundColor ??
        (selected ? colors.primary : colors.foregroundSecondary);
    final bg = backgroundColor ??
        (selected ? colors.primaryLight : colors.surfaceSecondary);
    final borderColor =
        selected ? colors.primaryMuted : colors.borderSubtle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px12,
          vertical: AppSpacing.px6,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: AppTextStyles.buttonLabelSm.copyWith(color: fg),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: selected ? colors.primary : colors.border,
                  borderRadius:
                      BorderRadius.circular(AppRadii.badgePill),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.micro
                      .copyWith(color: selected ? colors.primaryForeground : colors.foregroundSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# primary_button.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/primary_button.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PrimaryButton
//
// Gradient-filled pill button — the main CTA throughout the app.
// Press animates to scale 0.97 + removes gradient (loading dims it).
// ─────────────────────────────────────────────────────────────────────────────

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.width,
    this.height = 52.0,
  });

  final String       label;
  final VoidCallback? onPressed;
  final IconData?    icon;
  final bool         loading;
  final bool         enabled;
  final double?      width;
  final double       height;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final isDisabled = !widget.enabled || widget.loading || widget.onPressed == null;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); if (!isDisabled) widget.onPressed?.call(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width:  widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? null
                : AppGradients.primaryButton(colors),
            color: isDisabled ? colors.primaryMuted : null,
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(colors.primaryForeground),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: colors.primaryForeground),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: isDisabled
                            ? colors.foregroundTertiary
                            : colors.primaryForeground,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# secondary_button.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/secondary_button.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SecondaryButton  — outlined / ghost button
// ─────────────────────────────────────────────────────────────────────────────

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.enabled = true,
    this.width,
    this.height = 52.0,
    this.ghost = false,
  });

  final String       label;
  final VoidCallback? onPressed;
  final IconData?    icon;
  final bool         loading;
  final bool         enabled;
  final double?      width;
  final double       height;

  /// ghost = true → transparent fill; false → surfacePrimary fill
  final bool ghost;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors     = Theme.of(context).appColors;
    final isDisabled = !widget.enabled || widget.loading || widget.onPressed == null;
    final fg         = isDisabled ? colors.foregroundTertiary : colors.primary;
    final bg         = widget.ghost
        ? ((_pressed && !isDisabled)
            ? colors.primaryLight.withValues(alpha: 0.6)
            : Colors.transparent)
        : ((_pressed && !isDisabled)
            ? colors.primaryLight
            : colors.surfacePrimary);

    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); if (!isDisabled) widget.onPressed?.call(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width:  widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadii.button),
            border: Border.all(
              color: isDisabled ? colors.border : colors.primaryMuted,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: fg),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTextStyles.buttonLabel.copyWith(color: fg),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# app_text_field.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/app_text_field.dart"] = '''\
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
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

    Widget? built_prefix = prefixIcon;
    Widget? built_suffix = suffixIcon;

    // Wrap bare IconData into an Icon with correct color
    if (prefixIcon is Icon) {
      final i = prefixIcon as Icon;
      built_prefix = Icon(i.icon, size: 18, color: colors.foregroundTertiary);
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
            prefixIcon:  built_prefix,
            suffixIcon:  built_suffix,
            helperText:  helperText,
            errorText:   errorText,
            enabled:     enabled,
          ),
        ),
      ],
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# app_text_area.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/app_text_area.dart"] = '''\
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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

  final TextEditingController?      controller;
  final String?                     label;
  final String?                     hint;
  final String?                     helperText;
  final String?                     errorText;
  final int                         minLines;
  final int                         maxLines;
  final int?                        maxLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>?       onChanged;
  final bool                        autofocus;
  final bool                        enabled;
  final FocusNode?                  focusNode;

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
          controller:   _ctrl,
          minLines:     widget.minLines,
          maxLines:     widget.maxLines,
          maxLength:    widget.maxLength,
          validator:    widget.validator,
          onChanged:    widget.onChanged,
          autofocus:    widget.autofocus,
          enabled:      widget.enabled,
          focusNode:    widget.focusNode,
          style: AppTextStyles.inputText.copyWith(color: colors.foreground),
          decoration: AppDecorations.inputDecoration(
            colors:     colors,
            hintText:   widget.hint,
            helperText: widget.helperText,
            errorText:  widget.errorText,
            enabled:    widget.enabled,
          ).copyWith(
            // hide the built-in counter since we draw our own
            counterText: '',
          ),
        ),
      ],
    );
  }
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# context_ext.dart  (implement stubs)
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/extensions/context_ext.dart"] = '''\
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

extension BuildContextX on BuildContext {
  ThemeData      get theme        => Theme.of(this);
  ColorScheme    get colorScheme  => Theme.of(this).colorScheme;
  TextTheme      get textTheme    => Theme.of(this).textTheme;
  AppColors      get colors       => Theme.of(this).appColors;
  bool           get isDark       => Theme.of(this).brightness == Brightness.dark;
  double         get screenWidth  => MediaQuery.sizeOf(this).width;
  double         get screenHeight => MediaQuery.sizeOf(this).height;
  double         get paddingBottom => MediaQuery.paddingOf(this).bottom;
  double         get paddingTop    => MediaQuery.paddingOf(this).top;
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# string_ext.dart  (implement stubs)
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/extensions/string_ext.dart"] = '''\
extension StringX on String {
  /// Capitalize first letter, lowercase rest.
  String get capitalized =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();

  /// Capitalize each word.
  String get titleCased => split(' ').map((w) => w.capitalized).join(' ');

  /// Trim and return null if empty.
  String? get nullIfEmpty => trim().isEmpty ? null : trim();

  /// True if string looks like a valid email.
  bool get isValidEmail =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+ $').hasMatch(trim()) ||
      RegExp(r"^[\w.+-]+@[\w-]+\.[\w.]+$").hasMatch(trim());

  /// True if string looks like a valid URL (http/https).
  bool get isValidUrl => RegExp(
        r'^https?://[^\s/$.?#].[^\s]*$',
        caseSensitive: false,
      ).hasMatch(trim());

  /// Truncate to [maxLength] chars and append '…' if longer.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';
}
'''

# ─────────────────────────────────────────────────────────────────────────────
# Barrel: shared/widgets/shared_widgets.dart
# ─────────────────────────────────────────────────────────────────────────────
FILES["shared/widgets/shared_widgets.dart"] = '''\
/// ResumePilot — Shared Widget Library
///
/// Single import for all shared UI components:
///   import \'package:resume_pilot/shared/widgets/shared_widgets.dart\';
library;

export \'app_text_area.dart\';
export \'app_text_field.dart\';
export \'bottom_nav.dart\';
export \'chip.dart\';
export \'empty_state.dart\';
export \'fab.dart\';
export \'gradient_header.dart\';   // AppScaffold + GradientHeader + GradientPageTitle
export \'list_item.dart\';
export \'loading_skeletons.dart\';
export \'mobile_card.dart\';
export \'primary_button.dart\';
export \'score_card.dart\';
export \'score_ring.dart\';
export \'screen_header.dart\';
export \'search_bar.dart\';
export \'secondary_button.dart\';
export \'section_header.dart\';
export \'status_badge.dart\';
'''


# ─────────────────────────────────────────────────────────────────────────────
# Write files
# ─────────────────────────────────────────────────────────────────────────────

def main() -> None:
    written = skipped = 0
    for rel, content in FILES.items():
        fname = Path(rel).name
        if fname in SKIP:
            print(f"  skip   {rel}  (already implemented)")
            skipped += 1
            continue
        path = ROOT / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        print(f"  wrote  {rel}")
        written += 1

    print(f"\nDone — {written} written, {skipped} skipped.")


if __name__ == "__main__":
    main()
