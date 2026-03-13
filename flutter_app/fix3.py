with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("String finalSubId = 'tel:';", "String finalSubId = 'tel:$phone';")
content = content.replace("? phone : '8801';", "? phone : '8801$phone';")
content = content.replace("Server returned: {response.statusCode}", "Server returned: ${response.statusCode}")
content = content.replace("Error: e", "Error: $e")

with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done")
