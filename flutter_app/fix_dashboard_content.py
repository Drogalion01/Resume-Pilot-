import re

with open('lib/features/dashboard/widgets/dashboard_content_widgets.dart', 'r', encoding='utf-8') as f:
    content = f.read()

imports = """import '../../../shared/widgets/animations/animated_counter_text.dart';
import '../../../shared/widgets/cards/glass_card.dart';
import '../../../shared/widgets/buttons/animated_scale_button.dart';
"""
content = re.sub(r"(import '../models/dashboard_response.dart';)", r"\1\n" + imports, content)

# Replace insight card background with GlassCard
old_insight_card = """    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withOpacity(0.2)),
      ),"""

new_insight_card = """    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageH,
        vertical: 8,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),"""
content = content.replace(old_insight_card, new_insight_card)

# Close the new container structure correctly
old_in_close = """        ],
      ),
    );
  }
}"""
# Need a specific replace for the end of InsightCard
insight_card_end = """        ],
      ),
    );
  }
}

// ----------"""
if insight_card_end not in content:
    # Try finding the class instead
    pass


# Let's use a simpler pattern specifically for replacing the Text with AnimatedCounterText
old_text = "Text(\n              '$value',\n              style: AppTextStyles.title.copyWith(color: colors.foreground),\n            ),"
new_text = "AnimatedCounterText(\n              targetValue: value.toDouble(),\n              textStyle: AppTextStyles.title.copyWith(color: colors.foreground),\n            ),"
content = content.replace(old_text, new_text)
# fallback if exactly matching failed
content = re.sub(
    r"Text\(\s*'\$value',\s*style:\s*AppTextStyles\.title\.copyWith\(color:\s*colors\.foreground\),\s*\),",
    r"AnimatedCounterText(\n              targetValue: value.toDouble(),\n              textStyle: AppTextStyles.title.copyWith(color: colors.foreground),\n            ),",
    content
)

with open('lib/features/dashboard/widgets/dashboard_content_widgets.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated dashboard_content_widgets.dart")
