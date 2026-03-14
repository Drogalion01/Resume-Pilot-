import re

with open('lib/features/dashboard/screens/dashboard_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace body Stack definition with BreathingBackground wrapped Stack
pattern_body = r"return\s+Scaffold\(\s+backgroundColor:.*?,?\s+body:\s+Stack\("
new_body = """return Scaffold(
      backgroundColor: Colors.transparent,
      body: BreathingBackground(
        child: Stack("""

content = re.sub(pattern_body, new_body, content)

# Check if it was applied
if "BreathingBackground(\n        child: Stack(" in content:
    # Now we just need to add the closing parenthesis for BreathingBackground
    # The end of the build method looks like:
    #           ],
    #         ),
    #       );
    #     }
    pattern_close = r"          \],\n        \),\n      \);\n    \}"
    new_close = """          ],
        ),
      ),
    );
  }"""
    content = re.sub(pattern_close, new_close, content)

with open('lib/features/dashboard/screens/dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated dashboard_screen")
