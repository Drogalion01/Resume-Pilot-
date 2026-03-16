with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

# The screen section ends before the // ── Status filter row comment
# We need to insert '],\n      ),' before the final '    );' that closes Scaffold
# The pattern at the end of ApplicationsTrackerScreen is:
#   '      ),\n    );\n  }\n}\n'  (SafeArea close, Scaffold close, method close, class close)

old_end = '      ),\n    );\n  }\n}\n\n// \u2500\u2500 Status filter row'
new_end = '      ),\n        ],\n      ),\n    );\n  }\n}\n\n// \u2500\u2500 Status filter row'

if old_end in c:
    c = c.replace(old_end, new_end, 1)
    with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'w', encoding='utf-8') as f:
        f.write(c)
    print('SUCCESS: Added missing Stack closing brackets')
else:
    # Try alternate ending (file may have Windows line endings or slight variation)
    import re
    # Print what the end actually looks like
    comment_pos = c.index('// \u2500\u2500 Status filter row')
    print(repr(c[comment_pos-120:comment_pos+10]))
