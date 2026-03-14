import re

files = [
    'lib/features/applications/widgets/application_states.dart',
    'lib/features/resume/widgets/resume_states.dart',
    'lib/shared/widgets/loading_skeletons.dart'
]

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove inal colors = Theme.of(context).colorScheme; completely
    content = re.sub(r'^\s*final colors = Theme\.of\(context\)\.colorScheme;\n', '', content, flags=re.MULTILINE)

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)

# For settings_screen.dart, remove const _bdappsPhpBaseUrl = ...;
with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()
    content = re.sub(r'\nconst _bdappsPhpBaseUrl =[^;]+;\n', '\n', content)
with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('Done fixing warnings')
