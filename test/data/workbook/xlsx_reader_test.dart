import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/workbook/xlsx_reader.dart';

final referenceBytes = File('docs/reference/DEIE_Workload_Model_V10_1.xlsx')
    .readAsBytesSync();

void main() {
  late XlsxReader reader;
  setUpAll(() => reader = XlsxReader.fromBytes(referenceBytes));

  test('lists the sheets', () {
    expect(
      reader.sheetNames,
      containsAll([
        'Admin_Config',
        'Staff_List',
        'Data_Entry',
        'PG_Project_Supervision',
        'Workload_Summary',
      ]),
    );
  });

  test('formula cells give the value Excel computed', () {
    final admin = reader.readSheet('Admin_Config');
    expect(admin.at('A', 8).text, startsWith('Second marking'));
    expect(admin.at('B', 8).value, closeTo(0.1, 1e-12));
    expect(admin.at('B', 8).formula, '6/60');
    // A shared formula with no text of its own still has its cached value.
    expect(admin.at('B', 27).value, closeTo(0.1, 1e-12));
    expect(admin.at('B', 27).formula, '');
    expect(admin.at('B', 31).value, 0.002);
    expect(admin.at('B', 31).formula, isNull);
  });

  test('shared strings, including long multi-line ones', () {
    final admin = reader.readSheet('Admin_Config');
    expect(admin.at('A', 13).text, 'Quiz question');
    expect(admin.at('A', 12).text, startsWith('2. CONTINUOUS ASSESSMENT'));
  });

  test('string formulas (PG sheet staff names) keep their cached text', () {
    final pg = reader.readSheet('PG_Project_Supervision');
    expect(pg.at('B', 4).text, 'Dr. Anuradha Mendis');
    expect(pg.at('B', 4).formula, 'Staff_List!B4');
  });

  test('Data_Entry owner row 129', () {
    final de = reader.readSheet('Data_Entry');
    expect(de.at('A', 129).text, 'EE3202');
    expect(de.at('G', 129).text, 'Mr. Kalhara Batangala');
    expect(de.at('AC', 129).value, 74);
    expect(de.at('AD', 129).value, 1);
    expect(de.isRowEmpty(932), isTrue);
    expect(de.lastRow, greaterThanOrEqualTo(931));
  });

  test('not an xlsx → XlsxFormatException', () {
    expect(
      () => XlsxReader.fromBytes(Uint8List.fromList([1, 2, 3])),
      throwsA(isA<XlsxFormatException>()),
    );
    expect(() => reader.readSheet('Nope'), throwsA(isA<XlsxFormatException>()));
  });
}
