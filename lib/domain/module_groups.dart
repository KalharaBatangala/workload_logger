/// Role rows merged per module code, as Step 1 lists them (SPEC §8.2).
library;

import 'enums.dart';
import 'role_row.dart';

/// A role row with its database id.
typedef IdentifiedRow = ({int id, RoleRowInfo info});

/// All of the owner's role rows for one module code.
class ModuleGroup {
  ModuleGroup(this.code, List<IdentifiedRow> rows)
    : rows = List.unmodifiable(rows);

  final String code;

  /// In workbook order.
  final List<IdentifiedRow> rows;

  String get name => rows.first.info.moduleName;

  /// Distinct batches, oldest intake first ("24th" before "25th").
  List<String> get batches {
    final distinct = rows.map((r) => r.info.batch).toSet().toList();
    distinct.sort((a, b) => _batchNumber(a).compareTo(_batchNumber(b)));
    return distinct;
  }

  /// Distinct roles, in the order of [Role] (Coordinator, Teacher, Second
  /// Examiner, Moderator).
  List<Role> get roles => Role.values
      .where((role) => rows.any((r) => r.info.role == role))
      .toList();

  bool get isProject =>
      rows.any((r) => r.info.moduleType == ModuleType.project);

  /// "Teacher · 25th · Project", "Second Examiner + Moderator · 25th",
  /// "Second Examiner · 24th and 25th".
  String get subtitle => [
    roles.map((r) => r.workbookLabel).join(' + '),
    batches.join(' and '),
    if (isProject) 'Project',
  ].join(' · ');

  List<IdentifiedRow> rowsForBatch(String batch) =>
      rows.where((r) => r.info.batch == batch).toList();

  bool contains(int roleRowId) => rows.any((r) => r.id == roleRowId);

  static int _batchNumber(String batch) =>
      int.tryParse(RegExp(r'\d+').firstMatch(batch)?.group(0) ?? '') ?? 0;
}

/// Groups role rows by module code, keeping the order in which each code
/// first appears.
List<ModuleGroup> groupModules(Iterable<IdentifiedRow> rows) {
  final byCode = <String, List<IdentifiedRow>>{};
  for (final row in rows) {
    (byCode[row.info.moduleCode] ??= []).add(row);
  }
  return [
    for (final MapEntry(:key, :value) in byCode.entries)
      ModuleGroup(key, value),
  ];
}
