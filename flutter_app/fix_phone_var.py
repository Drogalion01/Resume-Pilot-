with open('lib/features/settings/screens/settings_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the  templating that got lost
content = content.replace("String finalSubId = 'tel:';", "String finalSubId = 'tel:\';")
content = content.replace("? phone : '8801';", "? phone : '8801\';")

with open('lib/features/settings/screens/settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
