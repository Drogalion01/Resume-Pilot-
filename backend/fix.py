import re

file_path = r'f:\Resume Pilot app\flutter_app\lib\features\profile\screens\user_profile_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('email: profile.email,', "email: profile.email ?? profile.phone ?? '',")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed profile screen')
