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

    return Container(
      decoration: BoxDecoration(
        color: colors.surfacePrimary.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: colors.primaryLight, width: 1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        currentIndex: currentIndex,
        onTap: onDestinationSelected,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.foregroundTertiary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
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
      ),
    );
  }
}
