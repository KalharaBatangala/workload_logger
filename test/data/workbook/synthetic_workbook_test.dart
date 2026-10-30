import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/workbook/workbook_parser.dart';
import 'package:workload_logger/data/workbook/xlsx_reader.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

/// Builds a small workbook in the DEIE layout. Formulas written by the
/// `excel` package have no cached values, so the parser must evaluate them.
Uint8List buildWorkbook({
  bool includeEssayQuestion = true,
  bool badHeader = false,
  List<List<Object?>> dataRows = const [],
}) {
  final excel = Excel.createExcel();
  excel.rename(excel.getDefaultSheet()!, 'Admin_Config');

  void put(String sheet, String ref, Object? value) {
    final cell = excel[sheet].cell(CellIndex.indexByString(ref));
    cell.value = switch (value) {
      null => null,
      final num n => DoubleCellValue(n.toDouble()),
      final String s when s.startsWith('=') => FormulaCellValue(s.substring(1)),
      final String s => TextCellValue(s),
      _ => throw ArgumentError(value),
    };
  }

  // Admin_Config: sections and a subset of rates.
  put('Admin_Config', 'A4', '1. GENERAL');
  put('Admin_Config', 'A8', 'Second marking - End exam (hours per paper)');
  put('Admin_Config', 'B8', '=6/60');
  put('Admin_Config', 'A9', 'Moderator (per module, per semester)');
  put('Admin_Config', 'B9', '=3*1');
  put('Admin_Config', 'A12', '2. CONTINUOUS ASSESSMENT (CA) PREPARATION');
  put('Admin_Config', 'A13', 'Quiz question');
  put('Admin_Config', 'B13', '=12/60'); // 0.2: differs from the default
  if (includeEssayQuestion) {
    put('Admin_Config', 'A15', 'Essay question');
    put('Admin_Config', 'B15', 3);
  }
  put('Admin_Config', 'A18', '3. END-OF-SEMESTER EXAM PREPARATION');
  put('Admin_Config', 'A20', 'Structured question');
  put('Admin_Config', 'B20', '=SUM(A1:A2)'); // too complex → default

  // Staff_List.
  put('Staff_List', 'B3', 'Staff Name');
  put('Staff_List', 'B4', 'Mr. Kalhara Batangala');
  put('Staff_List', 'B5', 'Dr. Someone Else');

  // Data_Entry headers.
  put('Data_Entry', 'A3', badHeader ? 'Code' : 'Module Code');
  put('Data_Entry', 'G3', 'Staff Name');
  put('Data_Entry', 'H3', 'Role');
  put('Data_Entry', 'AC4', 'Essay: Papers Marked (#)');
  for (final (i, values) in dataRows.indexed) {
    for (final (c, value) in values.indexed) {
      put('Data_Entry', '${columnLetter(c)}${5 + i}', value);
    }
  }
  return Uint8List.fromList(excel.encode()!);
}

List<Object?> dataRow({
  String? code = 'EC5208',
  String batch = '25th',
  String type = 'Taught',
  String staff = 'Mr. Kalhara Batangala',
  String role = 'Teacher',
  Object? students = 0,
  Map<String, Object?> inputs = const {},
}) {
  final row = List<Object?>.filled(columnIndex('AI') + 1, null);
  row[0] = code;
  row[1] = batch;
  row[2] = 'Module name';
  row[3] = type;
  row[4] = 0;
  row[5] = students;
  row[6] = staff;
  row[7] = role;
  for (final MapEntry(:key, :value) in inputs.entries) {
    row[columnIndex(key)] = value;
  }
  return row;
}

void main() {
  test('formulas without cached values are evaluated', () {
    final parsed = parseWorkbook(buildWorkbook());
    expect(parsed.rates.hours(RateKey.secondMarkPaper), closeTo(0.1, 1e-12));
    expect(parsed.rates.hours(RateKey.moderator), 3);
    expect(parsed.rates.hours(RateKey.caPrepQuiz), closeTo(0.2, 1e-12));
    expect(parsed.rates.hours(RateKey.caPrepEssay), 3);
    expect(parsed.rates.isDefault(RateKey.caPrepEssay), isFalse);
  });

  test('labels are matched within their section', () {
    // "Structured question" exists only in section 3 here, so the CA one
    // (section 2) is missing and the exam one could not be evaluated.
    final parsed = parseWorkbook(buildWorkbook());
    expect(parsed.rates.isDefault(RateKey.caPrepStructured), isTrue);
    expect(parsed.rates.isDefault(RateKey.examPrepStructured), isTrue);
    expect(
      parsed.rateWarnings,
      contains(contains('"Structured question" (B20) could not be read')),
    );
  });

  test('missing labels fall back to defaults with a warning', () {
    final parsed = parseWorkbook(buildWorkbook(includeEssayQuestion: false));
    expect(parsed.rates.hours(RateKey.caPrepEssay), 2);
    expect(parsed.rates.isDefault(RateKey.caPrepEssay), isTrue);
    expect(
      parsed.rateWarnings,
      contains(
        '"Essay question" was not found in Admin_Config; '
        'using the default 2 h.',
      ),
    );
    // The PG rate is never in Admin_Config, so it is never warned about.
    expect(
      parsed.rateWarnings.where((w) => w.contains('Postgraduate')),
      isEmpty,
    );
  });

  test('data rows: junk skipped, NA numbers read as 0, stops at empty row', () {
    final parsed = parseWorkbook(
      buildWorkbook(
        dataRows: [
          dataRow(inputs: {'J': 10, 'AC': 40, 'AD': 'NA'}),
          dataRow(code: 'NA'),
          dataRow(code: null),
          dataRow(role: 'Examiner'),
          dataRow(type: 'Coordinated,Project', role: 'Coordinator'),
          dataRow(staff: 'Dr. Someone Else', students: 'NA'),
          List<Object?>.filled(3, null), // empty row: stop here
          dataRow(code: 'EC9999'),
        ],
      ),
    );
    final mine = parsed.rowsFor('Mr. Kalhara Batangala');
    expect(mine.map((r) => r.sheetRow), [5, 9]);
    expect(
      mine.first.inputs,
      WorkbookInputs({InputColumn.j: 10, InputColumn.ac: 40}),
    );
    expect(mine.last.info.moduleType, ModuleType.taught);
    expect(mine.last.info.role, Role.coordinator);
    expect(parsed.skippedFor('Mr. Kalhara Batangala').map((s) => s.reason), [
      'no module code', // code "NA"
      'no module code', // code empty
      'unknown role "Examiner"',
    ]);
    expect(parsed.rowsFor('Dr. Someone Else').single.info.students, 0);
    expect(parsed.rows.any((r) => r.info.moduleCode == 'EC9999'), isFalse);
  });

  test('wrong Data_Entry layout → WorkbookFormatException', () {
    expect(
      () => parseWorkbook(buildWorkbook(badHeader: true)),
      throwsA(isA<WorkbookFormatException>()),
    );
  });

  test('a workbook without the DEIE sheets → WorkbookFormatException', () {
    final excel = Excel.createExcel();
    final bytes = Uint8List.fromList(excel.encode()!);
    expect(() => parseWorkbook(bytes), throwsA(isA<WorkbookFormatException>()));
  });

  test('not an xlsx at all → XlsxFormatException', () {
    expect(
      () => parseWorkbook(Uint8List.fromList('hello'.codeUnits)),
      throwsA(isA<XlsxFormatException>()),
    );
  });
}
