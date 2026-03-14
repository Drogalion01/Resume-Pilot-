import re
import os

file_path = r'F:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix DecoratedBox manually:
old1 = """        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            border: Border.all(color: colors.borderSubtle),
          ),"""
new1 = """        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfacePrimary.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              ),"""

content = content.replace(old1, new1)

# Now we have missing close parenthesis for ClipRRect and BackdropFilter!
# Let's just fix it by replacing the matching block ends where they appear.
# In ProfileSummaryCard:
#             ],
#            ),
#          ),
#        );
#      }

old_end1 = """            ],
          ),
        ),
      );"""

new_end1 = """            ],
          ),
        ),
        ),
        ),
      );"""
content = content.replace(old_end1, new_end1, 1)

# In SettingsSectionCard:

old2 = """  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
          border: Border.all(color: colors.borderSubtle),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: child,
        ),
      );"""

new2 = """  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfacePrimary.withOpacity(0.55),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: child,
            ),
          ),
        ),
      );"""
content = content.replace(old2, new2)

old3 = """        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
        ),"""

new3 = """        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                color: colors.surfacePrimary.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              ),
            ),
          ),
        ),"""
content = content.replace(old3, new3)

old4 = """              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: colors.surfacePrimary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.borderSubtle),
                ),
              ),"""

new4 = """              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: colors.surfacePrimary.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                    ),
                  ),
                ),
              ),"""
content = content.replace(old4, new4)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Updated settings glass')
