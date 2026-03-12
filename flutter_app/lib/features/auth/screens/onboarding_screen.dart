import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../app/router/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = <_OnboardingPage>[
    _OnboardingPage(
      icon: Icons.description_rounded,
      title: 'Upload your resume',
      body: 'Import any PDF resume in seconds. We support all common formats.',
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome_rounded,
      title: 'Get AI feedback',
      body: 'Our AI scores your resume and tells you exactly what to improve.',
    ),
    _OnboardingPage(
      icon: Icons.trending_up_rounded,
      title: 'Land more interviews',
      body: 'Track applications, prep for interviews, and close the loop.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) {
                final page = _pages[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.px32, vertical: AppSpacing.px20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colors.primaryMuted,
                          borderRadius: BorderRadius.circular(AppRadii.xl2),
                        ),
                        child: Icon(page.icon, size: 48, color: colors.primary),
                      ),
                      const SizedBox(height: AppSpacing.px32),
                      Text(
                        page.title,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.foreground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.px12),
                      Text(
                        page.body,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.foregroundSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              final active = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? colors.primary : colors.primaryMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.px20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                child: Text(isLast ? 'Create Account' : 'Next'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.px32),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
}
