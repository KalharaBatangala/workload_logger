import 'package:flutter/material.dart';

import '../format.dart';
import '../theme/tokens.dart';

/// The live credit strip (SPEC §8.4): how the credit is worked out on the
/// left ("10 × 6 min credited"), the credit on the right ("1.0 h").
class CreditStrip extends StatelessWidget {
  const CreditStrip({
    super.key,
    required this.explanation,
    required this.hours,
  });

  final String explanation;
  final double hours;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: '$explanation. ${formatHours(hours)}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.goldSoft,
          borderRadius: BorderRadius.circular(AppRadii.buttonSmall),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                explanation,
                style: AppText.caption.copyWith(color: AppColors.goldTextDeep),
              ),
            ),
            Text(
              formatHours(hours),
              style: AppText.cardTitle.copyWith(
                color: AppColors.goldTextDeep,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "+1.0 h" in gold text, for credits on white (SPEC §8.1).
class CreditText extends StatelessWidget {
  const CreditText(this.hours, {super.key, this.style});

  final double hours;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatCredit(hours),
      style: (style ?? AppText.body).copyWith(
        color: AppColors.goldText,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
