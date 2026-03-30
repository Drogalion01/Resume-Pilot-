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

  // Surfaces — refined with warm undertones
  @override
  Color get background => const Color(0xFFFAFBFC); // Warm neutral white
  @override
  Color get backgroundPure => const Color(0xFFFFFFFF);
  @override
  Color get surfacePrimary => const Color(0xFFFFFFFF);
  @override
  Color get surfaceSecondary => const Color(0xFFF5F7FA); // Subtle warm
  @override
  Color get surfaceSunken => const Color(0xFFEEF1F6); // Refined depth

  // Text
  @override
  Color get foreground => const Color(0xFF0D1630); // hsl(222 56% 12%)
  @override
  Color get foregroundSecondary => const Color(0xFF4A547A); // hsl(228 24% 38%)
  @override
  Color get foregroundTertiary => const Color(0xFF6E7A9C); // hsl(224 18% 52%)
  @override
  Color get foregroundQuaternary => const Color(0xFF96A0BC); // hsl(220 18% 66%)

  // Primary — refined deep indigo for premium feel
  @override
  Color get primary => const Color(0xFF2D5AA8); // hsl(214 58% 42%) — sophisticated indigo
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover => const Color(0xFF3965B8); // hsl(214 58% 48%) — elevated hover
  @override
  Color get primaryLight => const Color(0xFFE0E8F5); // hsl(214 56% 92%) — subtle background
  @override
  Color get primaryMuted => const Color(0xFFB0BEDD); // hsl(214 50% 80%) — refined muted

  // Gold — luxe refined bronze
  @override
  Color get gold => const Color(0xFFD4A574); // hsl(30 60% 62%) — warm sophisticated bronze
  @override
  Color get goldForeground => const Color(0xFFFFFFFF);
  @override
  Color get goldMuted => const Color(0xFFEBDECD); // hsl(30 38% 87%) — elegant muted
  @override
  Color get goldLight => const Color(0xFFF8F3ED); // hsl(30 50% 96%) — pristine background

  // Borders / Inputs — refined with new primary color
  @override
  Color get border => const Color(0xFFC9D6E8); // hsl(214 48% 86%) — sophisticated border
  @override
  Color get borderSubtle => const Color(0xFFD9E3F0); // hsl(214 60% 90%) — refined subtle
  @override
  Color get inputBorder => const Color(0xFFC9D6E8);
  @override
  Color get inputFocus => const Color(0xFF2D5AA8);
  @override
  Color get ring => const Color(0xFF2D5AA8);

  // Destructive — refined red-brown
  @override
  Color get destructive => const Color(0xFF944432); // hsl(4 55% 50%) — dignified destructive
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight => const Color(0xFFF6E8E5); // hsl(4 55% 94%) — soft tone

  // ── Score colors — refined elegant palette ─────────────────────────────
  @override
  Color get scoreExcellent => const Color(0xFF2E8B6A); // hsl(152 45% 38%) — sophisticated green
  @override
  Color get scoreExcellentBg => const Color(0xFFDEF4EA); // hsl(152 38% 92%) — pristine bg
  @override
  Color get scoreGood => const Color(0xFF3A9970); // hsl(152 38% 44%) — refined growth
  @override
  Color get scoreGoodBg => const Color(0xFFDEF1E8); // hsl(152 32% 93%) — subtle backdrop
  @override
  Color get scoreAverage => const Color(0xFFB68E3D); // hsl(36 55% 50%) — warm competent
  @override
  Color get scoreAverageBg => const Color(0xFFF2EBD9); // hsl(36 50% 93%) — warm tone bg
  @override
  Color get scorePoor => const Color(0xFF944436); // hsl(4 50% 50%) — dignified caution
  @override
  Color get scorePoorBg => const Color(0xFFF5E6E3); // hsl(4 45% 94%) — soft red tone

  // ── Status colors — refined intelligent palette ───────────────────────────
  @override
  Color get statusApplied => const Color(0xFF3E6FB8); // hsl(214 50% 48%) — professional blue
  @override
  Color get statusAppliedBg => const Color(0xFFDEE7F3); // hsl(214 35% 92%)
  @override
  Color get statusInterview => const Color(0xFF704EB8); // hsl(270 35% 47%) — insightful purple
  @override
  Color get statusInterviewBg => const Color(0xFFE5DEEE); // hsl(270 25% 92%)
  @override
  Color get statusOffer => const Color(0xFF2E8B6D); // hsl(152 48% 40%) — success green
  @override
  Color get statusOfferBg => const Color(0xFFDEF4EA); // hsl(152 38% 92%)
  @override
  Color get statusRejected => const Color(0xFF944432); // hsl(4 55% 50%) — dignified red
  @override
  Color get statusRejectedBg => const Color(0xFFF6E8E5); // hsl(4 55% 94%)
  @override
  Color get statusSaved => const Color(0xFFB68A40); // hsl(36 55% 50%) — warm bronze
  @override
  Color get statusSavedBg => const Color(0xFFF2EBDA); // hsl(36 50% 93%)
  @override
  Color get statusAssessment => const Color(0xFF8A58CC); // hsl(286 35% 55%) — creative purple
  @override
  Color get statusAssessmentBg => const Color(0xFFEBDEF2); // hsl(286 28% 93%)
  @override
  Color get statusHr => const Color(0xFF3A8DB0); // hsl(200 48% 48%) — trustworthy teal
  @override
  Color get statusHrBg => const Color(0xFFDEECF3); // hsl(200 35% 92%)
  @override
  Color get statusTechnical => const Color(0xFF523A99); // hsl(262 44% 45%) — logical purple
  @override
  Color get statusTechnicalBg => const Color(0xFFE5DFF0); // hsl(262 30% 92%)
  @override
  Color get statusFinal => const Color(0xFF3E3E99); // hsl(242 43% 48%) — final purpose blue
  @override
  Color get statusFinalBg => const Color(0xFFDEDEF0); // hsl(242 30% 92%)

  // Hero gradients — refined premium aesthetic
  @override
  Color get heroGradient1 => const Color(0xFF9FC3F5); // hsl(214 80% 80%) — soft luxury
  @override
  Color get heroGradient2 => const Color(0xADBBC9F0); // hsl(218 60% 84%) — refined blend
  @override
  Color get heroGradient3 => const Color(0xFFD1DBEF); // hsl(216 70% 88%) — elegant light
  @override
  Color get heroGradient4 => const Color(0xFFE8EFFA); // hsl(214 76% 94%) — pristine
  @override
  Color get heroGoldGlow => const Color(0xFFEADCCA); // hsl(30 52% 88%) — luxe glow
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

  // Primary — luminous refined indigo accent
  @override
  Color get primary => const Color(0xFF89B3FF); // hsl(214 100% 72%) — sophisticated bright
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover => const Color(0xFF9AC1FF); // hsl(214 100% 76%) — elevated accent
  @override
  Color get primaryLight => const Color(0xFF172949); // hsl(214 52% 20%) — refined container
  @override
  Color get primaryMuted => const Color(0xFF1F3354); // hsl(214 48% 23%) — muted container

  // Gold — warm luxe bronze
  @override
  Color get gold => const Color(0xFFD9A876); // hsl(30 60% 63%) — warm luxury accent
  @override
  Color get goldForeground => const Color(0xFFFFFFFF);
  @override
  Color get goldMuted => const Color(0xFF3C2F23); // hsl(30 28% 22%) — refined muted
  @override
  Color get goldLight => const Color(0xFF2A1F18); // hsl(30 32% 17%) — dark container

  // Borders / Inputs — refined with new premium colors
  @override
  Color get border => const Color(0xFF2B384E); // hsl(214 35% 27%) — sophisticated border
  @override
  Color get borderSubtle => const Color(0xFF1F2C40); // hsl(214 40% 20%) — refined subtle
  @override
  Color get inputBorder => const Color(0xFF2B384E);
  @override
  Color get inputFocus => const Color(0xFF89B3FF);
  @override
  Color get ring => const Color(0xFF89B3FF);

  // Destructive — refined dignified red
  @override
  Color get destructive => const Color(0xFFC96A62); // hsl(4 55% 62%) — warm dignity
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight => const Color(0xFF2B1A18); // hsl(4 30% 16%) — warm shadow

  // ── Score colors (refined for dark mode) ───────────────────────────────
  @override
  Color get scoreExcellent => const Color(0xFF5CBFA8); // hsl(152 45% 60%) — refined green
  @override
  Color get scoreExcellentBg => const Color(0xFF1B2F28); // hsl(152 30% 16%)
  @override
  Color get scoreGood => const Color(0xFF62C5B0); // hsl(152 38% 64%) — polished growth
  @override
  Color get scoreGoodBg => const Color(0xFF1C3230); // hsl(152 28% 17%)
  @override
  Color get scoreAverage => const Color(0xFFC9A04C); // hsl(36 60% 60%) — refined bronze
  @override
  Color get scoreAverageBg => const Color(0xFF2B2218); // hsl(36 32% 16%)
  @override
  Color get scorePoor => const Color(0xFFC96A62); // hsl(4 50% 62%) — warm warning
  @override
  Color get scorePoorBg => const Color(0xFF2B1A18); // hsl(4 30% 16%)

  // ── Status colors (refined dark mode) ───────────────────────────────────
  @override
  Color get statusApplied => const Color(0xFF6B96D8); // hsl(214 50% 62%) — refined professional
  @override
  Color get statusAppliedBg => const Color(0xFF1D2540); // hsl(214 32% 18%)
  @override
  Color get statusInterview => const Color(0xFF9C80D8); // hsl(270 35% 65%) — uplifting purple
  @override
  Color get statusInterviewBg => const Color(0xFF262238); // hsl(270 24% 18%)
  @override
  Color get statusOffer => const Color(0xFF5CBFA8); // hsl(152 48% 60%) — success green
  @override
  Color get statusOfferBg => const Color(0xFF1B2F28); // hsl(152 30% 16%)
  @override
  Color get statusRejected => const Color(0xFFC96A62); // hsl(4 55% 62%) — warm dignity
  @override
  Color get statusRejectedBg => const Color(0xFF2B1A18); // hsl(4 30% 16%)
  @override
  Color get statusSaved => const Color(0xFFC9A04C); // hsl(36 60% 60%) — luxe bronze
  @override
  Color get statusSavedBg => const Color(0xFF2B2218); // hsl(36 32% 16%)
  @override
  Color get statusAssessment => const Color(0xFFB080E0); // hsl(286 35% 66%) — creative flair
  @override
  Color get statusAssessmentBg => const Color(0xFF2A2238); // hsl(286 24% 18%)
  @override
  Color get statusHr => const Color(0xFF62B0D0); // hsl(200 48% 62%) — trustworthy refined
  @override
  Color get statusHrBg => const Color(0xFF1C2630); // hsl(200 32% 18%)
  @override
  Color get statusTechnical => const Color(0xFF8A78D0); // hsl(262 44% 62%) — logical elegance
  @override
  Color get statusTechnicalBg => const Color(0xFF242230); // hsl(262 26% 18%)
  @override
  Color get statusFinal => const Color(0xFF7A78D0); // hsl(242 43% 62%) — assured finality
  @override
  Color get statusFinalBg => const Color(0xFF22212E); // hsl(242 26% 18%)

  // ── Hero gradients — premium dark aesthetic ──────────────────────────────
  @override
  Color get heroGradient1 => const Color(0xFF0F2A52); // hsl(214 68% 19%) — refined deep
  @override
  Color get heroGradient2 => const Color(0xFF15305C); // hsl(218 60% 22%) — ethereal layer
  @override
  Color get heroGradient3 => const Color(0xFF1B3866); // hsl(216 64% 25%) — luxe depth
  @override
  Color get heroGradient4 => const Color(0xFF0A1020); // hsl(224 52% 8%) — midnight anchor
  @override
  Color get heroGoldGlow => const Color(0xFF3F2F20); // hsl(30 40% 22%) — warm shadow
}
