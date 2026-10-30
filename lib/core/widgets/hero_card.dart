import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A stat under the hero's divider: "4.8 h" / "this week".
typedef HeroStat = ({String value, String label});

/// The navy hero card (SPEC §8.1, §8.7): an overline, a big number with its
/// unit, an optional corner note, and stats under a divider.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.overline,
    required this.value,
    required this.unit,
    this.cornerNote,
    this.footnote,
    this.stats = const [],
  });

  final String overline;
  final String value;
  final String unit;

  /// e.g. "1 entry", top right.
  final String? cornerNote;

  /// A muted line under the number (e.g. other work on Summary).
  final String? footnote;
  final List<HeroStat> stats;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label:
          '$overline: $value $unit. '
          '${stats.map((s) => '${s.value} ${s.label}').join('. ')}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(AppRadii.hero),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    overline.toUpperCase(),
                    style: AppText.overline.copyWith(color: AppColors.cream),
                  ),
                ),
                if (cornerNote != null)
                  Text(
                    cornerNote!,
                    style: AppText.captionSmall.copyWith(
                      color: AppColors.onNavyMuted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            // Shrinks rather than overflows with large system text.
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: AppText.display.copyWith(color: AppColors.surface),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    unit,
                    style: AppText.cardTitle.copyWith(color: AppColors.cream),
                  ),
                ],
              ),
            ),
            if (footnote != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                footnote!,
                style: AppText.captionSmall.copyWith(
                  color: AppColors.onNavyMuted,
                ),
              ),
            ],
            if (stats.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.l),
              const Divider(color: AppColors.onNavyBorder, height: 1),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  for (final stat in stats) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat.value,
                            style: AppText.cardTitle.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            stat.label,
                            style: AppText.captionSmall.copyWith(
                              color: AppColors.onNavyMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
