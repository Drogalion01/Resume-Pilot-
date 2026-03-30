import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

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
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfacePrimary.withValues(alpha: 0.97),
                border: Border.all(color: colors.primaryLight, width: 1),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                currentIndex: currentIndex,
                onTap: onDestinationSelected,
                selectedItemColor: colors.primary,
                unselectedItemColor: colors.foregroundTertiary,
                selectedFontSize: 12,
                unselectedFontSize: 11,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
