import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

extension BuildContextX on BuildContext {
  ThemeData      get theme        => Theme.of(this);
  ColorScheme    get colorScheme  => Theme.of(this).colorScheme;
  TextTheme      get textTheme    => Theme.of(this).textTheme;
  AppColors      get colors       => Theme.of(this).appColors;
  bool           get isDark       => Theme.of(this).brightness == Brightness.dark;
  double         get screenWidth  => MediaQuery.sizeOf(this).width;
  double         get screenHeight => MediaQuery.sizeOf(this).height;
  double         get paddingBottom => MediaQuery.paddingOf(this).bottom;
  double         get paddingTop    => MediaQuery.paddingOf(this).top;
}
