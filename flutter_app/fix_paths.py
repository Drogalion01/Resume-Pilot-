import os
import re

directory = 'lib'
pattern = re.compile(r"(_dio\.(get|post|put|delete|patch)(?:<.*?>)?\(\s*)(['\"])/(.*?)['\"]")

for root, _, files in os.walk(directory):
    for f in files:
        if f.endswith('.dart'):
            path = os.path.join(root, f)
            with open(path, 'r', encoding='utf-8') as file:
                content = file.read()
            
            new_content = pattern.sub(r"\1\3\4\3", content)
            if new_content != content:
                with open(path, 'w', encoding='utf-8') as file:
                    file.write(new_content)
                print(f"Fixed {path}")
