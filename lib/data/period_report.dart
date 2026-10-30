/// One calculation of a period's role-row hours, shared by the Summary
/// screen and the export so the two can never disagree.
library;

import '../domain/credit_calculator.dart';
import '../domain/rates.dart';
import '../domain/roll_up.dart';
import '../domain/workbook_mapping.dart';
import 'db/app_database.dart';
import 'repositories/entries_repository.dart';
import 'repositories/role_rows_repository.dart';

/// A reporting period: the current academic year, a closed period, or a
/// custom range. Null bounds are open.
class ReportPeriod {
  const ReportPeriod({required this.label, this.from, this.to});

  final String label;
  final String? from;
  final String? to;

  @override
  bool operator ==(Object other) =>
      other is ReportPeriod &&
      other.label == label &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(label, from, to);
}

/// A role row with what the workbook will receive for the period.
class RoleRowReport {
  const RoleRowReport({
    required this.row,
    required this.inputs,
    required this.hours,
  });

  final RoleRow row;

  /// I–AI.
  final WorkbookInputs inputs;

  /// AJ–AU.
  final CategoryHours hours;
}

/// Role rows in workbook order with their inputs and hours for [entries]
/// (already limited to the period). Active rows are always included (they
/// are in the current workbook); inactive ones only when they have entries.
/// Automatic Coordinator / Moderator hours are included, as in the
/// workbook's formulas.
List<RoleRowReport> buildPeriodReport(
  Iterable<RoleRow> rows,
  Iterable<EntryRow> entries,
  RateSet rates,
) {
  final byRow = <int, List<EntryRow>>{};
  for (final entry in entries) {
    final id = entry.roleRowId;
    if (id != null) (byRow[id] ??= []).add(entry);
  }
  final included =
      rows.where((r) => r.isActive || byRow.containsKey(r.id)).toList()
        ..sort((a, b) {
          final bySheet = (a.sheetRow ?? 1 << 30).compareTo(
            b.sheetRow ?? 1 << 30,
          );
          return bySheet != 0 ? bySheet : a.id.compareTo(b.id);
        });
  return [
    for (final row in included)
      () {
        final inputs = rollUp(
          (byRow[row.id] ?? const []).map((e) => e.toInput()),
        );
        return RoleRowReport(
          row: row,
          inputs: inputs,
          hours: roleRowHours(row.toInfo(), inputs, rates),
        );
      }(),
  ];
}
