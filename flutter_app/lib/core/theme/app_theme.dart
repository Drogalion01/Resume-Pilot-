import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// ResumePilot Design System — ThemeData factory
///
/// Provides [lightTheme] and [darkTheme] as static getters.
/// Each ThemeData is a full Material 3 theme wired up with the
/// ResumePilot color and typography tokens.
///
/// Widgets should read colors via the extension:
///   final colors = Theme.of(context).appColors;
///
/// Usage in MaterialApp:
///   MaterialApp(
///     theme:      AppTheme.lightTheme,
///     darkTheme:  AppTheme.darkTheme,
///     themeMode:  ThemeMode.system,   // or driven by settings provider
///   )

abstract class AppTheme {
  /// ── Light Theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme => _build(const AppColorsLight());

  /// ── Dark Theme ──────────────────────────────────────────────────────────
  static ThemeData get darkTheme => _build(const AppColorsDark());

  // ─── Internal builder ────────────────────────────────────────────────────
  static ThemeData _build(AppColors c) {
    final isDark = c is AppColorsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;

    // ── ColourScheme ─────────────────────────────────────────────────────
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.primaryForeground,
      primaryContainer: c.primaryLight,
      onPrimaryContainer: c.primary,
      secondary: c.gold,
      onSecondary: c.goldForeground,
      secondaryContainer: c.goldLight,
      onSecondaryContainer: c.goldForeground,
      tertiary: c.statusInterview,
      onTertiary: Colors.white,
      tertiaryContainer: c.statusInterviewBg,
      onTertiaryContainer: c.statusInterview,
      error: c.destructive,
      onError: c.destructiveForeground,
      errorContainer: c.destructiveLight,
      onErrorContainer: c.destructive,
      surface: c.surfacePrimary,
      onSurface: c.foreground,
      surfaceContainerHighest: c.surfaceSecondary,
      onSurfaceVariant: c.foregroundSecondary,
      outline: c.border,
      outlineVariant: c.borderSubtle,
      shadow: isDark ? const Color(0xFF000000) : const Color(0xFF080812),
      scrim: const Color(0xFF000000),
      inverseSurface: isDark ? c.surfacePrimary : const Color(0xFF1C1C24),
      onInverseSurface: isDark ? c.foreground : const Color(0xFFEEEDF4),
      inversePrimary:
          isDark ? const Color(0xFF4A3975) : const Color(0xFF8A6DC2),
    );

    // ── TextTheme ────────────────────────────────────────────────────────
    final textTheme = AppTextStyles.buildTextTheme(
      primary: c.foreground,
      secondary: c.foregroundSecondary,
      tertiary: c.foregroundTertiary,
      quaternary: c.foregroundQuaternary,
    );

    // ── InputDecoration theme ────────────────────────────────────────────
    final inputTheme = InputDecorationTheme(
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px14,
      ),
      filled: true,
      fillColor: c.surfacePrimary,
      hintStyle: AppTextStyles.inputText.copyWith(
        color: c.foregroundQuaternary,
      ),
      labelStyle: AppTextStyles.inputLabel.copyWith(
        color: c.foregroundTertiary,
      ),
      floatingLabelStyle: AppTextStyles.inputLabel.copyWith(
        color: c.primary,
      ),
      helperStyle: AppTextStyles.inputHelper.copyWith(
        color: c.foregroundTertiary,
      ),
      errorStyle: AppTextStyles.inputHelper.copyWith(
        color: c.destructive,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.inputFocus, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.destructive, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(color: c.borderSubtle),
      ),
    );

    // ── ElevatedButton ───────────────────────────────────────────────────
    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.primaryForeground,
        disabledBackgroundColor: c.primaryMuted,
        disabledForegroundColor: c.foregroundTertiary,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size.fromHeight(AppSpacing.buttonH),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        textStyle: AppTextStyles.buttonLabel,
        animationDuration: const Duration(milliseconds: 120),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return c.primaryForeground.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.hovered)) {
            return c.primaryForeground.withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
    );

    // ── OutlinedButton ───────────────────────────────────────────────────
    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.primary,
        disabledForegroundColor: c.foregroundTertiary,
        minimumSize: const Size.fromHeight(AppSpacing.buttonH),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        side: BorderSide(color: c.border),
        textStyle: AppTextStyles.buttonLabel,
      ),
    );

    // ── TextButton ────────────────────────────────────────────────────────
    final textButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primary,
        disabledForegroundColor: c.foregroundTertiary,
        minimumSize: const Size(44, AppSpacing.buttonH),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px16,
          vertical: AppSpacing.px8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        textStyle: AppTextStyles.buttonLabel,
      ),
    );

    // ── FilledButton (soft / tinted variant) ─────────────────────────────
    final filledButtonTheme = FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primaryLight,
        foregroundColor: c.primary,
        disabledBackgroundColor: c.surfaceSecondary,
        disabledForegroundColor: c.foregroundTertiary,
        minimumSize: const Size.fromHeight(AppSpacing.buttonH),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.button),
        ),
        textStyle: AppTextStyles.buttonLabel,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );

    // ── Card ──────────────────────────────────────────────────────────────
    final cardTheme = CardThemeData(
      color: c.surfacePrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      margin: EdgeInsets.zero,
    );

    // ── AppBar ────────────────────────────────────────────────────────────
    final appBarTheme = AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.foreground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.headline.copyWith(color: c.foreground),
      toolbarTextStyle: AppTextStyles.bodyMedium.copyWith(color: c.foreground),
      iconTheme: IconThemeData(color: c.foreground, size: 22),
      actionsIconTheme: IconThemeData(color: c.foreground, size: 22),
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: c.surfacePrimary,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: c.surfacePrimary,
            ),
    );

    // ── BottomNavigationBar ───────────────────────────────────────────────
    final bottomNavTheme = BottomNavigationBarThemeData(
      backgroundColor: c.surfacePrimary,
      selectedItemColor: c.primary,
      unselectedItemColor: c.foregroundTertiary,
      selectedLabelStyle: AppTextStyles.navLabel.copyWith(color: c.primary),
      unselectedLabelStyle:
          AppTextStyles.navLabel.copyWith(color: c.foregroundTertiary),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );

    // ── NavigationBar (Material 3) ────────────────────────────────────────
    final navigationBarTheme = NavigationBarThemeData(
      backgroundColor: c.surfacePrimary,
      indicatorColor: c.primaryLight,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: c.primary, size: 22);
        }
        return IconThemeData(color: c.foregroundTertiary, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.navLabel.copyWith(color: c.primary);
        }
        return AppTextStyles.navLabel.copyWith(color: c.foregroundTertiary);
      }),
      height: AppSpacing.bottomNavH,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );

    // ── Chip ──────────────────────────────────────────────────────────────
    final chipTheme = ChipThemeData(
      backgroundColor: c.surfaceSecondary,
      selectedColor: c.primaryLight,
      disabledColor: c.surfaceSunken,
      labelStyle: AppTextStyles.caption.copyWith(color: c.foregroundSecondary),
      secondaryLabelStyle: AppTextStyles.caption.copyWith(color: c.primary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px12,
        vertical: AppSpacing.px6,
      ),
      side: BorderSide(color: c.borderSubtle),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      elevation: 0,
      pressElevation: 0,
    );

    // ── Divider ───────────────────────────────────────────────────────────
    final dividerTheme = DividerThemeData(
      color: c.borderSubtle,
      thickness: 1.0,
      space: 1.0,
    );

    // ── Dialog / BottomSheet ──────────────────────────────────────────────
    final dialogTheme = DialogThemeData(
      backgroundColor: c.surfacePrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
      ),
      titleTextStyle: AppTextStyles.headline.copyWith(color: c.foreground),
      contentTextStyle:
          AppTextStyles.body.copyWith(color: c.foregroundSecondary),
    );

    final bottomSheetTheme = BottomSheetThemeData(
      backgroundColor: c.surfacePrimary,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.dialog),
        ),
      ),
      elevation: 8,
      dragHandleColor: c.borderSubtle,
    );

    // ── Snackbar ──────────────────────────────────────────────────────────
    final snackBarTheme = SnackBarThemeData(
      backgroundColor: isDark
          ? c.surfaceSecondary
          : const Color(0xFF181820), // dark surface on light
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: isDark ? c.foreground : const Color(0xFFEEEDF4),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.snackbar),
        side: BorderSide(
          color: isDark ? c.border : Colors.transparent,
          width: isDark ? 1 : 0,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    );

    // ── Switch ───────────────────────────────────────────────────────────
    final switchTheme = SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primaryForeground;
        return c.foregroundTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primary;
        return c.surfaceSecondary;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return c.border;
      }),
    );

    // ── ListTile ─────────────────────────────────────────────────────────
    final listTileTheme = ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: AppSpacing.listItemV,
      ),
      minVerticalPadding: 0,
      iconColor: c.foregroundTertiary,
      textColor: c.foreground,
      titleTextStyle: AppTextStyles.bodyMedium.copyWith(color: c.foreground),
      subtitleTextStyle:
          AppTextStyles.caption.copyWith(color: c.foregroundTertiary),
    );

    // ── FloatingActionButton ──────────────────────────────────────────────
    final fabTheme = FloatingActionButtonThemeData(
      backgroundColor: c.primary,
      foregroundColor: c.primaryForeground,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.fab),
      ),
      extendedTextStyle: AppTextStyles.buttonLabel.copyWith(
        color: c.primaryForeground,
      ),
    );

    // ── ProgressIndicator ─────────────────────────────────────────────────
    final progressTheme = ProgressIndicatorThemeData(
      color: c.primary,
      linearTrackColor: c.primaryLight,
      circularTrackColor: c.primaryLight,
      linearMinHeight: 4,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadii.full)),
    );

    // ── Tooltip ───────────────────────────────────────────────────────────
    final tooltipTheme = TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark
            ? c.surfaceSecondary.withValues(alpha: 0.96)
            : const Color(0xFF181820).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadii.xs),
        border: Border.all(
          color: isDark ? c.borderSubtle : Colors.transparent,
        ),
      ),
      textStyle: AppTextStyles.micro.copyWith(
        color: isDark ? c.foreground : const Color(0xFFEEEDF4),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
    );

    // ── IconButton ────────────────────────────────────────────────────────
    final iconButtonTheme = IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: c.foreground,
        minimumSize: const Size(AppSpacing.touchMin, AppSpacing.touchMin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    );

    // ── TabBar ────────────────────────────────────────────────────────────
    final tabBarTheme = TabBarThemeData(
      labelColor: c.primary,
      unselectedLabelColor: c.foregroundTertiary,
      labelStyle: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.w600,
        color: c.primary,
      ),
      unselectedLabelStyle: AppTextStyles.caption.copyWith(
        color: c.foregroundTertiary,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: c.primary, width: 2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: c.borderSubtle,
    );

    // ── TimePicker ─────────────────────────────────────────────────────────
    final timePickerTheme = TimePickerThemeData(
      backgroundColor: c.surfacePrimary,
      dialBackgroundColor: c.surfaceSecondary,
      hourMinuteColor: c.surfaceSecondary,
      hourMinuteTextColor: c.foreground,
      dayPeriodColor: c.primaryLight,
      dayPeriodTextColor: c.primary,
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.button),
      ),
      dialHandColor: c.primary,
      dialTextColor: c.foreground,
      entryModeIconColor: c.primary,
      helpTextStyle: AppTextStyles.caption.copyWith(color: c.foreground),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: c.surfaceSecondary,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px12,
          vertical: AppSpacing.px8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: c.inputFocus, width: 1.5),
        ),
      ),
    );

    // ── Assemble ─────────────────────────────────────────────────────────
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // Wire Plus Jakarta Sans as the app-wide text theme
      textTheme: GoogleFonts.plusJakartaSansTextTheme(textTheme),
      primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
        textTheme.apply(bodyColor: c.primaryForeground),
      ),
      scaffoldBackgroundColor: c.background,
      canvasColor: c.surfacePrimary,
      cardColor: c.surfacePrimary,
      dividerColor: c.borderSubtle,
      hintColor: c.foregroundQuaternary,
      disabledColor: c.foregroundQuaternary,
      focusColor: c.ring.withValues(alpha: 0.2),
      highlightColor: c.primary.withValues(alpha: 0.05),
      splashColor: c.primary.withValues(alpha: 0.08),
      // Sub-themes
      inputDecorationTheme: inputTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      filledButtonTheme: filledButtonTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavTheme,
      navigationBarTheme: navigationBarTheme,
      chipTheme: chipTheme,
      dividerTheme: dividerTheme,
      dialogTheme: dialogTheme,
      bottomSheetTheme: bottomSheetTheme,
      snackBarTheme: snackBarTheme,
      switchTheme: switchTheme,
      listTileTheme: listTileTheme,
      floatingActionButtonTheme: fabTheme,
      progressIndicatorTheme: progressTheme,
      tooltipTheme: tooltipTheme,
      iconButtonTheme: iconButtonTheme,
      tabBarTheme: tabBarTheme,
      timePickerTheme: timePickerTheme,
      // Ink ripple tuning
      splashFactory: InkRipple.splashFactory,
      // Page transitions (Android-native feel)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    ).appColorsExtension(c);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ThemeExtension — bind AppColors into ThemeData
// so widgets can call: Theme.of(context).appColors
// ─────────────────────────────────────────────────────────────────────────────

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension(this.colors);
  final AppColors colors;

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    // Color lerp not supported for the full token set; return this at t<0.5
    if (t < 0.5) return this;
    return other ?? this;
  }
}

extension AppThemeX on ThemeData {
  AppColors get appColors =>
      extension<AppColorsExtension>()?.colors ?? const AppColorsLight();
}

extension _ThemeDataAppColors on ThemeData {
  ThemeData appColorsExtension(AppColors c) => copyWith(
        extensions: [...(extensions.values.toList()), AppColorsExtension(c)],
      );
}
