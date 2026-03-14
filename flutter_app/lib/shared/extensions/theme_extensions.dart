import 'package:flutter/material.dart';

extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  Color get primaryColor => theme.primaryColor;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color get surfaceColor => colors.surface;
  Color get accentColor => theme.primaryColor;
  TextTheme get textTheme => theme.textTheme;
}
