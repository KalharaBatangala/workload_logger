import 'package:flutter/material.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../data/db/app_database.dart';

/// Other work in History (SPEC §8.6): dashed "Other" badge and plain hours
/// without "+", because it is not part of the workload model.
class OtherWorkTile extends StatelessWidget {
  const OtherWorkTile({
    super.key,
    required this.work,
    required this.category,
    this.onTap,
  });

  final OtherWorkRow work;
  final String category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final note = work.note;
    final title = note == null || note.isEmpty
        ? category
        : '$category · ${note[0].toLowerCase()}${note.substring(1)}';
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          child: Row(
            children: [
              const ModuleBadge('Other', style: ModuleBadgeStyle.dashed),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatMinutes(work.spentMinutes)} spent · '
                      'not in the workload model',
                      style: AppText.captionSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                formatMinutes(work.spentMinutes),
                style: AppText.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
