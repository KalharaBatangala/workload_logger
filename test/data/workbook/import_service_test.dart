import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/data/workbook/import_service.dart';
import 'package:workload_logger/data/workbook/workbook_parser.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';
import 'package:workload_logger/domain/workbook_mapping.dart';

import '../test_database.dart';
import 'xlsx_reader_test.dart' show referenceBytes;

const owner = 'Mr. Kalhara Batangala';
const fileName = 'DEIE_Workload_Model_V10_1.xlsx';

Matcher hours(double expected) => closeTo(expected, 1e-9);

void main() {
  late ParsedWorkbook parsed;
  late AppDatabase db;
  late ProviderContainer container;
  late ImportService service;

  setUpAll(() => parsed = parseWorkbook(referenceBytes));
  setUp(() {
    db = openTestDatabase();
    container = testContainer(db);
    service = container.read(importServiceProvider);
  });
  tearDown(() => db.close());

  Future<ImportResult> importOwner({
    ParsedWorkbook? workbook,
    bool replace = false,
  }) => service.apply(
    parsed: workbook ?? parsed,
    staffName: owner,
    academicYearLabel: '2025/26',
    fileName: fileName,
    replaceOpeningBalances: replace,
  );

  test('parse() runs in a background isolate', () async {
    final result = await ImportService.parse(referenceBytes);
    expect(result.rowsFor(owner), hasLength(8));
  });

  test('first import: 8 role rows, rates, opening balances = 78.7 h', () async {
    final result = await importOwner();
    expect(result.roleRows, 8);
    expect(result.openingBalanceEntries, 4); // AC/AD ×2, X, AE

    final profile = (await container.readNow(profileProvider.future))!;
    expect(profile.staffName, owner);
    expect(profile.displayName, 'Kalhara');
    expect(profile.isDemo, isFalse);
    expect(profile.onboardingDone, isFalse);
    expect(profile.workbookFileName, fileName);

    final rows = await container.readNow(roleRowsProvider.future);
    expect(rows.map((r) => r.sheetRow), [
      129,
      165,
      291,
      310,
      318,
      319,
      321,
      400,
    ]);
    expect(rows.every((r) => !r.isDemo && r.isActive), isTrue);

    final rates = await container.readNow(rateSetProvider.future);
    expect(rates, RateSet.defaults());
    expect(rates.isDefault(RateKey.caPrepQuiz), isFalse);

    final entries = await db.select(db.entries).get();
    expect(entries.every((e) => e.source == EntrySource.import), isTrue);
    expect(entries.every((e) => e.note == 'From workbook V10.1'), isTrue);
    expect(entries.every((e) => e.date == testToday), isTrue);

    final totals = await container.readNow(totalsProvider.future);
    expect(totals.year.total.total, hours(78.7));
    expect(totals.today, 0, reason: 'opening balances are not today\'s work');
  });

  test('demo data is replaced by a real import', () async {
    await container.read(demoSeederProvider).seed();
    await container.read(profileRepositoryProvider).setOnboardingDone();
    await importOwner();

    expect(await container.read(demoSeederProvider).hasDemoData(), isFalse);
    expect(await db.select(db.roleRows).get(), hasLength(8));
    expect(await db.select(db.otherWork).get(), isEmpty);
    final profile = (await container.readNow(profileProvider.future))!;
    expect(profile.isDemo, isFalse);
    expect(profile.onboardingDone, isTrue, reason: 'kept from before');
    final totals = await container.readNow(totalsProvider.future);
    expect(totals.year.total.total, hours(78.7));
  });

  group('re-import', () {
    Future<void> logQuiz() async {
      final ec5208 = (await container.readNow(roleRowsProvider.future))
          .firstWhere((r) => r.moduleCode == 'EC5208');
      await container
          .read(entriesRepositoryProvider)
          .add(
            roleRowId: ec5208.id,
            date: testToday,
            activity: Activity.caPrep,
            subtype: Subtype.quiz,
            count: 10,
          );
    }

    test('keeps manual entries and opening balances by default', () async {
      await importOwner();
      await logQuiz();
      final result = await importOwner();

      expect(result.openingBalanceEntries, 0);
      expect(result.deactivatedRoleRows, 0);
      expect(await db.select(db.roleRows).get(), hasLength(8));
      final totals = await container.readNow(totalsProvider.future);
      expect(totals.year.total.total, hours(79.7));
    });

    test('replaces opening balances only when asked', () async {
      await importOwner();
      await logQuiz();
      expect(await service.hasPreviousImport(), isTrue);

      final result = await importOwner(replace: true);
      expect(result.openingBalanceEntries, 4);
      final entries = await db.select(db.entries).get();
      expect(
        entries.where((e) => e.source == EntrySource.import),
        hasLength(4),
      );
      expect(
        entries.where((e) => e.source == EntrySource.manual),
        hasLength(1),
      );
      final totals = await container.readNow(totalsProvider.future);
      expect(totals.year.total.total, hours(79.7));
    });

    test(
      'rows missing from the new workbook are deactivated, entries kept',
      () async {
        await importOwner();
        await logQuiz();

        // A "newer" workbook where EC5208 is gone.
        final newer = ParsedWorkbook(
          rates: parsed.rates,
          rateWarnings: const [],
          staffNames: parsed.staffNames,
          rows: [
            for (final row in parsed.rows)
              if (row.info.moduleCode != 'EC5208') row,
          ],
          skippedRows: const [],
          pgStudents: const {},
        );
        final result = await importOwner(workbook: newer);
        expect(result.roleRows, 7);
        expect(result.deactivatedRoleRows, 1);

        // Read the repository directly: a paused provider may still hold
        // the list from before the re-import.
        final active = await container
            .read(roleRowsRepositoryProvider)
            .watchActive()
            .first;
        expect(active.map((r) => r.moduleCode), isNot(contains('EC5208')));
        final ec5208 = (await db.select(db.roleRows).get()).singleWhere(
          (r) => r.moduleCode == 'EC5208',
        );
        expect(ec5208.isActive, isFalse);
        final quiz = await (db.select(
          db.entries,
        )..where((e) => e.roleRowId.equals(ec5208.id))).get();
        expect(quiz, hasLength(1), reason: 'never deleted');
      },
    );

    test(
      'updated inputs in the workbook replace the opening balance',
      () async {
        await importOwner();
        final newer = ParsedWorkbook(
          rates: parsed.rates,
          rateWarnings: const [],
          staffNames: parsed.staffNames,
          rows: [
            for (final row in parsed.rows)
              row.sheetRow == 129
                  ? DataEntryRow(
                      sheetRow: 129,
                      staffName: row.staffName,
                      info: row.info,
                      credits: row.credits,
                      inputs: WorkbookInputs({
                        InputColumn.ac: 100,
                        InputColumn.ad: 1,
                      }),
                    )
                  : row,
          ],
          skippedRows: const [],
          pgStudents: const {},
        );
        await importOwner(workbook: newer, replace: true);
        final totals = await container.readNow(totalsProvider.future);
        expect(totals.year.total.total, hours(78.7 - 7.4 + 10.0));
      },
    );
  });

  test('a name with no rows is refused', () async {
    await expectLater(
      service.apply(
        parsed: parsed,
        staffName: 'Dr. Anuradha Mendis X',
        academicYearLabel: '2025/26',
        fileName: fileName,
      ),
      throwsA(isA<ImportException>()),
    );
    expect(await db.select(db.profile).get(), isEmpty);
  });

  test('PG supervision count stored for the year', () async {
    await service.apply(
      parsed: parsed,
      staffName: 'Dr. Kushan Sudheera',
      academicYearLabel: '2025/26',
      fileName: fileName,
    );
    final students = await container
        .read(pgSupervisionRepositoryProvider)
        .watchStudents('2025/26')
        .first;
    expect(students, 4);
  });

  test('opening balance note', () {
    expect(openingBalanceNote(fileName), 'From workbook V10.1');
    expect(openingBalanceNote('Model_v11.xlsx'), 'From workbook V11');
    expect(openingBalanceNote('workload.xlsx'), 'From workbook');
  });

  test('profile values are kept when the profile is saved again', () async {
    await importOwner();
    await container
        .read(profileRepositoryProvider)
        .setSubmissionDate('2026-11-30');
    await importOwner();
    final profile = await container.read(profileRepositoryProvider).get();
    expect(profile!.submissionDate, '2026-11-30');
    expect(
      await (db.select(db.profile)..where((p) => p.id.equals(1))).get(),
      hasLength(1),
    );
  });
}
