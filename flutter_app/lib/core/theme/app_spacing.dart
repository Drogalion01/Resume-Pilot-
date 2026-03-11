/// ResumePilot Design System — Spacing & Radius Tokens
///
/// Spacing: 4 px base grid (standard Material / mobile-first scale).
/// Radius:  fixed token set aligned to the product's visual design spec.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Spacing
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppSpacing {
  // ── Base ─────────────────────────────────────────────────────────────────
  static const double px2 = 2.0; // 4px × 0.5
  static const double px4 = 4.0; // 4px × 1
  static const double px6 = 6.0; // 4px × 1.5
  static const double px8 = 8.0; // 4px × 2
  static const double px10 = 10.0; // 4px × 2.5
  static const double px12 = 12.0; // 4px × 3
  static const double px14 = 14.0; // 4px × 3.5
  static const double px16 = 16.0; // 4px × 4
  static const double px20 = 20.0; // 4px × 5
  static const double px24 = 24.0; // 4px × 6
  static const double px28 = 28.0; // 4px × 7
  static const double px32 = 32.0; // 4px × 8
  static const double px40 = 40.0; // 4px × 10
  static const double px48 = 48.0; // 4px × 12
  static const double px56 = 56.0; // 4px × 14
  static const double px64 = 64.0; // 4px × 16

  // ── Semantic aliases ──────────────────────────────────────────────────────

  /// Horizontal page edge padding  (px-5 = 20 px)
  static const double pageH = px20;

  /// Vertical gap between sections on a screen  (space-y-8 = 32 px)
  static const double sectionV = px32;

  /// Vertical gap between cards within a section  (space-y-3 = 12 px)
  static const double cardGap = px12;

  /// Inner card padding  (p-4 = 16 px)
  static const double cardPad = px16;

  /// Tight inner card padding for dense cards  (p-3 = 12 px)
  static const double cardPadSm = px12;

  /// Touch-target minimum height
  static const double touchMin = 44.0;

  /// Standard input / button height  (~52 px — matches 'input height ~52px' spec)
  static const double inputH = 52.0;

  /// Small button height
  static const double buttonHSm = 36.0;

  /// Standard button height
  static const double buttonH = 44.0;

  /// Bottom navigation bar height  (~62 px spec)
  static const double bottomNavH = 62.0;

  /// FAB size (square)
  static const double fabSize = 56.0;

  /// Icon container box size (small)
  static const double iconBoxSm = 32.0;

  /// Icon container box size (default)
  static const double iconBox = 40.0;

  /// Icon container box size (large)
  static const double iconBoxLg = 48.0;

  /// List item vertical padding  (py-3 = 12 px each side)
  static const double listItemV = px12;
}

// ─────────────────────────────────────────────────────────────────────────────
// Radii
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppRadii {
  static const double xs = 6.0; //  6 px — tight corners
  static const double sm = 8.0; //  8 px — small buttons / chips
  static const double md = 12.0; // 12 px — inputs, standard buttons
  static const double lg = 16.0; // 16 px — medium cards
  static const double xl = 20.0; // 20 px — primary card radius
  static const double xl2 = 24.0; // 24 px — bottom sheets / dialogs
  static const double full = 999.0; // pill / circle

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const double card = xl; // 20 — rounded-xl cards
  static const double cardSm = lg; // 16
  static const double input = md; // 12 — input fields
  static const double button = md; // 12 — standard buttons
  static const double buttonSm = sm; //  8 — small buttons
  static const double chip = full; // pill chips
  static const double badge = xs; //  6 — small status badges
  static const double badgePill = full;
  static const double fab = xl; // 20 — FAB
  static const double fabExtended = full; // extended FAB
  static const double bottomNav = 0.0; // full bleed nav bar
  static const double iconBox = md; // 12 — icon container
  static const double iconBoxLg = lg; // 16
  static const double dialog = xl2; // 24 — bottom sheets / dialogs
  static const double snackbar = md; // 12
}
