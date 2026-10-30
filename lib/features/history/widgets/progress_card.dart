import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../history_items.dart';

/// Marking done in batches (SPEC §8.6): "EC3202 end-exam marking · 19.3 h",
/// a bar towards the module's students, "193 of 193 papers · logged in 4
/// batches".
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.progress});

  final MarkingProgress progress;

  @override
  Widget build(BuildContext context) {
    final target = progress.target;
    final total = formatCount(progress.total);
    final batches = progress.batches == 1
        ? 'logged in 1 batch'
        : 'logged in ${progress.batches} batches';
    final count = target == null
        ? '$total ${progress.unit}'
        : '$total of $target ${progress.unit}';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  progress.title,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                formatHours(progress.hours),
                style: AppText.body.copyWith(
                  color: AppColors.goldText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (target != null) ...[
            const SizedBox(height: AppSpacing.s),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (progress.total / target).clamp(0, 1).toDouble(),
                minHeight: 8,
                backgroundColor: AppColors.track,
                color: AppColors.navy,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s),
          Text('$count · $batches', style: AppText.captionSmall),
        ],
      ),
    );
  }
}
