import re

file_path = r'f:\Resume Pilot app\flutter_app\lib\core\auth\auth_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("import '../../features/auth/models/login_request.dart';\n", '')
text = text.replace("import '../../features/auth/models/signup_request.dart';\n", '')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Removed old unused request imports.')
