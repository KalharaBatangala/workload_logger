/// Reads what the app needs from a DEIE Workload Model workbook (SPEC §3,
/// §7.2): rates, staff names, Data_Entry role rows and PG supervision counts.
/// Pure Dart; safe to run in a background isolate.
library;

import 'dart:typed_data';

import '../../domain/enums.dart';
import '../../domain/rates.dart';
import '../../domain/role_row.dart';
import '../../domain/workbook_mapping.dart';
import 'xlsx_reader.dart';

/// Thrown when the workbook does not have the expected layout.
class WorkbookFormatException implements Exception {
  WorkbookFormatException(this.message);

  /// A plain-language explanation for the user.
  final String message;

  @override
  String toString() => 'WorkbookFormatException: $message';
}

/// One usable Data_Entry row.
class DataEntryRow {
  const DataEntryRow({
    required this.sheetRow,
    required this.staffName,
    required this.info,
    required this.credits,
    required this.inputs,
  });

  final int sheetRow;
  final String staffName;
  final RoleRowInfo info;
  final double credits;

  /// Values already in columns I–AI (the opening balance).
  final WorkbookInputs inputs;
}

/// A Data_Entry row that names a staff member but could not be used.
class SkippedRow {
  const SkippedRow(this.sheetRow, this.staffName, this.reason);

  final int sheetRow;
  final String staffName;
  final String reason;
}

class ParsedWorkbook {
  const ParsedWorkbook({
    required this.rates,
    required this.rateWarnings,
    required this.staffNames,
    required this.rows,
    required this.skippedRows,
    required this.pgStudents,
    this.academicYearHint,
  });

  final RateSet rates;

  /// One message per rate that fell back to its default.
  final List<String> rateWarnings;

  /// Staff_List names, in sheet order.
  final List<String> staffNames;

  /// All usable Data_Entry rows, in sheet order.
  final List<DataEntryRow> rows;
  final List<SkippedRow> skippedRows;

  /// PG students supervised, keyed by [normalizeStaffName].
  final Map<String, int> pgStudents;

  /// e.g. "2025/26" when the README states the teacher-list dates.
  final String? academicYearHint;

  List<DataEntryRow> rowsFor(String staffName) {
    final key = normalizeStaffName(staffName);
    return [
      for (final row in rows)
        if (normalizeStaffName(row.staffName) == key) row,
    ];
  }

  List<SkippedRow> skippedFor(String staffName) {
    final key = normalizeStaffName(staffName);
    return [
      for (final row in skippedRows)
        if (normalizeStaffName(row.staffName) == key) row,
    ];
  }

  int pgStudentsFor(String staffName) =>
      pgStudents[normalizeStaffName(staffName)] ?? 0;
}

/// Staff names are compared after trimming and collapsing whitespace (§3.3).
String normalizeStaffName(String name) =>
    name.trim().replaceAll(RegExp(r'\s+'), ' ');

/// A friendly first name for greetings: "Mr. Kalhara Batangala" → "Kalhara",
/// "Dr. C.K.W. Seneviratne" → "Seneviratne".
String displayNameFrom(String staffName) {
  var rest = normalizeStaffName(staffName)
      .replaceAll(RegExp(r'\(VL\)', caseSensitive: false), '')
      .trim();
  final title = RegExp(
    r'^(mr|ms|mrs|miss|dr|prof|eng|rev)\.?\s+',
    caseSensitive: false,
  );
  while (title.hasMatch(rest)) {
    rest = rest.replaceFirst(title, '');
  }
  final words = rest.split(' ').where((w) => w.isNotEmpty);
  return words.firstWhere(
    (w) => !w.endsWith('.'),
    orElse: () => rest.isEmpty ? normalizeStaffName(staffName) : rest,
  );
}

const _adminSheet = 'Admin_Config';
const _staffSheet = 'Staff_List';
const _dataSheet = 'Data_Entry';
const _pgSheet = 'PG_Project_Supervision';
const _readmeSheet = 'README';
const _teacherListSheet = 'Teacher List';

/// Parses the workbook. Throws [XlsxFormatException] for a file that is not
/// an .xlsx and [WorkbookFormatException] for one with the wrong layout.
ParsedWorkbook parseWorkbook(Uint8List bytes) {
  final reader = XlsxReader.fromBytes(bytes);
  for (final sheet in [_adminSheet, _staffSheet, _dataSheet]) {
    if (!reader.hasSheet(sheet)) {
      throw WorkbookFormatException(
        'This does not look like the DEIE Workload Model: '
        'the "$sheet" sheet is missing.',
      );
    }
  }

  final (rates, rateWarnings) = _readRates(reader.readSheet(_adminSheet));
  final (rows, skipped) = _readDataEntry(reader.readSheet(_dataSheet));
  return ParsedWorkbook(
    rates: rates,
    rateWarnings: rateWarnings,
    staffNames: _readStaff(reader.readSheet(_staffSheet)),
    rows: rows,
    skippedRows: skipped,
    pgStudents: reader.hasSheet(_pgSheet)
        ? _readPg(reader.readSheet(_pgSheet))
        : const {},
    academicYearHint: _academicYearHint(reader),
  );
}

// ---------------------------------------------------------------------------
// Admin_Config (SPEC §3.1)

final _sectionHeading = RegExp(r'^(\d+)\.\s');

RateSection _sectionFor(int number) => switch (number) {
  1 => RateSection.general,
  2 => RateSection.caPreparation,
  3 => RateSection.examPreparation,
  4 => RateSection.caMarking,
  5 => RateSection.examMarking,
  _ => RateSection.supervision,
};

String _hours(double h) => h == h.roundToDouble() ? h.toStringAsFixed(0) : '$h';

(RateSet, List<String>) _readRates(SheetData sheet) {
  final wanted = {
    for (final key in RateKey.values)
      if (key.isInAdminConfig)
        (normalizeWorkbookText(key.label), key.section): key,
  };
  final found = <RateKey, double>{};
  final warnings = <String>[];

  var section = RateSection.general;
  for (var row = 1; row <= sheet.lastRow; row++) {
    final label = sheet.at('A', row).text;
    if (label.isEmpty) continue;
    final heading = _sectionHeading.firstMatch(label);
    if (heading != null && sheet.at('B', row).isEmpty) {
      section = _sectionFor(int.parse(heading.group(1)!));
      continue;
    }
    final key = wanted[(normalizeWorkbookText(label), section)];
    if (key == null || found.containsKey(key)) continue;

    final value = _rateValue(sheet.at('B', row));
    if (value == null) {
      warnings.add(
        '"${key.label}" (B$row) could not be read; '
        'using the default ${_hours(key.defaultHours)} h.',
      );
    } else {
      found[key] = value;
    }
  }

  for (final key in wanted.values) {
    final alreadyWarned = warnings.any((w) => w.startsWith('"${key.label}"'));
    if (!found.containsKey(key) && !alreadyWarned) {
      warnings.add(
        '"${key.label}" was not found in Admin_Config; '
        'using the default ${_hours(key.defaultHours)} h.',
      );
    }
  }
  return (RateSet.from(found), warnings);
}

final _simpleFormula = RegExp(
  r'^\s*=?\s*(-?\d+(?:\.\d+)?)\s*(?:([*/])\s*(-?\d+(?:\.\d+)?))?\s*$',
);

/// The rate in a cell: Excel's computed value, else a simple formula
/// (`a`, `a/b`, `a*b`) evaluated here, else null.
double? _rateValue(XlsxCell cell) {
  final value = cell.value;
  if (value is num) return value.toDouble();
  for (final text in [cell.formula, if (value is String) value]) {
    if (text == null || text.isEmpty) continue;
    final match = _simpleFormula.firstMatch(text);
    if (match == null) continue;
    final a = double.parse(match.group(1)!);
    final op = match.group(2);
    if (op == null) return a;
    final b = double.parse(match.group(3)!);
    if (op == '*') return a * b;
    if (b != 0) return a / b;
  }
  return null;
}

// ---------------------------------------------------------------------------
// Staff_List (SPEC §3.3)

List<String> _readStaff(SheetData sheet) => [
  for (var row = 4; sheet.at('B', row).text.isNotEmpty; row++)
    normalizeStaffName(sheet.at('B', row).text),
];

// ---------------------------------------------------------------------------
// Data_Entry (SPEC §3.2)

const _expectedHeaders = {
  ('A', 3): 'module code',
  ('G', 3): 'staff name',
  ('H', 3): 'role',
  ('AC', 4): 'essay: papers marked',
};

final _firstInput = columnIndex('A');
final _lastInput = InputColumn.ai.index0;

(List<DataEntryRow>, List<SkippedRow>) _readDataEntry(SheetData sheet) {
  for (final MapEntry(key: (column, row), value: expected)
      in _expectedHeaders.entries) {
    final actual = normalizeWorkbookText(sheet.at(column, row).text);
    if (!actual.startsWith(expected)) {
      throw WorkbookFormatException(
        'Data_Entry does not have the expected columns '
        '($column$row should be "$expected"). '
        'Is this the DEIE Workload Model V10 layout?',
      );
    }
  }

  bool isEmptyRow(int row) {
    for (var c = _firstInput; c <= _lastInput; c++) {
      if (!sheet.cell(row, c).isEmpty) return false;
    }
    return true;
  }

  bool isMissing(String text) => text.isEmpty || text.toUpperCase() == 'NA';

  double number(XlsxCell cell) =>
      cell.value is num ? (cell.value as num).toDouble() : 0;

  final rows = <DataEntryRow>[];
  final skipped = <SkippedRow>[];
  for (var r = 5; !isEmptyRow(r); r++) {
    final code = sheet.at('A', r).text;
    final staff = normalizeStaffName(sheet.at('G', r).text);
    if (isMissing(code) || isMissing(staff)) {
      if (!isMissing(staff)) {
        skipped.add(SkippedRow(r, staff, 'no module code'));
      }
      continue;
    }
    final roleText = sheet.at('H', r).text;
    final role = Role.fromWorkbook(roleText);
    if (role == null) {
      skipped.add(
        SkippedRow(
          r,
          staff,
          roleText.isEmpty ? 'no role' : 'unknown role "$roleText"',
        ),
      );
      continue;
    }
    rows.add(
      DataEntryRow(
        sheetRow: r,
        staffName: staff,
        credits: number(sheet.at('E', r)),
        info: RoleRowInfo(
          moduleCode: code,
          batch: sheet.at('B', r).text,
          moduleName: sheet.at('C', r).text,
          moduleType: ModuleType.fromWorkbook(sheet.at('D', r).text),
          role: role,
          students: number(sheet.at('F', r)).round(),
        ),
        inputs: WorkbookInputs({
          for (final column in InputColumn.values)
            column: number(sheet.cell(r, column.index0)),
        }),
      ),
    );
  }
  return (rows, skipped);
}

// ---------------------------------------------------------------------------
// PG_Project_Supervision (SPEC §3.4)

Map<String, int> _readPg(SheetData sheet) => {
  for (var row = 4; sheet.at('B', row).text.isNotEmpty; row++)
    normalizeStaffName(
      sheet.at('B', row).text,
    ): (sheet.at('C', row).value is num)
        ? (sheet.at('C', row).value as num).round()
        : 0,
};

// ---------------------------------------------------------------------------
// Academic year hint: a note such as
// "Updated Teacher List (2025.07.21 - 2026.08.23)" → "2025/26".

final _yearRange = RegExp(r'(\d{4})\.\d{1,2}\.\d{1,2}\s*-\s*(\d{4})\.\d');

String? _academicYearHint(XlsxReader reader) {
  for (final name in [_readmeSheet, _teacherListSheet]) {
    if (!reader.hasSheet(name)) continue;
    for (final cell in reader.readSheet(name).cells) {
      final match = _yearRange.firstMatch(cell.text);
      if (match == null) continue;
      final start = int.parse(match.group(1)!);
      final end = int.parse(match.group(2)!);
      if (end == start + 1) {
        return '$start/${(end % 100).toString().padLeft(2, '0')}';
      }
    }
  }
  return null;
}
