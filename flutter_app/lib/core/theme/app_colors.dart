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

  // Surfaces — refined minimal with warm undertones
  @override
  Color get background => const Color(0xFFFCFDFE); // Pristine minimal
  @override
  Color get backgroundPure => const Color(0xFFFFFFFF);
  @override
  Color get surfacePrimary => const Color(0xFFFFFFFF);
  @override
  Color get surfaceSecondary => const Color(0xFFF7F9FB); // Refined subtle
  @override
  Color get surfaceSunken => const Color(0xFFF0F4F7); // Soft depth

  // Text — minimal refined grays
  @override
  Color get foreground =>
      const Color(0xFF1F2937); // hsl(217 26% 18%) — minimal dark
  @override
  Color get foregroundSecondary =>
      const Color(0xFF6B7280); // hsl(217 14% 45%) — soft gray
  @override
  Color get foregroundTertiary =>
      const Color(0xFF9CA3AF); // hsl(217 12% 65%) — refined gray
  @override
  Color get foregroundQuaternary =>
      const Color(0xFFD1D5DB); // hsl(217 14% 82%) — light gray

  // Primary — refined minimal indigo (less vibrant, more sophisticated)
  @override
  Color get primary =>
      const Color(0xFF475569); // hsl(216 18% 34%) — muted sophisticated
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover =>
      const Color(0xFF5A6B82); // hsl(216 18% 42%) — elevated muted
  @override
  Color get primaryLight =>
      const Color(0xFFE8EDF4); // hsl(216 28% 92%) — soft background
  @override
  Color get primaryMuted =>
      const Color(0xFFC1C9D6); // hsl(216 20% 78%) — refined muted

  // Gold — warm refined taupe (less bright, more minimal)
  @override
  Color get gold => const Color(0xFFB8A398); // hsl(18 20% 65%) — warm taupe
  @override
  Color get goldForeground => const Color(0xFFFFFFFF);
  @override
  Color get goldMuted =>
      const Color(0xFFE4DDD6); // hsl(18 18% 87%) — soft taupe
  @override
  Color get goldLight =>
      const Color(0xFFFAF8F6); // hsl(18 30% 97%) — pristine warm

  // Borders / Inputs — minimal refined
  @override
  Color get border =>
      const Color(0xFFE5E7EB); // hsl(217 14% 90%) — minimal border
  @override
  Color get borderSubtle =>
      const Color(0xFFF3F4F6); // hsl(217 14% 96%) — subtle edge
  @override
  Color get inputBorder => const Color(0xFFE5E7EB);
  @override
  Color get inputFocus => const Color(0xFF475569);
  @override
  Color get ring => const Color(0xFF475569);

  // Destructive — refined minimal red
  @override
  Color get destructive =>
      const Color(0xFF7A5454); // hsl(0 20% 45%) — minimal red tone
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight =>
      const Color(0xFFF5EDED); // hsl(0 18% 94%) — soft tone

  // ── Score colors — refined elegant palette ─────────────────────────────
  @override
  Color get scoreExcellent =>
      const Color(0xFF2E8B6A); // hsl(152 45% 38%) — sophisticated green
  @override
  Color get scoreExcellentBg =>
      const Color(0xFFDEF4EA); // hsl(152 38% 92%) — pristine bg
  @override
  Color get scoreGood =>
      const Color(0xFF3A9970); // hsl(152 38% 44%) — refined growth
  @override
  Color get scoreGoodBg =>
      const Color(0xFFDEF1E8); // hsl(152 32% 93%) — subtle backdrop
  @override
  Color get scoreAverage =>
      const Color(0xFFB68E3D); // hsl(36 55% 50%) — warm competent
  @override
  Color get scoreAverageBg =>
      const Color(0xFFF2EBD9); // hsl(36 50% 93%) — warm tone bg
  @override
  Color get scorePoor =>
      const Color(0xFF944436); // hsl(4 50% 50%) — dignified caution
  @override
  Color get scorePoorBg =>
      const Color(0xFFF5E6E3); // hsl(4 45% 94%) — soft red tone

  // ── Status colors — refined intelligent palette ───────────────────────────
  @override
  Color get statusApplied =>
      const Color(0xFF3E6FB8); // hsl(214 50% 48%) — professional blue
  @override
  Color get statusAppliedBg =>
      const Color(0xFFBDCBE8); // hsl(214 35% 82%) — improved contrast
  @override
  Color get statusInterview =>
      const Color(0xFF704EB8); // hsl(270 35% 47%) — insightful purple
  @override
  Color get statusInterviewBg =>
      const Color(0xFFC8BEDC); // hsl(270 25% 82%) — improved contrast
  @override
  Color get statusOffer =>
      const Color(0xFF2E8B6D); // hsl(152 48% 40%) — success green
  @override
  Color get statusOfferBg =>
      const Color(0xFFBCE5D8); // hsl(152 38% 82%) — improved contrast
  @override
  Color get statusRejected =>
      const Color(0xFF944432); // hsl(4 55% 50%) — dignified red
  @override
  Color get statusRejectedBg =>
      const Color(0xFFEDD0C8); // hsl(4 55% 84%) — improved contrast
  @override
  Color get statusSaved =>
      const Color(0xFFB68A40); // hsl(36 55% 50%) — warm bronze
  @override
  Color get statusSavedBg =>
      const Color(0xFFE9D0B0); // hsl(36 50% 81%) — improved contrast
  @override
  Color get statusAssessment =>
      const Color(0xFF8A58CC); // hsl(286 35% 55%) — creative purple
  @override
  Color get statusAssessmentBg =>
      const Color(0xFFD8C5E0); // hsl(286 28% 82%) — improved contrast
  @override
  Color get statusHr =>
      const Color(0xFF3A8DB0); // hsl(200 48% 48%) — trustworthy teal
  @override
  Color get statusHrBg =>
      const Color(0xFFBDD8E5); // hsl(200 35% 82%) — improved contrast
  @override
  Color get statusTechnical =>
      const Color(0xFF523A99); // hsl(262 44% 45%) — logical purple
  @override
  Color get statusTechnicalBg =>
      const Color(0xFFC8BFD8); // hsl(262 30% 82%) — improved contrast
  @override
  Color get statusFinal =>
      const Color(0xFF3E3E99); // hsl(242 43% 48%) — final purpose blue
  @override
  Color get statusFinalBg =>
      const Color(0xFFBDBDE0); // hsl(242 30% 82%) — improved contrast

  // ── Hero gradients — minimal refined aesthetic
  @override
  Color get heroGradient1 => const Color(0xFFF5F7FA); // Soft neutral light
  @override
  Color get heroGradient2 => const Color(0xFFF1F5F9); // Refined neutral
  @override
  Color get heroGradient3 => const Color(0xFFEFF4F8); // Subtle tone
  @override
  Color get heroGradient4 => const Color(0xFFF8FAFB); // Pristine
  @override
  Color get heroGoldGlow => const Color(0xFFEBE5DF); // Soft warm tone
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark Mode
// ─────────────────────────────────────────────────────────────────────────────

class AppColorsDark extends AppColors {
  const AppColorsDark();

  // Surfaces — refined minimal dark (NOT too dark, more usable)
  @override
  Color get background =>
      const Color(0xFF0F1318); // hsl(217 20% 7%) — minimal night
  @override
  Color get backgroundPure =>
      const Color(0xFF0A0E12); // hsl(217 26% 5%) — pure dark
  @override
  Color get surfacePrimary =>
      const Color(0xFF16202B); // hsl(217 33% 13%) — refined surface
  @override
  Color get surfaceSecondary =>
      const Color(0xFF1F2A37); // hsl(217 33% 17%) — elevated surface
  @override
  Color get surfaceSunken =>
      const Color(0xFF0D1620); // hsl(217 35% 10%) — subtle depth

  // Text — minimal refined grays for dark
  @override
  Color get foreground =>
      const Color(0xFFE5E7EB); // hsl(217 14% 90%) — minimal light
  @override
  Color get foregroundSecondary =>
      const Color(0xFFA6ADBB); // hsl(217 12% 68%) — soft gray
  @override
  Color get foregroundTertiary =>
      const Color(0xFF7F8A9A); // hsl(217 14% 53%) — refined gray
  @override
  Color get foregroundQuaternary =>
      const Color(0xFF575D6B); // hsl(217 12% 38%) — deep gray

  // Primary — minimal muted accent for dark (matches light mode muted tone)
  @override
  Color get primary =>
      const Color(0xFF8B95A5); // hsl(216 14% 60%) — minimal accent
  @override
  Color get primaryForeground => const Color(0xFFFFFFFF);
  @override
  Color get primaryHover =>
      const Color(0xFF9DA8B8); // hsl(216 14% 68%) — elevated accent
  @override
  Color get primaryLight =>
      const Color(0xFF1E293B); // hsl(217 32% 16%) — refined container
  @override
  Color get primaryMuted =>
      const Color(0xFF2D3748); // hsl(217 26% 21%) — muted container

  // Gold — minimal warm taupe for dark
  @override
  Color get gold =>
      const Color(0xFFC9B8AA); // hsl(18 20% 75%) — warm taupe tone
  @override
  Color get goldForeground => const Color(0xFFFFFFFF);
  @override
  Color get goldMuted =>
      const Color(0xFF3A322B); // hsl(18 18% 23%) — minimal muted
  @override
  Color get goldLight =>
      const Color(0xFF252219); // hsl(18 18% 15%) — dark container

  // Borders / Inputs — minimal refined dark
  @override
  Color get border =>
      const Color(0xFF38444F); // hsl(217 20% 28%) — minimal border
  @override
  Color get borderSubtle =>
      const Color(0xFF252E38); // hsl(217 26% 19%) — subtle edge
  @override
  Color get inputBorder => const Color(0xFF38444F);
  @override
  Color get inputFocus => const Color(0xFF8B95A5);
  @override
  Color get ring => const Color(0xFF8B95A5);

  // Destructive — minimal refined red for dark
  @override
  Color get destructive =>
      const Color(0xFF9B7472); // hsl(0 20% 60%) — minimal red tone
  @override
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  @override
  Color get destructiveLight =>
      const Color(0xFF1F1514); // hsl(0 18% 12%) — dark tone

  // ── Score colors — minimal refined ─────────────────────────────────────
  @override
  Color get scoreExcellent =>
      const Color(0xFF70938B); // hsl(152 20% 56%) — refined green
  @override
  Color get scoreExcellentBg => const Color(0xFF172316); // hsl(152 26% 10%)
  @override
  Color get scoreGood =>
      const Color(0xFF7FA896); // hsl(152 18% 62%) — minimal growth
  @override
  Color get scoreGoodBg => const Color(0xFF1A281F); // hsl(152 24% 12%)
  @override
  Color get scoreAverage =>
      const Color(0xFF9B8B6B); // hsl(36 20% 58%) — minimal bronze
  @override
  Color get scoreAverageBg => const Color(0xFF231D13); // hsl(36 30% 12%)
  @override
  Color get scorePoor =>
      const Color(0xFF9B7472); // hsl(4 20% 60%) — minimal warning
  @override
  Color get scorePoorBg => const Color(0xFF201614); // hsl(4 26% 10%)

  // ── Status colors — minimal refined ──────────────────────────────────
  @override
  Color get statusApplied =>
      const Color(0xFF748EA0); // hsl(214 20% 58%) — minimal professional
  @override
  Color get statusAppliedBg => const Color(0xFF1B2533); // hsl(214 28% 16%)
  @override
  Color get statusInterview =>
      const Color(0xFF8E7FA0); // hsl(270 18% 58%) — minimal purple
  @override
  Color get statusInterviewBg => const Color(0xFF202230); // hsl(270 22% 16%)
  @override
  Color get statusOffer =>
      const Color(0xFF70938B); // hsl(152 20% 56%) — minimal green
  @override
  Color get statusOfferBg => const Color(0xFF172316); // hsl(152 26% 10%)
  @override
  Color get statusRejected =>
      const Color(0xFF9B7472); // hsl(4 20% 60%) — minimal red
  @override
  Color get statusRejectedBg => const Color(0xFF201614); // hsl(4 26% 10%)
  @override
  Color get statusSaved =>
      const Color(0xFF9B8B6B); // hsl(36 20% 58%) — minimal bronze
  @override
  Color get statusSavedBg => const Color(0xFF231D13); // hsl(36 30% 12%)
  @override
  Color get statusAssessment =>
      const Color(0xFF8E7FA0); // hsl(286 18% 58%) — minimal creativity
  @override
  Color get statusAssessmentBg => const Color(0xFF1F1F2A); // hsl(286 20% 16%)
  @override
  Color get statusHr =>
      const Color(0xFF6B8a9b); // hsl(200 18% 55%) — minimal trustworthy
  @override
  Color get statusHrBg => const Color(0xFF1A2431); // hsl(200 26% 16%)
  @override
  Color get statusTechnical =>
      const Color(0xFF7F7A9a); // hsl(262 14% 56%) — minimal logic
  @override
  Color get statusTechnicalBg => const Color(0xFF1E1E2A); // hsl(262 20% 16%)
  @override
  Color get statusFinal =>
      const Color(0xFF7A7A9a); // hsl(242 14% 56%) — minimal final
  @override
  Color get statusFinalBg => const Color(0xFF1D1D2A); // hsl(242 20% 16%)

  // ── Hero gradients — premium dark aesthetic ──────────────────────────────
  @override
  Color get heroGradient1 =>
      const Color(0xFF0F2A52); // hsl(214 68% 19%) — refined deep
  @override
  Color get heroGradient2 =>
      const Color(0xFF15305C); // hsl(218 60% 22%) — ethereal layer
  @override
  Color get heroGradient3 =>
      const Color(0xFF1B3866); // hsl(216 64% 25%) — luxe depth
  @override
  Color get heroGradient4 =>
      const Color(0xFF0A1020); // hsl(224 52% 8%) — midnight anchor
  @override
  Color get heroGoldGlow =>
      const Color(0xFF3F2F20); // hsl(30 40% 22%) — warm shadow
}
