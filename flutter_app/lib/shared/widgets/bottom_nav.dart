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

    return BottomNavigationBar(
      backgroundColor: colors.surfacePrimary,
      currentIndex: currentIndex,
      onTap: onDestinationSelected,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.foregroundTertiary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          activeIcon: Icon(Icons.description_rounded),
          label: 'Resumes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline_rounded),
          activeIcon: Icon(Icons.work_rounded),
          label: 'Applications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tune_outlined),
          activeIcon: Icon(Icons.tune_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
