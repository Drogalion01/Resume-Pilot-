import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/theme/app_theme.dart';

/// Interview Calendar — Calendar navigation screen.
///
/// Provides quick access to interview management from applications.
class InterviewCalendarScreen extends StatelessWidget {
  const InterviewCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Calendar'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.foreground,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: colors.primaryMuted,
            ),
            const SizedBox(height: 24),
            Text(
              'Interview Calendar',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Manage your interviews directly from your applications. View, schedule, and prepare for interviews.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.foregroundSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.applications),
              icon: const Icon(Icons.work_rounded),
              label: const Text('Go to Applications'),
            ),
          ],
        ),
      ),
    );
  }
}
