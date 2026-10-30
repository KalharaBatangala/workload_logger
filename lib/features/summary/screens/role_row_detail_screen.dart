import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../domain/enums.dart';
import '../../../domain/workbook_mapping.dart';
import '../providers.dart';

/// One role row as the workbook will receive it: inputs I–AI and hours
/// AJ–AU for the selected period (SPEC §8.7).
class RoleRowDetailScreen extends ConsumerWidget {
  const RoleRowDetailScreen({super.key, required this.roleRowId});

  final int roleRowId;

  /// Whole numbers plainly; fractions (a weighted Qs/paper) to 3 decimals.
  static String _value(double v) =>
      v == v.roundToDouble() ? formatCount(v) : v.toStringAsFixed(3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(periodReportProvider).value;
    final period = ref.watch(activePeriodProvider).value;
    final report = reports?.where((r) => r.row.id == roleRowId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Role row')),
      body: report == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                Row(
                  children: [
                    ModuleBadge(
                      report.row.moduleCode,
                      style: ModuleBadgeStyle.navy,
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        report.row.moduleName,
                        style: AppText.cardTitle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${report.row.role.workbookLabel} · ${report.row.batch} · '
                  '${report.row.moduleType.workbookLabel}'
                  '${report.row.sheetRow == null ? '' : ' · workbook row ${report.row.sheetRow}'}',
                  style: AppText.caption,
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionLabel(
                  'What the workbook receives · ${period?.label ?? ''}',
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: report.inputs.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(AppSpacing.l),
                          child: Text(
                            'All inputs are 0 for this period.',
                            style: AppText.caption,
                          ),
                        )
                      : Column(
                          children: [
                            for (final column in InputColumn.values)
                              if (report.inputs[column] != 0)
                                _Line(
                                  letter: column.letter,
                                  label: column.meaning,
                                  value: _value(report.inputs[column]),
                                ),
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionLabel('Hours'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final category in Category.values)
                        if (report.hours[category] != 0)
                          _Line(
                            letter: category.hoursColumn,
                            label: category.label,
                            value: formatHours(report.hours[category]),
                          ),
                      _Line(
                        letter: Category.totalColumn,
                        label: 'Total',
                        value: formatHours(report.hours.total),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.letter,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String letter;
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        children: [
          SizedBox(width: 32, child: Text(letter, style: AppText.badge)),
          Expanded(child: Text(label, style: AppText.bodySmall)),
          const SizedBox(width: AppSpacing.s),
          Text(
            value,
            style: AppText.body.copyWith(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
