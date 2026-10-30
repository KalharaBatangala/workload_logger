import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/workbook/workbook_parser.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/roll_up.dart';
import 'package:workload_logger/domain/summary.dart';

import '../../domain/fixtures.dart';
import 'xlsx_reader_test.dart' show referenceBytes;

const owner = 'Mr. Kalhara Batangala';

void main() {
  late ParsedWorkbook parsed;
  setUpAll(() => parsed = parseWorkbook(referenceBytes));

  group('reference workbook V10.1', () {
    test('every rate is found, equal to the defaults, with no warnings', () {
      expect(parsed.rateWarnings, isEmpty);
      for (final key in RateKey.values.where((k) => k.isInAdminConfig)) {
        expect(parsed.rates.isDefault(key), isFalse, reason: key.name);
        expect(
          parsed.rates.hours(key),
          closeTo(key.defaultHours, 1e-12),
          reason: key.name,
        );
      }
      expect(parsed.rates, RateSet.defaults());
    });

    test('Staff_List has 75 names, the owner among them', () {
      expect(parsed.staffNames, hasLength(75));
      expect(parsed.staffNames.first, 'Dr. Anuradha Mendis');
      expect(parsed.staffNames, contains(owner));
    });

    test('the owner has the 8 role rows of SPEC §3.3', () {
      final rows = parsed.rowsFor(owner);
      expect(rows.map((r) => r.sheetRow), [
        for (final fixture in ownerRows) fixture.sheetRow,
      ]);
      for (final (i, row) in rows.indexed) {
        final fixture = ownerRows[i];
        expect(row.info.moduleCode, fixture.info.moduleCode);
        expect(row.info.batch, fixture.info.batch);
        expect(row.info.moduleName, fixture.info.moduleName);
        expect(row.info.moduleType, fixture.info.moduleType);
        expect(row.info.role, fixture.info.role);
        expect(row.info.students, fixture.info.students);
        expect(row.inputs, fixture.inputs, reason: '${row.sheetRow}');
      }
    });

    test('opening balances reproduce 78.7 h (SPEC §13)', () {
      final rows = parsed.rowsFor(owner);
      final summary = summarize(
        {for (final row in rows) row.sheetRow: row.info},
        {for (final row in rows) row.sheetRow: inputsToEntries(row.inputs)},
        parsed.rates,
      );
      expect(summary.total.total, closeTo(78.7, 1e-9));
      expect(summary.total[Category.examMarking], closeTo(36.7, 1e-9));
    });

    test('row 914 (Industrial Training, no module code) is skipped', () {
      expect(parsed.skippedFor(owner).map((s) => s.sheetRow), [914]);
    });

    test('"Coordinated" module type (row 402) is read as Taught', () {
      final row = parsed.rows.firstWhere((r) => r.sheetRow == 402);
      expect(row.info.moduleType, ModuleType.taught);
      expect(row.info.role, Role.coordinator);
    });

    test('PG supervision counts', () {
      expect(parsed.pgStudentsFor('Dr. Kushan Sudheera'), 4);
      expect(parsed.pgStudentsFor(owner), 0);
      expect(parsed.pgStudentsFor('Nobody'), 0);
    });

    test('names match after trimming and collapsing whitespace', () {
      expect(parsed.rowsFor('  Mr.  Kalhara   Batangala '), hasLength(8));
    });
  });

  test('academic year hint from the teacher-list dates', () {
    expect(parsed.academicYearHint, '2025/26');
  });

  test('display names', () {
    expect(displayNameFrom(owner), 'Kalhara');
    expect(displayNameFrom('Dr. C.K.W. Seneviratne'), 'Seneviratne');
    expect(displayNameFrom('Prof. Dimuthu Darshana (VL)'), 'Dimuthu');
    expect(displayNameFrom('Ms. Yugani Gamlath'), 'Yugani');
  });
}
