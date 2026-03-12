import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/bottom_nav.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ShellScaffold
//
// Persistent wrapper for the bottom-navigation tabs.  GoRouter's
// StatefulShellRoute.indexedStack creates this widget and injects the
// StatefulNavigationShell which already manages its own IndexedStack.
// We just need to wrap it in a Scaffold with our BottomNav.
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

      // Persistent bottom nav — no need for extendBody since we draw
      // a blurred container inside BottomNav itself.
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTabTap,
      ),
    );
  }

  void _onTabTap(int index) {
    // goBranch preserves deep-link state per branch.
    // initialLocation: true resets a branch to its root when re-tapping
    // the already-active tab (matches iOS/Android convention).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
