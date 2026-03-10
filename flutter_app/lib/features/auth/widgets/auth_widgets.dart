import 'package:flutter/material.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthScreenShell
//
// Top-level layout for all auth screens.
//
// Structure:
//   Stack ─ full-screen gradient + ambient glows
//     └─ SafeArea
//          └─ Column
//               ├─ (optional back button)
//               ├─ AuthHero          ← sits in gradient area
//               └─ AuthFormSheet     ← rounded-top white/dark card
// ─────────────────────────────────────────────────────────────────────────────

class AuthScreenShell extends StatelessWidget {
  const AuthScreenShell({
    super.key,
    required this.hero,
    required this.form,
    this.showBack = true,
  });

  final Widget hero;
  final Widget form;

  /// Show the system back arrow (suppressed on welcome/onboarding screens).
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      // Avoid the scaffold background peeking behind the gradient.
      backgroundColor: colors.background,
      // Let the form card handle safe-area bottom padding internally.
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-screen gradient background ────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.heroBackground(colors),
            ),
          ),

          // ── Ambient glow blobs ─────────────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: _GlowBlob(
              gradient: AppGradients.heroGlow1(colors),
              size: 280,
            ),
          ),
          Positioned(
            bottom: 250,
            left: -80,
            child: _GlowBlob(
              gradient: AppGradients.heroGlow2(colors),
              size: 220,
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button row (always reserved height)
                SizedBox(
                  height: 48,
                  child: showBack
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(color: colors.foreground),
                        )
                      : const SizedBox.shrink(),
                ),

                // Hero content inside gradient area
                Flexible(
                  flex: 3,
                  child: hero,
                ),

                // Form card — rounded top, expands to fill remaining space
                Expanded(
                  flex: 5,
                  child: form,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthHero
//
// Icon box + title + optional subtitle, centered inside the gradient area.
// ─────────────────────────────────────────────────────────────────────────────

class AuthHero extends StatelessWidget {
  const AuthHero({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gradient icon box
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryButton(colors),
              borderRadius: BorderRadius.circular(AppRadii.xl),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.40),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: colors.primaryForeground, size: 30),
          ),
          const SizedBox(height: AppSpacing.px16),

          // Title
          Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.foreground,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.px8),
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.foregroundSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthFormSheet
//
// Rounded-top card that floats over the gradient. Contains form content.
// Adds bottom safe-area padding so content clears the home indicator.
// ─────────────────────────────────────────────────────────────────────────────

class AuthFormSheet extends StatelessWidget {
  const AuthFormSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final brightness = Theme.of(context).brightness;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.xl2),
        ),
        boxShadow: AppShadows.elevated(brightness),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.px24,
          AppSpacing.px28,
          AppSpacing.px24,
          AppSpacing.px24 + bottomPad,
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthErrorBanner
//
// Inline error display shown above the form when a request fails.
// Animates in/out using AnimatedSize.
// ─────────────────────────────────────────────────────────────────────────────

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({
    super.key,
    required this.error,
    required this.onDismiss,
  });

  final AppException? error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: error == null
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.px20),
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.px12, AppSpacing.px10, AppSpacing.px8, AppSpacing.px10),
              decoration: BoxDecoration(
                color: colors.destructiveLight,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(
                  color: colors.destructive.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: colors.destructive,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.px8),
                  Expanded(
                    child: Text(
                      error!.userMessage,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.destructive,
                        height: 1.45,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Icon(
                        Icons.close_rounded,
                        color: colors.destructive.withValues(alpha: 0.7),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthSubmitButton
//
// Full-width gradient primary button. Shows a white spinner when loading.
// ─────────────────────────────────────────────────────────────────────────────

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final disabled = loading || onPressed == null;

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.inputH, // 52 px — slightly taller than default button
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.button),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadii.button),
          child: Ink(
            decoration: BoxDecoration(
              gradient: disabled ? null : AppGradients.primaryButton(colors),
              color: disabled ? colors.surfaceSecondary : null,
              borderRadius: BorderRadius.circular(AppRadii.button),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: disabled
                            ? colors.foregroundTertiary
                            : Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthDivider
//
// "Or" separator for social auth rows (reserved for future use).
// ─────────────────────────────────────────────────────────────────────────────

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.label = 'or'});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Divider(color: colors.borderSubtle, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px12),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.foregroundQuaternary,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.borderSubtle, height: 1)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthFooterLink
//
// E.g. "Don't have an account? Sign up"
// ─────────────────────────────────────────────────────────────────────────────

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onTap,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.px8),
          child: RichText(
            text: TextSpan(
              style: textTheme.bodyMedium?.copyWith(
                color: colors.foregroundSecondary,
              ),
              children: [
                TextSpan(text: prefixText),
                TextSpan(
                  text: linkText,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GlowBlob — ambient decorative radial gradient (ignores pointer events)
// ─────────────────────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.gradient, required this.size});
  final Gradient gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
      ),
    );
  }
}
