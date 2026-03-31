import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../app/router/routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.foreground.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfacePrimary.withValues(alpha: 0.98),
                border: Border.all(color: colors.borderSubtle, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BottomNavigationBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      currentIndex: currentIndex,
                      onTap: onDestinationSelected,
                      selectedItemColor: colors.primary,
                      unselectedItemColor: colors.foregroundSecondary,
                      selectedFontSize: 13,
                      unselectedFontSize: 12,
                      type: BottomNavigationBarType.fixed,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          activeIcon: Icon(Icons.home_rounded),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.work_outline_rounded),
                          activeIcon: Icon(Icons.work_rounded),
                          label: 'Track',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.school_outlined),
                          activeIcon: Icon(Icons.school_rounded),
                          label: 'Resume Lab',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings_outlined),
                          activeIcon: Icon(Icons.settings_rounded),
                          label: 'Settings',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
