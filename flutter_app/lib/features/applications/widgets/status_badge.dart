import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/application.dart';

extension ApplicationStatusColors on ApplicationStatus {
  Color foreground(AppColors c) => switch (this) {
        ApplicationStatus.saved => c.statusSaved,
        ApplicationStatus.applied => c.statusApplied,
        ApplicationStatus.assessment => c.statusAssessment,
        ApplicationStatus.hr => c.statusHr,
        ApplicationStatus.technical => c.statusTechnical,
        ApplicationStatus.finalRound => c.statusFinal,
        ApplicationStatus.offer => c.statusOffer,
        ApplicationStatus.rejected => c.statusRejected,
      };

  Color background(AppColors c) => switch (this) {
        ApplicationStatus.saved => c.statusSavedBg,
        ApplicationStatus.applied => c.statusAppliedBg,
        ApplicationStatus.assessment => c.statusAssessmentBg,
        ApplicationStatus.hr => c.statusHrBg,
        ApplicationStatus.technical => c.statusTechnicalBg,
        ApplicationStatus.finalRound => c.statusFinalBg,
        ApplicationStatus.offer => c.statusOfferBg,
        ApplicationStatus.rejected => c.statusRejectedBg,
      };
}

class ApplicationStatusBadge extends StatelessWidget {
  const ApplicationStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final ApplicationStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final fg = status.foreground(colors);
    final bg = status.background(colors);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(status.icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: AppTextStyles.micro
                .copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
