import 'package:flutter/material.dart';

/// ResumePilot Design System — Shadow Tokens
///
/// Converts the CSS --shadow-* custom properties into Flutter BoxShadow lists.
/// Two sets: light-mode (warm grey tones) and dark-mode (pure black tones).
///
/// Light source: --shadow-xs/sm/md/lg/xl/card/card-hover/elevated/nav/fab
/// Dark source:  same names with higher opacity values.

abstract class AppShadows {
  // ── Light mode ─────────────────────────────────────────────────────────────

  /// 0 1px 2px 0 rgba(8,8,18,.04)
  static const List<BoxShadow> xsLight = [
    BoxShadow(
      color: Color(0x0A080812),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// 0 1px 3px rgba(8,8,18,.05) + 0 1px 2px -1px rgba(8,8,18,.04)
  static const List<BoxShadow> smLight = [
    BoxShadow(color: Color(0x0D080812), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x0A080812),
      blurRadius: 2,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
  ];

  /// 0 4px 6px -1px rgba(8,8,18,.06) + 0 2px 4px -2px rgba(8,8,18,.04)
  static const List<BoxShadow> mdLight = [
    BoxShadow(
      color: Color(0x0F080812),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A080812),
      blurRadius: 4,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ];

  /// 0 8px 20px -4px rgba(8,8,18,.08) + 0 4px 8px -4px rgba(8,8,18,.04)
  static const List<BoxShadow> lgLight = [
    BoxShadow(
      color: Color(0x14080812),
      blurRadius: 20,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A080812),
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  /// Default card shadow
  static const List<BoxShadow> cardLight = [
    BoxShadow(color: Color(0x0D080812), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x08080812), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Card hover / interactive press shadow  (purple tinted)
  static const List<BoxShadow> cardHoverLight = [
    BoxShadow(
      color: Color(0x1A4A3975), // purple 10%
      blurRadius: 14,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A080812),
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevated state shadow  (purple tinted, stronger)
  static const List<BoxShadow> elevatedLight = [
    BoxShadow(
      color: Color(0x1F4A3975), // purple 12%
      blurRadius: 24,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D080812),
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  /// Bottom nav shadow (upward)  0 -1px 4px rgba(8,8,18,.05)
  static const List<BoxShadow> navLight = [
    BoxShadow(
      color: Color(0x0D080812),
      blurRadius: 4,
      offset: Offset(0, -1),
    ),
  ];

  /// FAB shadow  (purple tinted, prominent)
  static const List<BoxShadow> fabLight = [
    BoxShadow(
      color: Color(0x404A3975), // purple 25%
      blurRadius: 16,
      spreadRadius: -3,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0F080812),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  // ── Dark mode ───────────────────────────────────────────────────────────────

  static const List<BoxShadow> xsDark = [
    BoxShadow(color: Color(0x26000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> smDark = [
    BoxShadow(color: Color(0x2E000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 2,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x38000000),
      blurRadius: 8,
      spreadRadius: -1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lgDark = [
    BoxShadow(
      color: Color(0x47000000),
      blurRadius: 20,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(color: Color(0x24000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> cardHoverDark = [
    BoxShadow(
      color: Color(0x1F8A6DC2), // dark-primary 12%
      blurRadius: 12,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevatedDark = [
    BoxShadow(
      color: Color(0x248A6DC2), // dark-primary 14%
      blurRadius: 24,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> navDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 3,
      offset: Offset(0, -1),
    ),
  ];

  static const List<BoxShadow> fabDark = [
    BoxShadow(
      color: Color(0x3D8A6DC2), // dark-primary 24%
      blurRadius: 16,
      spreadRadius: -3,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  // ── Brightness-aware helpers ─────────────────────────────────────────────
  static List<BoxShadow> card(Brightness brightness) =>
      brightness == Brightness.light ? cardLight : cardDark;

  static List<BoxShadow> cardHover(Brightness brightness) =>
      brightness == Brightness.light ? cardHoverLight : cardHoverDark;

  static List<BoxShadow> elevated(Brightness brightness) =>
      brightness == Brightness.light ? elevatedLight : elevatedDark;

  static List<BoxShadow> nav(Brightness brightness) =>
      brightness == Brightness.light ? navLight : navDark;

  static List<BoxShadow> fab(Brightness brightness) =>
      brightness == Brightness.light ? fabLight : fabDark;

  static List<BoxShadow> sm(Brightness brightness) =>
      brightness == Brightness.light ? smLight : smDark;

  static List<BoxShadow> md(Brightness brightness) =>
      brightness == Brightness.light ? mdLight : mdDark;

  static List<BoxShadow> lg(Brightness brightness) =>
      brightness == Brightness.light ? lgLight : lgDark;
}
