import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';

/// ResumePilot Design System — Reusable BoxDecoration & InputDecoration helpers
///
/// All factories accept an [AppColors] instance so they adapt automatically
/// to light / dark mode. Brightness is also required where shadows differ.
///
/// Card variants map to the MobileCard variants in the web design system:
///   default   → white/dark-surface + card shadow
///   outlined  → transparent + 1px border, no shadow
///   elevated  → surface + elevated shadow
///   sunken    → surfaceSunken background, no shadow
///   interactive → default + press-scale indication (handled by widget)

abstract class AppDecorations {
  // ─── Cards ─────────────────────────────────────────────────────────────────

  static BoxDecoration card(AppColors colors, Brightness brightness) =>
      BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.card(brightness),
      );

  static BoxDecoration cardOutlined(AppColors colors) => BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border, width: 1.0),
      );

  static BoxDecoration cardElevated(AppColors colors, Brightness brightness) =>
      BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.elevated(brightness),
      );

  static BoxDecoration cardSunken(AppColors colors) => BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(AppRadii.card),
      );

  /// Interactive card — shows elevated shadow (widget applies scale on press)
  static BoxDecoration cardInteractive(
    AppColors colors,
    Brightness brightness, {
    bool pressed = false,
  }) =>
      BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: pressed
            ? AppShadows.cardHover(brightness)
            : AppShadows.card(brightness),
      );

  // ─── Inputs ───────────────────────────────────────────────────────────────

  /// Standard InputDecoration used across all text fields.
  /// Height achieved with contentPadding — outer container is ~52 px.
  static InputDecoration inputDecoration({
    required AppColors colors,
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
    bool enabled = true,
  }) {
    final borderRadius = BorderRadius.circular(AppRadii.input);
    final borderColor = colors.inputBorder;
    final focusBorderColor = colors.inputFocus;
    final errorColor = colors.destructive;

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      isDense: false,
      // Vertical padding chosen so total input height ≈ 52 px (15px font + 2×18.5px)
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px14,
      ),
      // Borders
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: focusBorderColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: errorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: borderColor.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      // Fill
      filled: true,
      fillColor: enabled
          ? colors.surfacePrimary
          : colors.surfaceSecondary.withValues(alpha: 0.6),
    );
  }

  // ─── Chip / Filter pill ──────────────────────────────────────────────────

  static BoxDecoration chip({
    required AppColors colors,
    required bool active,
  }) =>
      BoxDecoration(
        color: active ? colors.primaryLight : colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(
          color: active ? colors.primaryMuted : colors.borderSubtle,
          width: 1.0,
        ),
      );

  // ─── Icon container ───────────────────────────────────────────────────────

  static BoxDecoration iconContainer({
    required Color backgroundColor,
    double radius = AppRadii.iconBox,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      );

  // ─── Status badge ─────────────────────────────────────────────────────────

  static BoxDecoration statusBadge({
    required Color backgroundColor,
    bool pill = false,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          pill ? AppRadii.badgePill : AppRadii.badge,
        ),
      );

  // ─── Bottom nav ───────────────────────────────────────────────────────────

  static BoxDecoration bottomNav(AppColors colors, Brightness brightness) =>
      BoxDecoration(
        color: colors.surfacePrimary,
        boxShadow: AppShadows.nav(brightness),
      );

  // ─── FAB ─────────────────────────────────────────────────────────────────

  static BoxDecoration fab(AppColors colors, Brightness brightness) =>
      BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.fab),
        boxShadow: AppShadows.fab(brightness),
      );

  static BoxDecoration fabExtended(AppColors colors, Brightness brightness) =>
      BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.fabExtended),
        boxShadow: AppShadows.fab(brightness),
      );

  // ─── Score card mini background ──────────────────────────────────────────

  static BoxDecoration scoreBg({
    required Color backgroundColor,
    double radius = AppRadii.cardSm,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      );

  // ─── Search bar ──────────────────────────────────────────────────────────

  static BoxDecoration searchBar(AppColors colors) => BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.full),
        border: Border.all(color: colors.borderSubtle, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: colors.border.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      );

  // ─── Section divider ─────────────────────────────────────────────────────

  static Divider dividerSubtle(AppColors colors) => Divider(
        color: colors.borderSubtle,
        thickness: 1.0,
        height: 1.0,
      );

  // ─── Focus ring (for focusable custom widgets) ───────────────────────────

  /// 2 px ring at `radius` + 2 using the primary focus ring color.
  static BoxDecoration focusRing(AppColors colors, double radius) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 2),
        border: Border.all(
          color: colors.ring.withValues(alpha: 0.5),
          width: 2.0,
        ),
      );
}
