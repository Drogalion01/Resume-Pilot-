import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/bottom_nav.dart';
import 'routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ShellScaffold
//
// Persistent wrapper for the bottom-navigation tabs + drawer navigation.
// GoRouter's StatefulShellRoute.indexedStack creates this widget and injects
// the StatefulNavigationShell which manages the IndexedStack.
// We wrap it in a Scaffold with BottomNav (3 tabs) and a Drawer for secondary features.
// ─────────────────────────────────────────────────────────────────────────────

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.navigationShell});

  /// Injected by GoRouter — manages the IndexedStack for tab persistence.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // StatefulShellRoute.indexedStack owns the IndexedStack; expose its
      // child widget directly as the body.
      body: navigationShell,

      // Drawer for secondary features & settings
      drawer: _buildDrawer(context),

      // Persistent bottom nav — no need for extendBody since we draw
      // a blurred container inside BottomNav itself.
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTabTap(context, index),
      ),
    );
  }

  void _onTabTap(BuildContext context, int index) {
    // Settings tab (index 3) navigates to settings screen
    if (index == 3) {
      context.push(AppRoutes.settings);
      return;
    }

    // goBranch preserves deep-link state per branch.
    // initialLocation: true resets a branch to its root when re-tapping
    // the already-active tab (matches iOS/Android convention).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Interview Calendar'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.interviewCalendar);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.profile);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
