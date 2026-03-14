import re

file = 'lib/features/settings/screens/settings_screen.dart'
with open(file, 'r', encoding='utf-8') as f:
    content = f.read()

# Remove unused baseUrl
content = re.sub(r'const _bdappsPhpBaseUrl =[^;]+;\n', '', content)
# Fix deprecated withOpacity to withValues
content = re.sub(r'\.withOpacity\((.*?)\)', r'.withValues(alpha: \1)', content)

with open(file, 'w', encoding='utf-8') as f:
    f.write(content)
