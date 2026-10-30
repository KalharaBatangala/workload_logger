import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/period_report.dart';
import '../../data/providers.dart';
import '../../data/repositories/entries_repository.dart';
import '../../domain/activity_catalogue.dart';
import '../../domain/credit_calculator.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';

// ---------------------------------------------------------------------------
// Periods

/// The current academic year: everything after the last closed period
/// (decided in M2), labelled with the profile's year ("2025/26").
final currentYearPeriodProvider = FutureProvider.autoDispose<ReportPeriod>((
  ref,
) async {
  final start = await ref.watch(currentYearStartProvider.future);
  final profile = await ref.watch(profileProvider.future);
  return ReportPeriod(
    label: profile?.academicYearLabel ?? 'This year',
    from: start,
  );
});

/// Closed periods, newest first.
final closedPeriodsProvider = StreamProvider.autoDispose<List<ReportPeriod>>(
  (ref) => ref
      .watch(periodsRepositoryProvider)
      .watchAll()
      .map(
        (all) => [
          for (final p in all.reversed)
            if (p.lockedAt != null)
              ReportPeriod(label: p.label, from: p.startDate, to: p.endDate),
        ],
      ),
);

/// The period picked on Summary; null means the current academic year.
class SelectedPeriod extends Notifier<ReportPeriod?> {
  @override
  ReportPeriod? build() => null;

  void select(ReportPeriod? period) => state = period;
}

final selectedPeriodProvider = NotifierProvider<SelectedPeriod, ReportPeriod?>(
  SelectedPeriod.new,
);

/// The period Summary shows.
final activePeriodProvider = FutureProvider.autoDispose<ReportPeriod>((
  ref,
) async {
  final selected = ref.watch(selectedPeriodProvider);
  return selected ?? await ref.watch(currentYearPeriodProvider.future);
});

/// Whether Summary shows the current (open) academic year.
final isCurrentYearProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(selectedPeriodProvider) == null,
);

// ---------------------------------------------------------------------------
// Data for the period

final periodEntriesProvider = StreamProvider.autoDispose<List<EntryRow>>((
  ref,
) async* {
  final period = await ref.watch(activePeriodProvider.future);
  yield* ref
      .watch(entriesRepositoryProvider)
      .watchRange(from: period.from, to: period.to);
});

final periodOtherWorkProvider = StreamProvider.autoDispose<List<OtherWorkRow>>((
  ref,
) async* {
  final period = await ref.watch(activePeriodProvider.future);
  yield* ref
      .watch(otherWorkRepositoryProvider)
      .watchRange(from: period.from, to: period.to);
});

/// Role rows with their inputs and hours for the period (the same
/// calculation the export uses).
final periodReportProvider = FutureProvider.autoDispose<List<RoleRowReport>>((
  ref,
) async {
  final rows = await ref.watch(allRoleRowsProvider.future);
  final entries = await ref.watch(periodEntriesProvider.future);
  return buildPeriodReport(
    rows.values,
    entries,
    ref.watch(currentRatesProvider),
  );
});

/// A role row line on Summary (SPEC §8.7).
class RoleRowLine {
  const RoleRowLine({required this.report, required this.showBatch});

  final RoleRowReport report;

  /// The code has more than one batch, so the batch is shown.
  final bool showBatch;

  double get hours => report.hours.total;

  /// Zero and not credited automatically: "Nothing yet".
  bool get nothingYet => hours == 0 && !isAutomaticRole(report.row.role);
}

/// Everything the Summary screen shows for the period.
class SummaryView {
  const SummaryView({
    required this.total,
    required this.lines,
    required this.otherWorkMinutes,
    required this.latestCategory,
  });

  final CategoryHours total;

  /// Highest hours first; "Nothing yet" rows last.
  final List<RoleRowLine> lines;
  final int otherWorkMinutes;

  /// Category of the most recently logged entry (its bar is gold).
  final Category? latestCategory;

  /// Non-zero categories, largest first.
  List<Category> get barCategories =>
      Category.values.where((c) => total[c] > 0).toList()
        ..sort((a, b) => total[b].compareTo(total[a]));

  List<Category> get zeroCategories =>
      Category.values.where((c) => total[c] == 0).toList();
}

final summaryViewProvider = FutureProvider.autoDispose<SummaryView>((
  ref,
) async {
  final reports = await ref.watch(periodReportProvider.future);
  final entries = await ref.watch(periodEntriesProvider.future);
  final other = await ref.watch(periodOtherWorkProvider.future);

  final batchesByCode = <String, Set<String>>{};
  for (final r in reports) {
    (batchesByCode[r.row.moduleCode] ??= {}).add(r.row.batch);
  }
  final lines =
      [
        for (final r in reports)
          RoleRowLine(
            report: r,
            showBatch: (batchesByCode[r.row.moduleCode]?.length ?? 0) > 1,
          ),
      ]..sort((a, b) {
        if (a.nothingYet != b.nothingYet) return a.nothingYet ? 1 : -1;
        final byHours = b.hours.compareTo(a.hours);
        // Equal hours keep workbook order (List.sort is not stable).
        return byHours != 0
            ? byHours
            : reports.indexOf(a.report).compareTo(reports.indexOf(b.report));
      });

  final logged =
      entries
          .where(
            (e) =>
                !e.isOpeningBalance &&
                e.status == EntryStatus.complete &&
                categoryOf(e.activity) != null,
          )
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return SummaryView(
    total: CategoryHours.sum(reports.map((r) => r.hours)),
    lines: lines,
    otherWorkMinutes: other.fold(0, (sum, o) => sum + o.spentMinutes),
    latestCategory: logged.isEmpty ? null : categoryOf(logged.first.activity),
  );
});

// ---------------------------------------------------------------------------
// Closing a period

/// "2025/26" → "2026/27"; otherwise a label for today's date.
String nextYearLabel(String current, DateTime now) {
  final match = RegExp(r'^(\d{4})/(\d{2})$').firstMatch(current.trim());
  if (match == null) return suggestedAcademicYearLabel(now);
  final start = int.parse(match.group(1)!) + 1;
  return '$start/${((start + 1) % 100).toString().padLeft(2, '0')}';
}

class SummaryActions {
  SummaryActions(this._ref);

  final Ref _ref;

  /// Locks everything up to and including today under [label] and starts
  /// the next year with [nextLabel]. Entries in it become read-only.
  Future<void> closeCurrentPeriod({
    required String label,
    required String nextLabel,
  }) async {
    final today = _ref.read(todayProvider);
    final periods = _ref.read(periodsRepositoryProvider);
    final yearStart = await periods.currentYearStart();
    final entries = await _ref
        .read(entriesRepositoryProvider)
        .getRange(from: yearStart, to: today);
    final earliest = entries.isEmpty
        ? today
        : entries
              .map((e) => e.date)
              .reduce((a, b) => a.compareTo(b) < 0 ? a : b);
    final id = await periods.create(
      label: label,
      startDate: yearStart ?? earliest,
      endDate: today,
    );
    await periods.close(id);
    await _ref
        .read(profileRepositoryProvider)
        .setAcademicYearLabel(
          nextLabel.trim().isEmpty ? label : nextLabel.trim(),
        );
    _ref.read(selectedPeriodProvider.notifier).select(null);
  }
}

final summaryActionsProvider = Provider(SummaryActions.new);
