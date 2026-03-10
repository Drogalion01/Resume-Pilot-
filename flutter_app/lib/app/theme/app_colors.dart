// ⚠ CANONICAL IMPLEMENTATION MOVED
//
// All 80+ color tokens with precise HSL→hex conversions are now at:
//   lib/core/theme/app_colors.dart
//
// Import via barrel:
//   import 'package:resume_pilot/core/theme/theme.dart';
//   scorePoor          HSL(4, 52%, 48%)    → Color(0xFFBB3A34)
//
// Application status colors (applied, interview, offer, rejected, saved,
//   assessment, hr_screen, technical, final_round):
//   statusColors: Map<ApplicationStatus, StatusColorPair>
//     Each pair has: foreground + background
//
// Dark mode variants defined in AppColors.dark namespace.
// Use AppColors.primary, AppColors.gold directly — never hardcode hex values in widgets.
