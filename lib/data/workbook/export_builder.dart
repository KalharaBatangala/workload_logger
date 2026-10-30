/// Builds the export workbooks (SPEC §7.3) from already computed values.
/// Pure Dart (the `excel` package), so it is fully unit-tested.
library;

import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../domain/credit_calculator.dart';
import '../../domain/enums.dart';
import '../../domain/role_row.dart';
import '../../domain/workbook_mapping.dart';
import 'data_entry_layout.dart';

/// One of the owner's Data_Entry rows, ready to write.
class ExportRoleRow {
  const ExportRoleRow({
    required this.info,
    required this.staffName,
    required this.credits,
    required this.inputs,
    required this.hours,
  });

  final RoleRowInfo info;
  final String staffName;
  final double credits;

  /// I–AI, from the roll-up of the period's entries.
  final WorkbookInputs inputs;

  /// AJ–AU.
  final CategoryHours hours;
}

/// One entry in the evidence log. Time spent is deliberately absent: it
/// stays private (SPEC §14 Q3, decided with the owner).
class EvidenceLine {
  const EvidenceLine({
    required this.date,
    required this.module,
    required this.batch,
    required this.role,
    required this.activity,
    required this.type,
    required this.count,
    required this.questionsPerPaper,
    required this.credited,
    required this.note,
    required this.photos,
    required this.loggedAt,
  });

  final String date;
  final String module;
  final String batch;
  final String role;
  final String activity;
  final String type;
  final double? count;
  final double? questionsPerPaper;
  final double credited;
  final String note;
  final int photos;
  final String loggedAt;
}

class OtherWorkLine {
  const OtherWorkLine({
    required this.date,
    required this.category,
    required this.note,
  });

  final String date;
  final String category;
  final String note;
}

class PgLine {
  const PgLine({
    required this.academicYear,
    required this.students,
    required this.hours,
  });

  final String academicYear;
  final int students;
  final double hours;
}

const dataEntrySheet = 'My Data_Entry';
const evidenceSheet = 'Evidence log';
const otherWorkSheet = 'Other work';
const pgSheet = 'PG supervision';

const evidenceHeaders = [
  'Date',
  'Module',
  'Batch',
  'Role',
  'Activity',
  'Type',
  'Count',
  'Qs/paper',
  'Credited h',
  'Note',
  'Photos',
  'Logged at',
];

/// The full export: My Data_Entry, Evidence log, Other work, PG supervision.
Uint8List buildWorkloadWorkbook({
  required String staffName,
  required String periodLabel,
  required String exportedOn,
  required List<ExportRoleRow> rows,
  required List<EvidenceLine> evidence,
  required List<OtherWorkLine> otherWork,
  required PgLine pg,
}) {
  final excel = _newWorkbook(dataEntrySheet);
  _writeDataEntry(
    _Writer(excel[dataEntrySheet]),
    staffName: staffName,
    periodLabel: periodLabel,
    exportedOn: exportedOn,
    rows: rows,
  );
  _writeEvidence(_Writer(excel[evidenceSheet]), evidence);

  final other = _Writer(excel[otherWorkSheet]);
  other.row(1, ['Date', 'Category', 'Note']);
  for (final (i, line) in otherWork.indexed) {
    other.row(i + 2, [line.date, line.category, line.note]);
  }

  final pgWriter = _Writer(excel[pgSheet]);
  pgWriter.row(1, ['Academic year', 'PG students supervised', 'Hours']);
  pgWriter.row(2, [pg.academicYear, pg.students, pg.hours]);

  return _encode(excel);
}

/// The evidence log on its own ("Export evidence log").
Uint8List buildEvidenceWorkbook(List<EvidenceLine> evidence) {
  final excel = _newWorkbook(evidenceSheet);
  _writeEvidence(_Writer(excel[evidenceSheet]), evidence);
  return _encode(excel);
}

Excel _newWorkbook(String firstSheet) {
  final excel = Excel.createExcel();
  excel.rename(excel.getDefaultSheet()!, firstSheet);
  return excel;
}

Uint8List _encode(Excel excel) => Uint8List.fromList(excel.encode()!);

void _writeDataEntry(
  _Writer w, {
  required String staffName,
  required String periodLabel,
  required String exportedOn,
  required List<ExportRoleRow> rows,
}) {
  w.put(
    'A',
    1,
    'Data_Entry rows for $staffName · $periodLabel · '
        'exported $exportedOn by Workload Logger',
  );
  for (final MapEntry(:key, :value) in dataEntryHeaderRow3.entries) {
    w.put(key, 3, value);
  }
  for (final MapEntry(:key, :value) in dataEntryHeaderRow4.entries) {
    w.put(key, 4, value);
  }

  var r = dataEntryFirstRow;
  for (final row in rows) {
    final info = row.info;
    w
      ..put('A', r, info.moduleCode)
      ..put('B', r, info.batch)
      ..put('C', r, info.moduleName)
      ..put('D', r, info.moduleType.workbookLabel)
      ..put('E', r, row.credits)
      ..put('F', r, info.students)
      ..put('G', r, row.staffName)
      ..put('H', r, info.role.workbookLabel);
    for (final column in InputColumn.values) {
      // Full precision (a weighted Qs/paper such as 116/78 is not rounded).
      w.put(column.letter, r, row.inputs[column]);
    }
    for (final category in Category.values) {
      w.put(category.hoursColumn, r, row.hours[category]);
    }
    w.put(Category.totalColumn, r, row.hours.total);
    r++;
  }

  final total = CategoryHours.sum(rows.map((row) => row.hours));
  w.put('A', r, 'TOTAL');
  for (final category in Category.values) {
    w.put(category.hoursColumn, r, total[category]);
  }
  w.put(Category.totalColumn, r, total.total);
}

void _writeEvidence(_Writer w, List<EvidenceLine> evidence) {
  w.row(1, evidenceHeaders);
  for (final (i, e) in evidence.indexed) {
    w.row(i + 2, [
      e.date,
      e.module,
      e.batch,
      e.role,
      e.activity,
      e.type,
      e.count,
      e.questionsPerPaper,
      e.credited,
      e.note,
      e.photos,
      e.loggedAt,
    ]);
  }
}

/// Writes cells by column letter and 1-based row, as people read sheets.
class _Writer {
  _Writer(this.sheet);

  final Sheet sheet;

  void put(String column, int row, Object? value) {
    final cell = CellIndex.indexByColumnRow(
      columnIndex: columnIndex(column),
      rowIndex: row - 1,
    );
    final CellValue? cellValue = switch (value) {
      null => null,
      final int v => IntCellValue(v),
      final double v => DoubleCellValue(v),
      final String v => TextCellValue(v),
      _ => TextCellValue('$value'),
    };
    if (cellValue != null) sheet.updateCell(cell, cellValue);
  }

  void row(int row, List<Object?> values) {
    for (final (i, value) in values.indexed) {
      put(columnLetter(i), row, value);
    }
  }
}
