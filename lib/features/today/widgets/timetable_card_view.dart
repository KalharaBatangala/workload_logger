import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../providers.dart';

/// "From your timetable" card (SPEC §8.1): Yes · Other hours · No.
class TimetableCardView extends StatelessWidget {
  const TimetableCardView({
    super.key,
    required this.card,
    required this.onYes,
    required this.onOtherHours,
    required this.onNo,
  });

  final TimetableCard card;
  final VoidCallback onYes;

  /// Null for lab slots (they are not logged as lecture hours).
  final VoidCallback? onOtherHours;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    final slot = card.slot;
    final kind = card.isLab ? 'lab' : 'lecture';
    final question = card.isLab
        ? 'Did you conduct it? Kept as other work, outside the model.'
        : 'Did you conduct it?';
    return AppCard(
      color: AppColors.surface,
      borderColor: AppColors.goldBorder,
      borderWidth: 1.5,
      radius: AppRadii.cardLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.goldText,
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                'FROM YOUR TIMETABLE',
                style: AppText.overline.copyWith(color: AppColors.goldText),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            '${card.row.moduleCode} $kind, ${slot.startTime} – ${slot.endTime}',
            style: AppText.cardTitle,
          ),
          const SizedBox(height: 2),
          Text('${card.row.moduleName} · $question', style: AppText.bodySmall),
          const SizedBox(height: AppSpacing.l),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onYes,
                  child: Text('Yes, ${formatCount(card.hours)} h'),
                ),
              ),
              if (onOtherHours != null) ...[
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOtherHours,
                    child: const Text('Other hours'),
                  ),
                ),
              ],
              const SizedBox(width: AppSpacing.s),
              TextButton(onPressed: onNo, child: const Text('No')),
            ],
          ),
        ],
      ),
    );
  }
}
