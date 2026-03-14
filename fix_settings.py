import re
import os

file_path = r'F:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add BreathingBackground
if 'breathing_background.dart' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../shared/widgets/backgrounds/breathing_background.dart';\nimport 'dart:ui';")

old_scaffold = r"    return Scaffold\(\s*backgroundColor: colors\.background,\s*body: Stack\(\s*children: \[\s*//.*?\n\s*Positioned\.fill\(\s*child: DecoratedBox\(\s*decoration: BoxDecoration\(\s*gradient: AppGradients\.heroBackground\(colors\),\s*\),\s*\),\s*\),"
    
new_scaffold = """    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BreathingBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.heroBackground(colors),
                ),
              ),
            ),
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
            ),"""

content = re.sub(old_scaffold, new_scaffold, content)

end_pattern = r"        \],\n      \),\n    \);\n  \}"
end_replace = """        ],
      )),
    );
  }"""
content = re.sub(end_pattern, end_replace, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Updated settings screen.')