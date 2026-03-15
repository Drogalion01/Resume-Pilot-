with open('f:/Resume Pilot app/flutter_app/lib/features/dashboard/widgets/dashboard_states.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('return Container(color: const Color(0xFFFF0000), child: Center(', 'return Center(')
# There are 3 replacements. We need to do this, then wait, the original was:
# return Center(...)
# so we replaced it with 'return Container(..., child: Center('
# And at the end of the block there was a ');' but we didn't add the trailing ')' when replacing!
# Wait, replacing it with `return Center(` will perfectly undo the damage, because the trailing `);` doesn't need to change!

with open('f:/Resume Pilot app/flutter_app/lib/features/dashboard/widgets/dashboard_states.dart', 'w', encoding='utf-8') as f:
    f.write(text)
