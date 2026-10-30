import 'package:flutter/material.dart';

import '../format.dart';
import '../theme/tokens.dart';

/// A category with a horizontal bar (SPEC §8.7). [fraction] is relative to
/// the largest category; [highlighted] uses the gold bar.
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.label,
    required this.hours,
    required this.fraction,
    this.highlighted = false,
  });

  final String label;
  final double hours;
  final double fraction;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label, ${formatHours(hours)}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppText.bodySmall)),
              Text(
                formatHours(hours),
                style: AppText.bodySmall.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0, 1).toDouble(),
              minHeight: 8,
              backgroundColor: AppColors.track,
              color: highlighted ? AppColors.gold : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
