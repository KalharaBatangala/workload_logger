import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/db/app_database.dart';

/// "3 of your role rows are still at zero" (SPEC §8.1) → Summary.
class ZeroRowsNudge extends StatelessWidget {
  const ZeroRowsNudge({super.key, required this.rows, required this.onTap});

  final List<RoleRow> rows;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = rows.length;
    final title = count == 1
        ? '1 of your role rows is still at zero'
        : '$count of your role rows are still at zero';
    final list = rows
        .map((r) => '${r.moduleCode} ${r.role.workbookLabel} · ${r.batch}')
        .join(', ');
    return AppCard(
      onTap: onTap,
      color: AppColors.goldTint,
      borderColor: AppColors.goldBorder,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldTextDeep,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  list,
                  style: AppText.captionSmall.copyWith(
                    color: AppColors.goldTextDeep,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.goldTextDeep,
          ),
        ],
      ),
    );
  }
}
