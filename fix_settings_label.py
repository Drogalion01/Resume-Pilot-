with open(r'f:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

start = c.index('class _SectionLabel extends StatelessWidget {')
end = c.index('\nclass _TileLabel extends StatelessWidget {')

new_section_label = '''class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colors});
  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.overline.copyWith(
                color: colors.foregroundTertiary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      );
}
'''

result = c[:start] + new_section_label + c[end:]

with open(r'f:\Resume Pilot app\flutter_app\lib\features\settings\screens\settings_screen.dart', 'w', encoding='utf-8') as f:
    f.write(result)

print('SUCCESS: _SectionLabel updated with accent bar')
