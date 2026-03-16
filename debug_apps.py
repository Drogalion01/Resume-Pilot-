with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

# Find the ApplicationsTrackerScreen class section
class_start = c.index('class ApplicationsTrackerScreen extends ConsumerWidget {')
comment_start = c.index('\n// ── Status filter row')

# Extract just the screen class
screen_section = c[class_start:comment_start]
print(repr(screen_section[-300:]))
print('--- LAST 300 CHARS ---')
