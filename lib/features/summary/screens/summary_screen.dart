import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/category_bar.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/module_badge.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../data/period_report.dart';
import '../../../data/providers.dart';
import '../providers.dart';
import '../widgets/close_period_sheet.dart';
import '../widgets/period_sheet.dart';

/// Summary (SPEC §8.7): the period's credit by category and role row, and
/// the export.
class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  bool _exporting = false;

  Future<void> _export({required bool evidenceOnly}) async {
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(exportServiceProvider);
    final period = await ref.read(activePeriodProvider.future);
    if (!mounted) return;
    setState(() => _exporting = true);
    try {
      evidenceOnly
          ? await service.exportEvidence(period)
          : await service.exportWorkload(period);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('The export could not be created.')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(activePeriodProvider).value;
    final isCurrentYear = ref.watch(isCurrentYearProvider);
    final view = ref.watch(summaryViewProvider).value;

    return TabPage(
      title: 'Summary',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PeriodChip(
            label: period?.label ?? '…',
            onTap: () => showPeriodSheet(context, ref),
          ),
          if (isCurrentYear)
            PopupMenuButton<String>(
              tooltip: 'More',
              onSelected: (_) => showClosePeriodSheet(context, ref),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'close', child: Text('Close this period')),
              ],
            ),
        ],
      ),
      children: [
        if (view != null && period != null) ...[
          HeroCard(
            overline: isCurrentYear
                ? 'Credited this academic year'
                : 'Credited · ${period.label}',
            value: view.total.total.toStringAsFixed(1),
            unit: 'hours',
            footnote: view.otherWorkMinutes == 0
                ? null
                : 'Plus ${formatMinutes(view.otherWorkMinutes)} of other '
                      'work, kept outside the model',
          ),
          const SizedBox(height: AppSpacing.section),
          _CategoriesCard(view: view),
          const SizedBox(height: AppSpacing.section),
          const Text('Your role rows', style: AppText.section),
          const SizedBox(height: AppSpacing.m),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, line) in view.lines.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _RoleRowLineTile(
                    line: line,
                    onTap: () =>
                        context.push(AppRoutes.summaryRow(line.report.row.id)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _exporting ? null : () => _export(evidenceOnly: false),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Export my Data_Entry rows (.xlsx)'),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: _exporting ? null : () => _export(evidenceOnly: true),
              child: const Text('Export evidence log (every entry)'),
            ),
          ),
        ] else
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: 'Period: $label. Change',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(Icons.expand_more_rounded, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoriesCard extends StatelessWidget {
  const _CategoriesCard({required this.view});

  final SummaryView view;

  @override
  Widget build(BuildContext context) {
    final bars = view.barCategories;
    final largest = bars.isEmpty ? 1.0 : view.total[bars.first];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('By category', style: AppText.section),
          const SizedBox(height: AppSpacing.m),
          for (final category in bars) ...[
            CategoryBar(
              label: category.label,
              hours: view.total[category],
              fraction: view.total[category] / largest,
              highlighted: category == view.latestCategory,
            ),
            const SizedBox(height: AppSpacing.m),
          ],
          if (view.zeroCategories.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: AppSpacing.s),
            const Text('Nothing logged yet', style: AppText.captionSmall),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final category in view.zeroCategories)
                  StatusPill(category.label, gold: false),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RoleRowLineTile extends StatelessWidget {
  const _RoleRowLineTile({required this.line, required this.onTap});

  final RoleRowLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final RoleRowReport report = line.report;
    final role = report.row.role.workbookLabel;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.s,
          ),
          child: Row(
            children: [
              ModuleBadge(report.row.moduleCode),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  line.showBatch ? '$role · ${report.row.batch}' : role,
                  style: AppText.bodySmall,
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              // Scales down rather than overflows with large system text.
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: line.nothingYet
                      ? const StatusPill('Nothing yet')
                      : Text(
                          formatHours(line.hours),
                          style: AppText.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
