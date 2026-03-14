import re
import os

files_to_fix = [
    r'F:\Resume Pilot app\flutter_app\lib\features\resume\screens\resume_versions_screen.dart',
    r'F:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart'
]

template_start = """    return Scaffold(
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
            ),
            SafeArea("""

for file_path in files_to_fix:
    if not os.path.exists(file_path):
        continue
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'breathing_background.dart' not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../../shared/widgets/backgrounds/breathing_background.dart';\nimport 'dart:ui';\nimport '../../../core/theme/app_gradients.dart';")

    pattern = r"    return Scaffold\(\s*backgroundColor:\s*colors\.surfacePrimary,\s*body:\s*SafeArea\("
    content = re.sub(pattern, template_start, content)

    end_pattern = r"            \),\n          \],\n        \),\n      \),\n    \);\n  \}"
    end_replace = """            ),
          ],
        ),
      ),
        ],
      )),
    );
  }"""
    
    content = re.sub(end_pattern, end_replace, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
print('Updated list screens.')
