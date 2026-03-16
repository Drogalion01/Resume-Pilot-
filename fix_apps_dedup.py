with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

# Find the start of the duplicated section (second occurrence of _StatusFilterRow)
first_sfr = c.index('class _StatusFilterRow extends StatelessWidget {')
second_sfr = c.index('class _StatusFilterRow extends StatelessWidget {', first_sfr + 1)

# The good content ends just before the second _StatusFilterRow
# Back up to the newline before the comment that precedes it
cut_pos = c.rfind('\n', 0, second_sfr)

c = c[:cut_pos] + '\n'

with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'w', encoding='utf-8') as f:
    f.write(c)

print('SUCCESS: Duplicate removed')
print(f'File now ends with: {repr(c[-200:])}')
