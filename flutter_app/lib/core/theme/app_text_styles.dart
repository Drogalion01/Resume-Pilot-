import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ResumePilot Design System — Typography
///
/// Mirrors the CSS typography scale from src/index.css exactly.
/// Font: Plus Jakarta Sans (Google Fonts).
///
/// Scale:
///   display      28px / 34px / ExtraBold  / letterSpacing -0.5
///   headline     20px / 28px / Bold       / letterSpacing -0.2
///   title        15px / 22px / Bold       / letterSpacing -0.1
///   body         15px / 22px / Regular
///   bodyMedium   15px / 22px / Medium
///   caption      13px / 18px / Medium
///   overline     11px / 16px / SemiBold   / uppercase / letterSpacing +0.7
///   micro        10px / 14px / SemiBold
///
/// Text colour is intentionally NOT set here — apply via DefaultTextStyle
/// or explicit style parameter so that light/dark switching works.
/// Use AppTheme.lightTheme / darkTheme to get colour-aware TextTheme.

abstract class AppTextStyles {
  // ── Raw TextStyles (no color) ─────────────────────────────────────────────

  static TextStyle get display => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        height: 34 / 28, // 1.214
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  static TextStyle get headline => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        height: 28 / 20, // 1.4
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  static TextStyle get title => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15, // 1.467
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        height: 18 / 13, // 1.385
        fontWeight: FontWeight.w500,
      );

  /// 11px · SemiBold · Uppercase · letter-spacing +0.7
  static TextStyle get overline => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        height: 16 / 11, // 1.455
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
      );

  static TextStyle get micro => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        height: 14 / 10, // 1.4
        fontWeight: FontWeight.w600,
      );

  // ── Colour-bearing convenience methods ───────────────────────────────────
  // Call these when you already have a color reference:
  //   AppTextStyles.display.copyWith(color: colors.foreground)

  // ── Button label styles ─────────────────────────────────────────────────

  /// Full-width / large button label  (15px SemiBold)
  static TextStyle get buttonLabel => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  /// Small button label  (13px SemiBold)
  static TextStyle get buttonLabelSm => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  // ── Input / form ────────────────────────────────────────────────────────

  /// Text inside an input field  (15px Regular)
  static TextStyle get inputText => body;

  /// Field label above an input  (13px Medium)
  static TextStyle get inputLabel => caption;

  /// Helper / error text below an input  (12px Regular)
  static TextStyle get inputHelper => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
      );

  // ── Score / numeric display ──────────────────────────────────────────────

  /// Large score number inside the ring (e.g. "92")
  static TextStyle get scoreNumber => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        height: 1.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  /// Medium score number on score cards
  static TextStyle get scoreNumberMd => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        height: 1.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      );

  // ── Nav label ───────────────────────────────────────────────────────────

  /// Bottom navigation bar labels  (10px SemiBold)
  static TextStyle get navLabel => micro;

  // ── Build a Material TextTheme from a colour set ─────────────────────────
  // Used internally by AppTheme to wire up ThemeData.textTheme.
  static TextTheme buildTextTheme({
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color quaternary,
  }) {
    return TextTheme(
      // Display → displayLarge
      displayLarge: display.copyWith(color: primary),
      // Headline → headlineMedium
      headlineMedium: headline.copyWith(color: primary),
      // Title → titleMedium
      titleMedium: title.copyWith(color: primary),
      // Body → bodyMedium / bodySmall
      bodyLarge: body.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: primary),
      bodySmall: caption.copyWith(color: secondary),
      // Label → labelSmall (overline / micro)
      labelSmall: micro.copyWith(color: tertiary),
      labelMedium: caption.copyWith(color: secondary),
    );
  }
}
