import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/period_report.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/data/workbook/export_builder.dart';
import 'package:workload_logger/data/workbook/export_service.dart';
import 'package:workload_logger/data/workbook/xlsx_reader.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import '../test_database.dart';
import 'xlsx_reader_test.dart' show referenceBytes;

const year = ReportPeriod(label: '2025/26');

void main() {
  late AppDatabase db;
  late ExportService service;
  final files = <String, Uint8List>{};

  setUp(() async {
    db = openTestDatabase();
    files.clear();
    final container = testContainer(db);
    await container.read(demoSeederProvider).seed();
    service = ExportService(
      db,
      (name, bytes) async => files[name] = bytes,
      now: () => testNow,
    );
  });
  tearDown(() => db.close());

  SheetData sheet(String file, String name) =>
      XlsxReader.fromBytes(files[file]!).readSheet(name);

  test('file name', () async {
    expect(
      await service.exportWorkload(year),
      'Workload_Mr_Kalhara_Batangala_2026-10-29.xlsx',
    );
  });

  test('My Data_Entry reproduces the fixture hours (SPEC §13)', () async {
    final name = await service.exportWorkload(year);
    final s = sheet(name, dataEntrySheet);

    expect(
      [for (var r = 5; r <= 12; r++) s.at('A', r).text],
      [
        'EE3202',
        'EC3202',
        'EC5204',
        'EC5406',
        'EC5207',
        'EC5207',
        'EC5208',
        'EC5204',
      ],
    );
    expect(s.at('G', 5).text, 'Mr. Kalhara Batangala');
    expect(s.at('H', 9).text, 'Second Examiner');
    expect(s.at('H', 10).text, 'Moderator');
    expect(s.at('D', 8).text, 'Project');

    // Inputs I–AI: the opening balances and the sample quiz.
    expect(s.at('AC', 5).value, 74);
    expect(s.at('AD', 5).value, 1);
    expect(s.at('AC', 6).value, 193);
    expect(s.at('X', 8).value, 200);
    expect(s.at('AE', 8).value, 50);
    expect(s.at('J', 11).value, 10);

    // Hours AJ–AU per row and the total.
    final totals = [for (var r = 5; r <= 12; r++) s.at('AU', r).value as num];
    final expected = [7.4, 19.3, 0, 50.0, 0, 2.0, 1.0, 0];
    for (final (i, value) in totals.indexed) {
      expect(value, closeTo(expected[i], 1e-9), reason: 'row ${i + 5}');
    }
    expect(s.at('AQ', 6).value as num, closeTo(19.3, 1e-9));
    expect(s.at('AL', 10).value, 2);
    expect(s.at('A', 13).text, 'TOTAL');
    expect(s.at('AU', 13).value as num, closeTo(79.7, 1e-9));
    expect(s.at('AP', 13).value as num, closeTo(40.0, 1e-9));
    expect(s.at('AQ', 13).value as num, closeTo(36.7, 1e-9));
  });

  test('header rows are identical to V10.1 Data_Entry rows 3–4', () async {
    final name = await service.exportWorkload(year);
    final ours = sheet(name, dataEntrySheet);
    final reference = XlsxReader.fromBytes(referenceBytes)
        .readSheet('Data_Entry');
    for (var c = 0; c <= columnIndex('AU'); c++) {
      for (final r in [3, 4]) {
        expect(
          ours.cell(r, c).value,
          reference.cell(r, c).value,
          reason: '${columnLetter(c)}$r',
        );
      }
    }
  });

  test('weighted Qs/paper is written at full precision', () async {
    final ec5208 = (await db.select(db.roleRows).get()).firstWhere(
      (r) => r.moduleCode == 'EC5208',
    );
    final entries = testContainer(db).read(entriesRepositoryProvider);
    for (final (papers, qpp) in [(40.0, 1.0), (38.0, 2.0)]) {
      await entries.add(
        roleRowId: ec5208.id,
        date: testToday,
        activity: Activity.examMarking,
        subtype: Subtype.essay,
        count: papers,
        questionsPerPaper: qpp,
      );
    }
    final s = sheet(await service.exportWorkload(year), dataEntrySheet);
    expect(s.at('AC', 11).value, 78);
    expect(s.at('AD', 11).value, 116 / 78);
    expect(s.at('AQ', 11).value as num, closeTo(11.6, 1e-9));
  });

  test('evidence log: complete entries only, no time spent', () async {
    final name = await service.exportWorkload(year);
    final s = sheet(name, evidenceSheet);
    expect([
      for (var c = 0; c < evidenceHeaders.length; c++) s.cell(1, c).text,
    ], evidenceHeaders);
    expect(
      evidenceHeaders.any((h) => h.toLowerCase().contains('spent')),
      isFalse,
    );
    // 4 opening balances + the sample quiz; the draft is not evidence.
    expect(s.isRowEmpty(6), isFalse);
    expect(s.isRowEmpty(7), isTrue);
    final quizRow = [for (var r = 2; r <= 6; r++) r]
        .firstWhere((r) => s.at('E', r).text == 'Prepared CA');
    expect(s.at('B', quizRow).text, 'EC5208');
    expect(s.at('F', quizRow).text, 'Quiz');
    expect(s.at('I', quizRow).value as num, closeTo(1.0, 1e-9));
    expect(s.at('J', quizRow).text, 'Quiz 2');
  });

  test('other work and PG supervision sheets', () async {
    final name = await service.exportWorkload(year);
    final other = sheet(name, otherWorkSheet);
    expect(other.at('A', 2).text, '2026-10-28');
    expect(other.at('B', 2).text, 'Research');
    expect(other.at('C', 2).text, 'Paper reading');
    expect(other.isRowEmpty(1), isFalse);
    expect(other.at('D', 1).isEmpty, isTrue, reason: 'no time spent column');

    final pg = sheet(name, pgSheet);
    expect(pg.at('A', 2).text, '2025/26');
    expect(pg.at('B', 2).value, 0);
  });

  test('evidence export has only the evidence sheet', () async {
    final name = await service.exportEvidence(year);
    expect(name, 'Evidence_Mr_Kalhara_Batangala_2026-10-29.xlsx');
    final reader = XlsxReader.fromBytes(files[name]!);
    expect(reader.sheetNames, [evidenceSheet]);
  });

  test('a period limits the rows\' inputs, not the rows', () async {
    final name = await service.exportWorkload(
      const ReportPeriod(label: 'Nov', from: '2026-11-01'),
    );
    final s = sheet(name, dataEntrySheet);
    expect(s.at('A', 12).text, 'EC5204', reason: 'all 8 rows still listed');
    expect(
      s.at('AU', 13).value as num,
      closeTo(2.0, 1e-9),
      reason: 'Moderator',
    );
  });
}
