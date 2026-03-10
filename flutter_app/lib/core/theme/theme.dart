/// ResumePilot Design System — single-import barrel
///
/// Import this file wherever design tokens are needed:
///   import 'package:resume_pilot/core/theme/theme.dart';
///
/// What's included:
///   AppColors, AppColorsLight, AppColorsDark   → color tokens
///   AppTextStyles                               → typography scale
///   AppSpacing, AppRadii                        → layout constants
///   AppShadows                                  → BoxShadow lists
///   AppGradients                                → gradient factories
///   AppStatusColors, AppScoreColors             → semantic color maps
///   ApplicationStatus, ScoreBand, ColorPair     → enums & helpers
///   AppDecorations                              → BoxDecoration helpers
///   AppTheme, AppThemeX, AppColorsExtension     → ThemeData + extension
library;

export 'app_colors.dart';
export 'app_text_styles.dart';
export 'app_spacing.dart';       // AppSpacing + AppRadii (same file)
export 'app_shadows.dart';
export 'app_gradients.dart';
export 'app_status_colors.dart'; // ApplicationStatus, ScoreBand, ColorPair, AppStatusColors, AppScoreColors
export 'app_decorations.dart';
export 'app_theme.dart';         // AppTheme, AppThemeX, AppColorsExtension
