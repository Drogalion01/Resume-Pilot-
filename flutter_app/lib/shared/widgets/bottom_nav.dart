import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppBottomNav
//
// Blurred, Material-3-style bottom navigation bar.
// Uses a custom painter approach (not NavigationBar) to achieve:
//   • frosted-glass card background (BackdropFilter blur 20)
//   • animated dot indicator under the active tab
//   • icon + label layout, bold/normal based on active state
// ─────────────────────────────────────────────────────────────────────────────

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _tabs = <_NavTab>[
    _NavTab(label: 'Home', icon: Icons.home_rounded, activeIcon: Icons.home_rounded),
    _NavTab(label: 'Resumes', icon: Icons.description_outlined, activeIcon: Icons.description_rounded),
    _NavTab(label: 'Applications', icon: Icons.work_outline_rounded, activeIcon: Icons.work_rounded),
    _NavTab(label: 'Settings', icon: Icons.tune_outlined, activeIcon: Icons.tune_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final barHeight = 62.0 + bottom;

    return SizedBox(
      height: barHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Frosted glass background ──────────────────────────────────────
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfacePrimary.withValues(alpha: 0.98),
                  border: Border(
                    top: BorderSide(color: colors.borderSubtle, width: 1),
                  ),
                ),
              ),
            ),
          ),

          // ── Tab row ───────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isActive = currentIndex == index;
                return Expanded(
                  child: _NavItem(
                    tab: tab,
                    isActive: isActive,
                    appColors: colors,
                    textTheme: textTheme,
                    onTap: () => onDestinationSelected(index),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavItem — single tab button
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.appColors,
    required this.textTheme,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final AppColors appColors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = appColors.primary;
    final inactiveColor = appColors.foregroundQuaternary;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? tab.activeIcon : tab.icon,
              key: ValueKey(isActive),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 3),
          // Animated dot indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isActive ? 18 : 0,
            height: isActive ? 3 : 0,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: (isActive
                    ? textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w700)
                    : textTheme.labelSmall!)
                .copyWith(color: color),
            child: Text(tab.label),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────────────────────────────────────

class _NavTab {
  const _NavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

