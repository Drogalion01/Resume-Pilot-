import sys

with open(r'F:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart', 'r', encoding='utf-8') as f:
    orig = f.read()

# ADD IMPORTS
if 'breathing_background.dart' not in orig:
    orig = orig.replace("import 'package:flutter/material.dart';",
        "import 'package:flutter/material.dart';\n"
        "import '../../../shared/widgets/backgrounds/breathing_background.dart';\n"
        "import 'dart:ui';")

lines = orig.split('\n')
out_lines = []

in_scaffold_bg = False
scaffold_bg_done = False

in_scaffold_end = False
scaffold_end_done = False

in_profile_dec = False
profile_dec_done = False
profile_dec_brace_count = 0

in_card_dec = False
card_dec_done = False

for i, line in enumerate(lines):
    # Detect the scaffold background
    if not scaffold_bg_done and 'return Scaffold(' in line:
        # replace until SafeArea(
        pass

    out_lines.append(line)

# Let me use simple string splitting around safe area:
"