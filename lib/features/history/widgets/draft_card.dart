import 'package:flutter/material.dart';

import '../../../core/activity_labels.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/db/app_database.dart';
import '../../../domain/activity_catalogue.dart';

/// A draft waiting to be finished (SPEC §8.6): what is missing, what it is,
/// and Finish entry / Discard.
class DraftCard extends StatelessWidget {
  const DraftCard({
    super.key,
    required this.draft,
    required this.code,
    required this.onFinish,
    required this.onDiscard,
  });

  final EntryRow draft;
  final String? code;
  final VoidCallback onFinish;
  final VoidCallback onDiscard;

  String get _missing {
    final count = draft.count;
    if (count == null || count <= 0) return 'Needs a count';
    if (needsQuestionsPerPaper(draft.activity, draft.subtype) &&
        draft.questionsPerPaper == null) {
      return 'Needs questions per paper';
    }
    return 'Needs details';
  }

  @override
  Widget build(BuildContext context) {
    final kind = countKindFor(draft.activity, draft.subtype);
    final what = kind == null
        ? ActivityLabels.title(draft.activity)
        : ActivityLabels.countLabel(kind);
    final source = draft.rawText != null
        ? 'From your quick note: "${draft.rawText}"'
        : ActivityLabels.title(draft.activity);
    return AppCard(
      color: AppColors.goldSoft,
      borderColor: AppColors.goldBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DRAFT · ${_missing.toUpperCase()}',
            style: AppText.overline.copyWith(color: AppColors.goldTextDeep),
          ),
          const SizedBox(height: AppSpacing.s),
          Text([?code, what].join(' · '), style: AppText.cardTitle),
          const SizedBox(height: 2),
          Text(
            source,
            style: AppText.bodySmall.copyWith(color: AppColors.goldTextDeep),
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: FilledButton(
                  onPressed: onFinish,
                  child: const Text('Finish entry'),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: onDiscard,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.goldTint,
                    side: const BorderSide(color: AppColors.goldBorder),
                  ),
                  child: const Text('Discard'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
