/// Entries → workbook input values for one role row (SPEC §7.1).
library;

import 'role_row.dart';
import 'workbook_mapping.dart';

/// Sums a role row's complete, non-deleted entries into its I–AI values.
///
/// Paper-marking pairs (e.g. AC/AD) get papers = Σ papers and
/// Qs/paper = Σ(papers × qpp) / Σ papers at full precision, so that
/// papers × qpp reproduces the credited hours exactly even when batches used
/// different Qs/paper.
///
/// Throws [ArgumentError] for a complete entry missing its count or, for paper
/// marking, its Qs/paper — validation makes such entries impossible.
WorkbookInputs rollUp(Iterable<EntryInput> entries) {
  final totals = <InputColumn, double>{};
  // Σ(papers × qpp) per Qs/paper column.
  final questionsMarked = <InputColumn, double>{};

  for (final entry in entries) {
    if (!entry.counts) continue;
    final target = columnTargetFor(entry.activity, entry.subtype);
    if (target == null) continue; // moderationDone, other

    final count = entry.count;
    if (count == null) {
      throw ArgumentError.value(
        entry,
        'entries',
        'complete entry has no count',
      );
    }
    totals.update(target.count, (sum) => sum + count, ifAbsent: () => count);

    final qppColumn = target.questionsPerPaper;
    if (qppColumn != null) {
      final qpp = entry.questionsPerPaper;
      if (qpp == null) {
        throw ArgumentError.value(
          entry,
          'entries',
          'paper marking needs questions per paper',
        );
      }
      final questions = count * qpp;
      questionsMarked.update(
        qppColumn,
        (sum) => sum + questions,
        ifAbsent: () => questions,
      );
    }
  }

  for (final target in columnTargets.values) {
    final qppColumn = target.questionsPerPaper;
    if (qppColumn == null) continue;
    final papers = totals[target.count] ?? 0;
    if (papers != 0) {
      totals[qppColumn] = questionsMarked[qppColumn]! / papers;
    }
  }

  return WorkbookInputs(totals);
}
