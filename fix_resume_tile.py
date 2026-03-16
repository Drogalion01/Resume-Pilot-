with open(r'f:\Resume Pilot app\flutter_app\lib\features\resume\screens\resume_versions_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

start = c.index('class _ResumeTile extends StatelessWidget {')
end = c.index('\nclass _Badge extends StatelessWidget {')

new_tile = '''class _ResumeTile extends StatelessWidget {
  const _ResumeTile({required this.resume});

  final ResumeResponse resume;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel =
        DateFormat('MMM d, yyyy').format(resume.createdAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.primaryLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Material(
          color: Colors.transparent,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.primary, colors.primaryHover],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        context.push(AppRoutes.resumeDetail(resume.id)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.primaryMuted,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.description_outlined,
                                color: colors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  resume.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colors.foreground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  dateLabel,
                                  style: AppTextStyles.caption.copyWith(
                                    color: colors.foregroundSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _Badge(label: resume.fileTypeLabel, colors: colors),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded,
                              color: colors.foregroundSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
'''

result = c[:start] + new_tile + c[end:]

with open(r'f:\Resume Pilot app\flutter_app\lib\features\resume\screens\resume_versions_screen.dart', 'w', encoding='utf-8') as f:
    f.write(result)

print('SUCCESS: Resume tile updated')
