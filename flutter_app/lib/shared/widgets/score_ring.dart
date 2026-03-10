import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/score_helper.dart';

/// Animated arc score ring.
///
/// [score] is 0–100. The arc starts at 135° and sweeps 270° clockwise.
class ScoreRing extends StatefulWidget {
  const ScoreRing({
    super.key,
    required this.score,
    this.size = 80.0,
    this.strokeWidth = 7.0,
    this.showLabel = true,
    this.showTier = false,
    this.animated = true,
    this.centerLabel,
  });

  final double score;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final bool showTier;
  final bool animated;

  /// Optional extra label shown below the score number (e.g. "ATS Score").
  final String? centerLabel;

  @override
  State<ScoreRing> createState() => _ScoreRingState();
}

class _ScoreRingState extends State<ScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration:
          widget.animated ? const Duration(milliseconds: 900) : Duration.zero,
      vsync: this,
    );
    _anim = Tween<double>(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(ScoreRing old) {
    super.didUpdateWidget(old);
    if (old.score != widget.score) {
      _anim = Tween<double>(begin: old.score, end: widget.score).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
      );
      _ctrl
        ..reset()
        ..forward();
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
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final v = _anim.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RingPainter(
              score: v,
              strokeWidth: widget.strokeWidth,
              fillColor: ScoreHelper.colorFromScore(v, colors),
              trackColor: ScoreHelper.bgColorFromScore(v, colors),
            ),
            child: widget.showLabel
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          v.round().toString(),
                          style: AppTextStyles.scoreNumber
                              .copyWith(color: colors.foreground),
                        ),
                        if (widget.showTier)
                          Text(
                            ScoreHelper.labelFromScore(v),
                            style: AppTextStyles.micro.copyWith(
                              color: ScoreHelper.colorFromScore(v, colors),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (widget.centerLabel != null)
                          Text(
                            widget.centerLabel!,
                            style: AppTextStyles.micro.copyWith(
                              color: colors.foregroundSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.score,
    required this.strokeWidth,
    required this.fillColor,
    required this.trackColor,
  });

  final double score;
  final double strokeWidth;
  final Color fillColor;
  final Color trackColor;

  static const double _start = 135 * math.pi / 180;
  static const double _total = 270 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: c, radius: r);

    final base = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _start, _total, false, base);
    final sweep = (score / 100).clamp(0.0, 1.0) * _total;
    if (sweep > 0) canvas.drawArc(rect, _start, sweep, false, fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.score != score || old.fillColor != fillColor;
}
