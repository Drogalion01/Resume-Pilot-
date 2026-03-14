import os

def fix_unused(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    with open(filename, 'w', encoding='utf-8') as f:
        for line in lines:
            if 'final colors = Theme.of(context).colorScheme;' in line:
                continue
            if 'const _bdappsPhpBaseUrl =' in line:
                continue
            f.write(line)

fix_unused('lib/features/applications/widgets/application_states.dart')
fix_unused('lib/features/resume/widgets/resume_states.dart')
fix_unused('lib/shared/widgets/loading_skeletons.dart')
fix_unused('lib/features/settings/screens/settings_screen.dart')

