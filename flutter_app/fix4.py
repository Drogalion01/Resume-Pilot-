with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("Server returned: ')),", "Server returned: ${response.statusCode}')),")
content = content.replace("Text('Error: ')),", "Text('Error: $e')),")

with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done")
