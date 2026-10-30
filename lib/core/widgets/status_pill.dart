import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A small pill such as the gold "Nothing yet" (SPEC §8.7) or a muted
/// "Nothing logged yet" chip.
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.gold = true});

  final String label;

  /// Gold-soft (attention) or pale (neutral).
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: gold ? AppColors.goldSoft : AppColors.chip,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: gold ? Border.all(color: AppColors.goldBorder) : null,
      ),
      child: Text(
        label,
        style: AppText.captionSmall.copyWith(
          color: gold ? AppColors.goldTextDeep : AppColors.textBody,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
