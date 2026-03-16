with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'r', encoding='utf-8') as f:
    c = f.read()

# ── 1. Add app_gradients import ────────────────────────────────────
old_import = "import '../../../core/theme/app_spacing.dart';"
new_import = """import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';"""
c = c.replace(old_import, new_import, 1)

# ── 2. Replace Scaffold background + body structure ────────────────
old_scaffold = """    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Column("""

new_scaffold = """    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBackground(colors),
              ),
            ),
          ),
          SafeArea(
            child: Column("""

c = c.replace(old_scaffold, new_scaffold, 1)

# ── 3. Close the extra Stack/SafeArea wrappers we added ────────────
# The Scaffold body currently ends with:  ),\n    );\n  }\n}\n
# after the SafeArea close. We need to close Stack too.
# Find the end of ApplicationsTrackerScreen.build
old_body_end = """          ),
        ],
      ),
    );
  }
}

// ── Status filter row"""

new_body_end = """          ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status filter row"""

c = c.replace(old_body_end, new_body_end, 1)

# ── 4. Replace _ApplicationCard with depth-styled card ────────────
start = c.index('class _ApplicationCard extends StatelessWidget {')
end = c.index('\n// ── Status filter row')

new_app_card = '''// ── Application card ────────────────────────────────────────────────

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app});

  final ApplicationResponse app;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateLabel = app.applicationDate != null
        ? DateFormat('MMM d, yyyy').format(app.applicationDate!)
        : null;
    final accentColor = app.status.foreground(colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: accentColor.withAlpha(45), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(22),
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
                Container(width: 4, color: accentColor),
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        context.push(AppRoutes.applicationDetail(app.id)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.companyName,
                                      style: AppTextStyles.title
                                          .copyWith(color: colors.foreground),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      app.role,
                                      style: AppTextStyles.caption.copyWith(
                                          color: colors.foregroundSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ApplicationStatusBadge(status: app.status),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (app.location != null) ...[
                                Icon(Icons.location_on_outlined,
                                    size: 13,
                                    color: colors.foregroundTertiary),
                                const SizedBox(width: 3),
                                Text(
                                  app.location!,
                                  style: AppTextStyles.micro.copyWith(
                                      color: colors.foregroundTertiary),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (dateLabel != null) ...[
                                Icon(Icons.calendar_today_outlined,
                                    size: 13,
                                    color: colors.foregroundTertiary),
                                const SizedBox(width: 3),
                                Text(
                                  dateLabel,
                                  style: AppTextStyles.micro.copyWith(
                                      color: colors.foregroundTertiary),
                                ),
                              ],
                              const Spacer(),
                              Icon(Icons.chevron_right_rounded,
                                  size: 18,
                                  color: colors.foregroundSecondary),
                            ],
                          ),
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

result = c[:start] + new_app_card + c[end:]

with open(r'f:\Resume Pilot app\flutter_app\lib\features\applications\screens\applications_tracker_screen.dart', 'w', encoding='utf-8') as f:
    f.write(result)

print('SUCCESS: Applications screen updated')
