import os
import re

file_path = r'F:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Imports
if 'breathing_background.dart' not in text:
    text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../shared/widgets/backgrounds/breathing_background.dart';\nimport 'dart:ui';")

# 2. Main Scaffold background
text = re.sub(
    r'    return Scaffold\([\s\S]*?SafeArea\(',
    '''    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BreathingBackground(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: -60,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow1(colors),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: -40,
              child: IgnorePointer(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.heroGlow2(colors),
                  ),
                ),
              ),
            ),

          SafeArea(''',
    text, count=1
)

text = re.sub(
    r'(\s*)const SliverToBoxAdapter\(\s*child: SizedBox\(height: AppSpacing\.px48\),\s*\),\s*],\s*\),\s*\),\s*],\s*\),\s*\);',
    r'\g<1>const SliverToBoxAdapter(\n\g<1>  child: SizedBox(height: AppSpacing.px48),\n\g<1>),\n\g<1>              ],\n\g<1>            ),\n\g<1>          ),\n\g<1>        ],\n\g<1>      ),\n\g<1>      ),\n\g<1>    );',
    text
)

text = re.sub(
    r'(\s*)child: DecoratedBox\(\s*decoration: BoxDecoration\(\s*color: colors\.surfacePrimary,\s*borderRadius: BorderRadius\.circular\(16\),\s*boxShadow: isDark \? AppShadows\.cardDark : AppShadows\.cardLight,\s*border: Border\.all\(color: colors\.borderSubtle\),\s*\),\s*child: Padding\(',
    '''\g<1>child: Container(
\g<1>  decoration: BoxDecoration(
\g<1>    color: colors.surfacePrimary.withOpacity(0.55),
\g<1>    borderRadius: BorderRadius.circular(16),
\g<1>    boxShadow: [
\g<1>      BoxShadow(
\g<1>        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
\g<1>        blurRadius: 16,
\g<1>        spreadRadius: -4,
\g<1>      )
\g<1>    ],
\g<1>    border: Border.all(
\g<1>      color: Colors.white.withOpacity(isDark ? 0.05 : 0.2),
\g<1>    ),
\g<1>  ),
\g<1>  child: ClipRRect(
\g<1>    borderRadius: BorderRadius.circular(16),
\g<1>    child: BackdropFilter(
\g<1>      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
\g<1>      child: Padding(''',
    text, count=1
)

# And to fix the card ending
text = re.sub(
    r'(\s*)\],\s*\),\s*\),\s*\);\s*}\s*(?:// ─)',
    r'\g<1>],\n\g<1>),\n\g<1>),\n\g<1>),\n\g<1>),\n\g<1>);\n  }\n\n// ─',
    text, count=1
)

text = re.sub(
    r'Widget build\(BuildContext context\) => DecoratedBox\(\s*decoration: BoxDecoration\(\s*color: colors\.surfacePrimary,\s*borderRadius: BorderRadius\.circular\(16\),\s*boxShadow: isDark \? AppShadows\.cardDark : AppShadows\.cardLight,\s*border: Border\.all\(color: colors\.borderSubtle\),\s*\),\s*child: ClipRRect\(\s*borderRadius: BorderRadius\.circular\(16\),\s*child: child,\s*\),\s*\);',
    '''Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: colors.surfacePrimary.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: -4,
            )
          ] : AppShadows.cardLight,
          border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: child,
          ),
        ),
      );''',
    text
)

text = text.replace("color: colors.surfacePrimary,", "color: colors.surfacePrimary.withOpacity(0.55),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Execution finished')
