import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_colors.dart';

/// ResumePilot Design System — Status & Score Color Maps
///
/// Single canonical [ApplicationStatus] enum — shared by both the data layer
/// (json_serializable, @JsonValue) and the UI layer (StatusBadge, AppStatusColors).
///
/// Backend enum values (backend/app/models/tracker.py):
///   saved / applied / assessment / hr / technical / final / offer / rejected

// ─────────────────────────────────────────────────────────────────────────────
// ApplicationStatus — single canonical enum (data + UI)
// ─────────────────────────────────────────────────────────────────────────────

enum ApplicationStatus {
  @JsonValue('saved')
  saved,
  @JsonValue('applied')
  applied,
  @JsonValue('assessment')
  assessment,
  @JsonValue('hr')
  hr,
  @JsonValue('technical')
  technical,
  @JsonValue('final')
  finalRound,
  @JsonValue('offer')
  offer,
  @JsonValue('rejected')
  rejected,
}

extension ApplicationStatusX on ApplicationStatus {
  /// JSON string sent to / received from the backend.
  String get apiValue => switch (this) {
        ApplicationStatus.saved => 'saved',
        ApplicationStatus.applied => 'applied',
        ApplicationStatus.assessment => 'assessment',
        ApplicationStatus.hr => 'hr',
        ApplicationStatus.technical => 'technical',
        ApplicationStatus.finalRound => 'final',
        ApplicationStatus.offer => 'offer',
        ApplicationStatus.rejected => 'rejected',
      };

  /// Human-readable display label.
  String get displayName => switch (this) {
        ApplicationStatus.saved => 'Saved',
        ApplicationStatus.applied => 'Applied',
        ApplicationStatus.assessment => 'Assessment',
        ApplicationStatus.hr => 'HR Screen',
        ApplicationStatus.technical => 'Technical',
        ApplicationStatus.finalRound => 'Final Round',
        ApplicationStatus.offer => 'Offer',
        ApplicationStatus.rejected => 'Rejected',
      };

  /// Alias kept for backward compatibility with StatusBadge.
  String get label => displayName;

  IconData get icon => switch (this) {
        ApplicationStatus.saved => Icons.bookmark_border_rounded,
        ApplicationStatus.applied => Icons.send_rounded,
        ApplicationStatus.assessment => Icons.assignment_outlined,
        ApplicationStatus.hr => Icons.people_outline_rounded,
        ApplicationStatus.technical => Icons.code_rounded,
        ApplicationStatus.finalRound => Icons.stars_rounded,
        ApplicationStatus.offer => Icons.celebration_outlined,
        ApplicationStatus.rejected => Icons.cancel_outlined,
      };

  static ApplicationStatus fromApiValue(String v) =>
      ApplicationStatus.values.firstWhere(
        (s) => s.apiValue == v,
        orElse: () => ApplicationStatus.saved,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Colour pair (foreground + background)
// ─────────────────────────────────────────────────────────────────────────────

class ColorPair {
  const ColorPair({required this.foreground, required this.background});
  final Color foreground;
  final Color background;
}

// ─────────────────────────────────────────────────────────────────────────────
// Status color map
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppStatusColors {
  static ColorPair forStatus(ApplicationStatus status, AppColors colors) =>
      switch (status) {
        ApplicationStatus.saved => ColorPair(
            foreground: colors.statusSaved, background: colors.statusSavedBg),
        ApplicationStatus.applied => ColorPair(
            foreground: colors.statusApplied,
            background: colors.statusAppliedBg),
        ApplicationStatus.assessment => ColorPair(
            foreground: colors.statusAssessment,
            background: colors.statusAssessmentBg),
        ApplicationStatus.hr =>
          ColorPair(foreground: colors.statusHr, background: colors.statusHrBg),
        ApplicationStatus.technical => ColorPair(
            foreground: colors.statusTechnical,
            background: colors.statusTechnicalBg),
        ApplicationStatus.finalRound => ColorPair(
            foreground: colors.statusFinal, background: colors.statusFinalBg),
        ApplicationStatus.offer => ColorPair(
            foreground: colors.statusOffer, background: colors.statusOfferBg),
        ApplicationStatus.rejected => ColorPair(
            foreground: colors.statusRejected,
            background: colors.statusRejectedBg),
      };

  /// Parse from JSON string, then look up colors
  static ColorPair fromApiValue(String apiValue, AppColors colors) =>
      forStatus(ApplicationStatusX.fromApiValue(apiValue), colors);
}

// ─────────────────────────────────────────────────────────────────────────────
// Score bands
// ─────────────────────────────────────────────────────────────────────────────

enum ScoreBand { excellent, good, average, poor }

extension ScoreBandX on ScoreBand {
  /// CSS label string used in overline text ("Excellent", "Good", ...)
  String get label => switch (this) {
        ScoreBand.excellent => 'Excellent',
        ScoreBand.good => 'Good',
        ScoreBand.average => 'Average',
        ScoreBand.poor => 'Needs Work',
      };
}

abstract class AppScoreColors {
  /// Bins a 0–100 score into a [ScoreBand]
  static ScoreBand bandFor(int score) {
    if (score >= 80) return ScoreBand.excellent;
    if (score >= 60) return ScoreBand.good;
    if (score >= 40) return ScoreBand.average;
    return ScoreBand.poor;
  }

  static ColorPair forScore(int score, AppColors colors) =>
      forBand(bandFor(score), colors);

  static ColorPair forBand(ScoreBand band, AppColors colors) => switch (band) {
        ScoreBand.excellent => ColorPair(
            foreground: colors.scoreExcellent,
            background: colors.scoreExcellentBg),
        ScoreBand.good => ColorPair(
            foreground: colors.scoreGood, background: colors.scoreGoodBg),
        ScoreBand.average => ColorPair(
            foreground: colors.scoreAverage, background: colors.scoreAverageBg),
        ScoreBand.poor => ColorPair(
            foreground: colors.scorePoor, background: colors.scorePoorBg),
      };

  /// Foreground-only shortcut (for ring stroke color, chart line, etc.)
  static Color strokeForScore(int score, AppColors colors) =>
      forScore(score, colors).foreground;

  /// Label string for a score ("Excellent", "Good", ...)
  static String labelForScore(int score) => bandFor(score).label;
}
