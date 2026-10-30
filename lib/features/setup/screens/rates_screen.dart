import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../data/providers.dart';
import '../../../domain/rates.dart';

/// The rates in use, from Admin_Config (read-only, SPEC §8.8).
class RatesScreen extends ConsumerWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(currentRatesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rates')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text(
            'Hours credited per unit, as read from the workbook\'s '
            'Admin_Config sheet. To change them, load a newer workbook.',
            style: AppText.bodySmall,
          ),
          const SizedBox(height: AppSpacing.l),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, key) in RateKey.values.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: AppSpacing.m,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(key.label, style: AppText.bodySmall),
                        ),
                        if (key.isInAdminConfig && rates.isDefault(key)) ...[
                          const StatusPill('default'),
                          const SizedBox(width: AppSpacing.s),
                        ],
                        Text(
                          formatRate(rates.hours(key)),
                          style: AppText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
