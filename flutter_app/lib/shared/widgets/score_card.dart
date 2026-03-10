import 'package:flutter/material.dart';

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
