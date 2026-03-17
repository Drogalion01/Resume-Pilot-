import 'package:flutter/material.dart';

/// ResumePilot Design System — Color Tokens
///
/// All tokens are converted from the HSL values in src/index.css.
/// Split into [AppColorsLight] and [AppColorsDark] static classes.
/// Use via extension: Theme.of(context).appColors (see app_theme.dart).
///
/// Color naming mirrors the CSS custom property names exactly so
/// diffs against the web source are trivial.

// ─────────────────────────────────────────────────────────────────────────────
// Shared / Mode-independent raw palette
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppColors {
  const AppColors();

  // ── Pure semantic references (implement in each mode) ──────────────────────
  Color get background;
  Color get backgroundPure;
  Color get surfacePrimary;
  Color get surfaceSecondary;
  Color get surfaceSunken;

  Color get foreground;
  Color get foregroundSecondary;
  Color get foregroundTertiary;
  Color get foregroundQuaternary;

  Color get primary;
  Color get primaryForeground;
  Color get primaryHover;
  Color get primaryLight;
  Color get primaryMuted;

  Color get gold;
  Color get goldForeground;
  Color get goldMuted;
  Color get goldLight;

  Color get border;
  Color get borderSubtle;
  Color get inputBorder;
  Color get inputFocus;
  Color get ring;

  Color get destructive;
  Color get destructiveForeground;
  Color get destructiveLight;

  // Scores
  Color get scoreExcellent;
  Color get scoreExcellentBg;
  Color get scoreGood;
  Color get scoreGoodBg;
  Color get scoreAverage;
  Color get scoreAverageBg;
  Color get scorePoor;
  Color get scorePoorBg;

  // Statuses
  Color get statusApplied;
  Color get statusAppliedBg;
  Color get statusInterview;
  Color get statusInterviewBg;
  Color get statusOffer;
  Color get statusOfferBg;
  Color get statusRejected;
  Color get statusRejectedBg;
  Color get statusSaved;
  Color get statusSavedBg;
  Color get statusAssessment;
  Color get statusAssessmentBg;
  Color get statusHr;
  Color get statusHrBg;
  Color get statusTechnical;
  Color get statusTechnicalBg;
  Color get statusFinal;
  Color get statusFinalBg;

  // Hero gradients
  Color get heroGradient1;
  Color get heroGradient2;
  Color get heroGradient3;
  Color get heroGradient4;
  Color get heroGoldGlow;
}

// ─────────────────────────────────────────────────────────────────────────────
// Light Mode
// ─────────────────────────────────────────────────────────────────────────────

class AppColorsLight extends AppColors {
  const AppColorsLight();

  // Surfaces
  @override
  Color get background => const Color(0xFFF0F5FF); // hsl(225 100% 97%)
  @override
  Color get backgroundPure => const Color(0xFFFFFFFF);
  @override
  Color get surfacePrimary => const Color(0xFFFFFFFF);
  @override
  Color get surfaceSecondary => const Color(0xFFE6EEFB); // hsl(218 70% 94%)
  @override
  Color get surfaceSunken => const Color(0xFFDDE8F8); // hsl(216 72% 92%)

  // Text
  @override
  Color get foreground => const Color(0xFF0D1630); // hsl(222 56% 12%)
  @override
  Color get foregroundSecondary => const Color(0xFF4A547A); // hsl(228 24% 38%)
  @override
  Color get foregroundTertiary => const Color(0xFF6E7A9C); // hsl(224 18% 52%)
  @override
  Color get foregroundQuaternary => const Color(0xFF96A0BC); // hsl(220 18% 66%)

  // Primary — deep purple hsl(262 36% 36%)
  @override
  Color get primary => const Color(0xFF3B68D4); // hsl(220 62% 52%)
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover => const Color(0xFF4D78E4); // hsl(220 70% 60%)
  @override
  Color get primaryLight => const Color(0xFFE2EDFB); // hsl(216 80% 93%)
  @override
  Color get primaryMuted => const Color(0xFFBBCCEE); // hsl(218 52% 83%)

  // Gold — hsl(34 85% 65%)
  @override
  Color get gold => const Color(0xFFF0AA4B); // hsl(34 85% 65%)
  @override
  Color get goldForeground => const Color(0xFF4A2E0E); // hsl(30 50% 18%)
  @override
  Color get goldMuted => const Color(0xFFECDEC7); // hsl(34 40% 88%)
  @override
  Color get goldLight => const Color(0xFFF9F3E8); // hsl(34 50% 95%)

  // Borders / Inputs
  @override
  Color get border => const Color(0xFFCCD6ED); // hsl(218 44% 87%)
  @override
  Color get borderSubtle => const Color(0xFFD8E2F5); // hsl(218 60% 91%)
  @override
  Color get inputBorder => const Color(0xFFCCD6ED);
  @override
  Color get inputFocus => const Color(0xFF3B68D4);
  @override
  Color get ring => const Color(0xFF3B68D4);

  // Destructive
  @override
  Color get destructive => const Color(0xFF8F3A36); // hsl(4 52% 50%)
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight => const Color(0xFFF5E9E8); // hsl(4 45% 95%)

  // ── Score colors ─────────────────────────────────────────────────────────
  @override
  Color get scoreExcellent => const Color(0xFF2E7D5A); // hsl(152 42% 34%)
  @override
  Color get scoreExcellentBg => const Color(0xFFDCF0E5); // hsl(152 30% 92%)
  @override
  Color get scoreGood => const Color(0xFF3A8A62); // hsl(152 32% 42%)
  @override
  Color get scoreGoodBg => const Color(0xFFDEEFE5); // hsl(152 24% 93%)
  @override
  Color get scoreAverage => const Color(0xFFAA7020); // hsl(36 56% 46%)
  @override
  Color get scoreAverageBg => const Color(0xFFF0E5D4); // hsl(36 40% 93%)
  @override
  Color get scorePoor => const Color(0xFF8A3430); // hsl(4 52% 48%)
  @override
  Color get scorePoorBg => const Color(0xFFF5E4E2); // hsl(4 38% 94%)

  // ── Status colors ────────────────────────────────────────────────────────
  @override
  Color get statusApplied => const Color(0xFF3E6DB8); // hsl(218 46% 48%)
  @override
  Color get statusAppliedBg => const Color(0xFFDDE6F5); // hsl(218 34% 93%)
  @override
  Color get statusInterview => const Color(0xFF694EB2); // hsl(270 32% 44%)
  @override
  Color get statusInterviewBg => const Color(0xFFE5DFEE); // hsl(270 22% 92%)
  @override
  Color get statusOffer => const Color(0xFF2C7D54); // hsl(152 40% 36%)
  @override
  Color get statusOfferBg => const Color(0xFFDCF0E5); // hsl(152 30% 92%)
  @override
  Color get statusRejected => const Color(0xFF8A3838); // hsl(4 48% 48%)
  @override
  Color get statusRejectedBg => const Color(0xFFF5E3E3); // hsl(4 36% 94%)
  @override
  Color get statusSaved => const Color(0xFFA87030); // hsl(36 52% 46%)
  @override
  Color get statusSavedBg => const Color(0xFFEFE4D4); // hsl(36 38% 93%)
  @override
  Color get statusAssessment => const Color(0xFF7E3DB2); // hsl(286 36% 48%)
  @override
  Color get statusAssessmentBg => const Color(0xFFEADEF0); // hsl(286 26% 93%)
  @override
  Color get statusHr => const Color(0xFF3680A0); // hsl(200 42% 44%)
  @override
  Color get statusHrBg => const Color(0xFFDAECF2); // hsl(200 30% 92%)
  @override
  Color get statusTechnical => const Color(0xFF4A3899); // hsl(262 34% 42%)
  @override
  Color get statusTechnicalBg => const Color(0xFFE1DCF0); // hsl(262 24% 92%)
  @override
  Color get statusFinal => const Color(0xFF3C3E99); // hsl(242 36% 46%)
  @override
  Color get statusFinalBg => const Color(0xFFDDDEF0); // hsl(242 26% 93%)

  // ── Hero gradients ───────────────────────────────────────────────────────
  @override
  Color get heroGradient1 => const Color(0xFFB2C8F4); // hsl(218 76% 82%)
  @override
  Color get heroGradient2 => const Color(0xFFC0CEEE); // hsl(222 52% 85%)
  @override
  Color get heroGradient3 => const Color(0xFFCDD9F4); // hsl(220 66% 88%)
  @override
  Color get heroGradient4 => const Color(0xFFDEE8FB); // hsl(216 80% 93%)
  @override
  Color get heroGoldGlow => const Color(0xFFEDD0A4); // hsl(34 52% 86%)
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark Mode
// ─────────────────────────────────────────────────────────────────────────────

class AppColorsDark extends AppColors {
  const AppColorsDark();

  // Surfaces — richer midnight spectrum with clearer elevation steps
  @override
  Color get background => const Color(0xFF0A1020); // hsl(224 52% 8%)
  @override
  Color get backgroundPure => const Color(0xFF060A16); // hsl(228 50% 6%)
  @override
  Color get surfacePrimary => const Color(0xFF111B31); // hsl(224 48% 13%)
  @override
  Color get surfaceSecondary => const Color(0xFF17243C); // hsl(222 44% 16%)
  @override
  Color get surfaceSunken => const Color(0xFF0C152B); // hsl(224 54% 11%)

  // Text
  @override
  Color get foreground => const Color(0xFFF0F4FF); // hsl(224 100% 97%)
  @override
  Color get foregroundSecondary => const Color(0xFF93A3C9); // hsl(220 32% 68%)
  @override
  Color get foregroundTertiary => const Color(0xFF7282A6); // hsl(220 24% 55%)
  @override
  Color get foregroundQuaternary => const Color(0xFF4E5F86); // hsl(222 26% 42%)

  // Primary — luminous sapphire accent
  @override
  Color get primary => const Color(0xFF7A98FF); // hsl(224 100% 74%)
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover => const Color(0xFF8CABFF); // hsl(220 100% 77%)
  @override
  Color get primaryLight => const Color(0xFF1A2A52); // hsl(224 52% 21%)
  @override
  Color get primaryMuted => const Color(0xFF26365F); // hsl(222 42% 26%)

  // Gold
  @override
  Color get gold => const Color(0xFFE6AE64); // hsl(34 72% 65%)
  @override
  Color get goldForeground => const Color(0xFFFFFFFF);
  @override
  Color get goldMuted => const Color(0xFF3A3020); // hsl(35 30% 24%)
  @override
  Color get goldLight => const Color(0xFF2E2416); // hsl(34 34% 18%)

  // Borders / Inputs
  @override
  Color get border => const Color(0xFF29375A); // hsl(222 38% 26%)
  @override
  Color get borderSubtle => const Color(0xFF1D2846); // hsl(224 42% 20%)
  @override
  Color get inputBorder => const Color(0xFF29375A);
  @override
  Color get inputFocus => const Color(0xFF7A98FF);
  @override
  Color get ring => const Color(0xFF7A98FF);

  // Destructive
  @override
  Color get destructive => const Color(0xFF994444); // hsl(4 50% 55%)
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight => const Color(0xFF2A1A1A); // hsl(4 36% 16%)

  // ── Score colors (brightened for dark) ──────────────────────────────────
  @override
  Color get scoreExcellent => const Color(0xFF4AAA7A); // hsl(152 40% 48%)
  @override
  Color get scoreExcellentBg => const Color(0xFF1A2B22); // hsl(152 28% 14%)
  @override
  Color get scoreGood => const Color(0xFF52B880); // hsl(152 30% 52%)
  @override
  Color get scoreGoodBg => const Color(0xFF1B2C23); // hsl(152 22% 15%)
  @override
  Color get scoreAverage => const Color(0xFFBB8A42); // hsl(36 48% 55%)
  @override
  Color get scoreAverageBg => const Color(0xFF28201A); // hsl(36 32% 14%)
  @override
  Color get scorePoor => const Color(0xFFBB5050); // hsl(4 44% 55%)
  @override
  Color get scorePoorBg => const Color(0xFF2A1A1A); // hsl(4 30% 14%)

  // ── Status colors ────────────────────────────────────────────────────────
  @override
  Color get statusApplied => const Color(0xFF5E88CC); // hsl(218 40% 58%)
  @override
  Color get statusAppliedBg => const Color(0xFF1C2438); // hsl(218 30% 16%)
  @override
  Color get statusInterview => const Color(0xFF7E62CC); // hsl(270 30% 58%)
  @override
  Color get statusInterviewBg => const Color(0xFF222030); // hsl(270 22% 16%)
  @override
  Color get statusOffer => const Color(0xFF4AA87A); // hsl(152 36% 48%)
  @override
  Color get statusOfferBg => const Color(0xFF1A2B22); // hsl(152 28% 14%)
  @override
  Color get statusRejected => const Color(0xFFBB5050); // hsl(4 40% 55%)
  @override
  Color get statusRejectedBg => const Color(0xFF2A1A1A); // hsl(4 30% 14%)
  @override
  Color get statusSaved => const Color(0xFFBB8844); // hsl(36 42% 55%)
  @override
  Color get statusSavedBg => const Color(0xFF281F18); // hsl(36 30% 14%)
  @override
  Color get statusAssessment => const Color(0xFF9A58CC); // hsl(286 30% 56%)
  @override
  Color get statusAssessmentBg => const Color(0xFF22203A); // hsl(286 22% 16%)
  @override
  Color get statusHr => const Color(0xFF4E9AB0); // hsl(200 36% 52%)
  @override
  Color get statusHrBg => const Color(0xFF182228); // hsl(200 26% 14%)
  @override
  Color get statusTechnical => const Color(0xFF7068B0); // hsl(262 28% 54%)
  @override
  Color get statusTechnicalBg => const Color(0xFF20202E); // hsl(262 20% 16%)
  @override
  Color get statusFinal => const Color(0xFF6068AA); // hsl(242 30% 56%)
  @override
  Color get statusFinalBg => const Color(0xFF1E2030); // hsl(242 22% 16%)

  // ── Hero gradients ───────────────────────────────────────────────────────
  @override
  Color get heroGradient1 => const Color(0xFF132B56); // hsl(220 62% 21%)
  @override
  Color get heroGradient2 => const Color(0xFF1A3262); // hsl(222 58% 24%)
  @override
  Color get heroGradient3 => const Color(0xFF21386A); // hsl(222 52% 27%)
  @override
  Color get heroGradient4 => const Color(0xFF0A1020); // hsl(224 52% 8%)
  @override
  Color get heroGoldGlow => const Color(0xFF463419); // hsl(35 46% 24%)
}
