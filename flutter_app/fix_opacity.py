import re

files_to_fix_opacity = [
    'lib/features/settings/screens/settings_screen.dart',
    'lib/shared/widgets/backgrounds/breathing_background.dart',
    'lib/shared/widgets/buttons/animated_scale_button.dart',
    'lib/shared/widgets/charts/smooth_wave_chart.dart'
]

for file in files_to_fix_opacity:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace .withOpacity(val) with .withValues(alpha: val)
    content = re.sub(r'\.withOpacity\((.*?)\)', r'.withValues(alpha: \1)', content)

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)

print('Done fixing withOpacity')
