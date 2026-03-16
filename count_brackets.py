with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

# Find ApplicationsTrackerScreen section
class_start = c.index('class ApplicationsTrackerScreen extends ConsumerWidget {')
comment_start = c.index('\n// ── Status filter row')
screen = c[class_start:comment_start]

# Count brackets
opens_p = screen.count('(')
closes_p = screen.count(')')
opens_b = screen.count('[')
closes_b = screen.count(']')
opens_c = screen.count('{')
closes_c = screen.count('}')

print(f"(: {opens_p}, ): {closes_p}, diff: {opens_p - closes_p}")
print(f"[: {opens_b}, ]: {closes_b}, diff: {opens_b - closes_b}")
print(f"{{: {opens_c}, }}: {closes_c}, diff: {opens_c - closes_c}")
