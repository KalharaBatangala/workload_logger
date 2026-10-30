import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/period_report.dart';
import '../../../data/providers.dart';
import '../../../domain/dates.dart';
import '../providers.dart';

/// Which period Summary shows: the current academic year, a closed period,
/// or a custom range. Semesters come once their dates are known (SPEC §14).
Future<void> showPeriodSheet(BuildContext context, WidgetRef ref) async {
  final current = await ref.read(currentYearPeriodProvider.future);
  final closed = ref.read(closedPeriodsProvider).value ?? const [];
  final selected = ref.read(selectedPeriodProvider);
  if (!context.mounted) return;

  final choice = await showModalBottomSheet<Object>(
    context: context,
    // Above the bottom bar, not inside the tab.
    useRootNavigator: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Text('Show which period?', style: AppText.cardTitle),
          ),
          const SizedBox(height: AppSpacing.s),
          ListTile(
            title: Text(current.label),
            subtitle: const Text('This academic year'),
            trailing: selected == null ? const Icon(Icons.check_rounded) : null,
            onTap: () => Navigator.pop(context, 'current'),
          ),
          for (final period in closed)
            ListTile(
              title: Text(period.label),
              subtitle: Text(
                'Closed · ${formatShortDate(period.from!)} – '
                '${formatShortDate(period.to!)}',
              ),
              trailing: selected == period
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(context, period),
            ),
          ListTile(
            leading: const Icon(Icons.date_range_outlined),
            title: const Text('Custom range…'),
            onTap: () => Navigator.pop(context, 'custom'),
          ),
        ],
      ),
    ),
  );

  final notifier = ref.read(selectedPeriodProvider.notifier);
  switch (choice) {
    case 'current':
      notifier.select(null);
    case final ReportPeriod period:
      notifier.select(period);
    case 'custom':
      if (!context.mounted) return;
      final today = parseIsoDate(ref.read(todayProvider));
      final range = await showDateRangePicker(
        context: context,
        // Above the bottom bar, not inside the tab.
        useRootNavigator: true,
        firstDate: DateTime(today.year - 3),
        lastDate: today,
      );
      if (range == null) return;
      final from = isoDate(range.start);
      final to = isoDate(range.end);
      notifier.select(
        ReportPeriod(
          label: '${formatShortDate(from)} – ${formatShortDate(to)}',
          from: from,
          to: to,
        ),
      );
  }
}
