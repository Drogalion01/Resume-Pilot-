import re
file_path = r'lib\features\auth\screens\otp_verification_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("import 'package:go_router/go_router.dart';\n", "")
text = text.replace("import '../../../core/utils/validators.dart';\n", "")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed unused imports')
