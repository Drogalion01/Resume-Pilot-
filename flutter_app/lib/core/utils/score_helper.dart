import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum ScoreTier { excellent, good, average, poor }

abstract class ScoreHelper {
  static ScoreTier tierFromScore(num score) {
    if (score >= 80) return ScoreTier.excellent;
    if (score >= 65) return ScoreTier.good;
    if (score >= 45) return ScoreTier.average;
    return ScoreTier.poor;
  }

  static ScoreTier tierFromLabel(String? label) {
    switch (label?.toLowerCase()) {
      case 'excellent':
        return ScoreTier.excellent;
      case 'good':
        return ScoreTier.good;
      case 'average':
        return ScoreTier.average;
      default:
        return ScoreTier.poor;
    }
  }

  static Color colorFromScore(num score, AppColors colors) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => colors.scoreExcellent,
        ScoreTier.good      => colors.scoreGood,
        ScoreTier.average   => colors.scoreAverage,
        ScoreTier.poor      => colors.scorePoor,
      };

  static Color bgColorFromScore(num score, AppColors colors) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => colors.scoreExcellentBg,
        ScoreTier.good      => colors.scoreGoodBg,
        ScoreTier.average   => colors.scoreAverageBg,
        ScoreTier.poor      => colors.scorePoorBg,
      };

  static String labelFromScore(num score) =>
      switch (tierFromScore(score)) {
        ScoreTier.excellent => 'Excellent',
        ScoreTier.good      => 'Good',
        ScoreTier.average   => 'Average',
        ScoreTier.poor      => 'Poor',
      };
}
