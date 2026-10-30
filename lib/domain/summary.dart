/// Totals over many entries and role rows. Pure Dart.
library;

import 'credit_calculator.dart';
import 'rates.dart';
import 'role_row.dart';
import 'roll_up.dart';

/// Credited hours per role row for a period, and their total.
class PeriodSummary {
  PeriodSummary(Map<int, CategoryHours> byRoleRow)
    : byRoleRow = Map.unmodifiable(byRoleRow),
      total = CategoryHours.sum(byRoleRow.values);

  static final empty = PeriodSummary(const {});

  /// Keyed by role row id.
  final Map<int, CategoryHours> byRoleRow;

  /// All role rows added up (the Summary hero and category bars).
  final CategoryHours total;
}

/// Hours for each role row in [rows] from its entries, exactly as the exported
/// workbook rows will compute them: entries are rolled up into I–AI and run
/// through [roleRowHours], so automatic Coordinator and Moderator hours are
/// included. Entries of role rows not in [rows] are ignored.
PeriodSummary summarize(
  Map<int, RoleRowInfo> rows,
  Map<int, List<EntryInput>> entriesByRoleRow,
  RateSet rates,
) => PeriodSummary({
  for (final MapEntry(key: id, value: row) in rows.entries)
    id: roleRowHours(row, rollUp(entriesByRoleRow[id] ?? const []), rates),
});

/// Sum of the entries' own credits. Used for "today" and "this week", which
/// never include automatic hours.
double creditedHours(Iterable<EntryInput> entries, RateSet rates) =>
    entries.fold(0, (sum, entry) => sum + entryCredit(entry, rates));
