import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/entries_repository.dart';
import '../../domain/credit_calculator.dart';
import '../../domain/enums.dart';
import '../../domain/rates.dart';

/// One line in History: an entry or a piece of other work.
sealed class HistoryItem {
  const HistoryItem();

  DateTime get createdAt;
}

class EntryItem extends HistoryItem {
  const EntryItem(this.entry);

  final EntryRow entry;

  @override
  DateTime get createdAt => entry.createdAt;
}

class OtherWorkItem extends HistoryItem {
  const OtherWorkItem(this.work);

  final OtherWorkRow work;

  @override
  DateTime get createdAt => work.createdAt;
}

/// A day in History with its header ("TODAY · THU 29 OCT").
class DaySection {
  const DaySection(this.date, this.header, this.items);

  final String date;
  final String header;
  final List<HistoryItem> items;
}

/// Groups complete entries and other work by day, newest day first and
/// newest first within a day (SPEC §8.6). Drafts are left out: they have
/// their own cards.
List<DaySection> groupByDay(
  Iterable<EntryRow> entries,
  Iterable<OtherWorkRow> otherWork, {
  required String today,
}) {
  final byDate = <String, List<HistoryItem>>{};
  for (final entry in entries) {
    if (entry.status == EntryStatus.draft) continue;
    (byDate[entry.date] ??= []).add(EntryItem(entry));
  }
  for (final work in otherWork) {
    (byDate[work.date] ??= []).add(OtherWorkItem(work));
  }
  final dates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final date in dates)
      DaySection(
        date,
        formatDayHeader(date, today: today),
        byDate[date]!..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      ),
  ];
}

/// Progress of marking on one role row (SPEC §8.6 batch progress cards).
class MarkingProgress {
  const MarkingProgress({
    required this.row,
    required this.activity,
    required this.countsStudents,
    required this.total,
    required this.batches,
    required this.hours,
  });

  final RoleRow row;

  /// CA or end-exam marking.
  final Activity activity;

  /// Project evaluation counts students; everything else counts papers.
  final bool countsStudents;
  final double total;
  final int batches;
  final double hours;

  /// The module's students, when known (> 0): the bar's target.
  int? get target => row.students > 0 ? row.students : null;

  String get title {
    final exam = activity == Activity.examMarking;
    final what = countsStudents
        ? (exam ? 'end-exam evaluation' : 'CA evaluation')
        : (exam ? 'end-exam marking' : 'CA marking');
    return '${row.moduleCode} $what';
  }

  String get unit => countsStudents ? 'students' : 'papers';
}

/// One card per (role row, marking activity, papers or students) that the
/// user has logged at least one batch for. Opening balances count toward the
/// totals but do not make a card on their own.
List<MarkingProgress> markingProgress(
  Iterable<EntryRow> entries,
  Map<int, RoleRow> rows,
  RateSet rates,
) {
  final groups = <(int, Activity, bool), List<EntryRow>>{};
  for (final entry in entries) {
    final rowId = entry.roleRowId;
    if (rowId == null ||
        entry.deletedAt != null ||
        entry.status != EntryStatus.complete ||
        !entry.activity.isMarking) {
      continue;
    }
    final key = (rowId, entry.activity, entry.subtype == Subtype.project);
    (groups[key] ??= []).add(entry);
  }

  final result = <MarkingProgress>[];
  for (final MapEntry(key: (rowId, activity, students), value: batch)
      in groups.entries) {
    final row = rows[rowId];
    if (row == null || batch.every((e) => e.isOpeningBalance)) continue;
    result.add(
      MarkingProgress(
        row: row,
        activity: activity,
        countsStudents: students,
        total: batch.fold(0, (sum, e) => sum + (e.count ?? 0)),
        batches: batch.length,
        hours: batch.fold(0, (sum, e) => sum + entryCredit(e.toInput(), rates)),
      ),
    );
  }
  return result;
}
