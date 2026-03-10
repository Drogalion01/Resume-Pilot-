import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../app/router/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.heroBackground(colors),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Brand mark
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryButton(colors),
                    borderRadius: BorderRadius.circular(AppRadii.xl2),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.4),
                        blurRadius: 32,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'R',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        color: colors.primaryForeground,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.px20),
                Text(
                  'ResumePilot',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.foreground,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.px12),
                Text(
                  'AI-powered resume analysis\nthat gets you hired.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.foregroundSecondary,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                // Primary CTA
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go(AppRoutes.onboarding),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: AppSpacing.px12),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.foregroundSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.px16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
