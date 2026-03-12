import re

file_path = r'lib\features\settings\screens\settings_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace(
    'profile.fullName,',
    "profile.fullName ?? 'User',"
)

text = text.replace(
    'profile.email,',
    "profile.email ?? profile.phone ?? '',"
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)

print('Fixed settings screen')
