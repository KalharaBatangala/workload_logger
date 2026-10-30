import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/repositories/entries_repository.dart';
import 'package:workload_logger/data/repositories/periods_repository.dart';
import 'package:workload_logger/data/repositories/rates_repository.dart';
import 'package:workload_logger/data/repositories/role_rows_repository.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/rates.dart';

import 'test_database.dart';

void main() {
  late AppDatabase db;
  late PeriodsRepository periods;
  late EntriesRepository entries;
  late RoleRowsRepository roleRows;

  setUp(() {
    db = openTestDatabase();
    periods = PeriodsRepository(db, now: () => testNow);
    entries = EntriesRepository(db, periods, now: () => testNow);
    roleRows = RoleRowsRepository(db);
  });
  tearDown(() => db.close());

  Future<int> addEc5208() => roleRows.upsert(
    RoleRowsCompanion.insert(
      moduleCode: 'EC5208',
      batch: '25th',
      moduleName: 'Mobile Application Development',
      moduleType: ModuleType.taught,
      role: Role.teacher,
      sheetRow: const Value(321),
    ),
  );

  Future<String> addQuiz(int rowId, {String date = testToday}) => entries.add(
    roleRowId: rowId,
    date: date,
    activity: Activity.caPrep,
    subtype: Subtype.quiz,
    count: 10,
  );

  group('database', () {
    test('creates default categories and reminder settings', () async {
      final categories = await db.select(db.otherCategories).get();
      expect(categories.map((c) => c.name), defaultOtherCategories);

      final reminders = await db.select(db.reminderSettings).get();
      final byKey = {for (final r in reminders) r.key: r};
      expect(byKey.keys, unorderedEquals(ReminderKind.values));
      expect(byKey[ReminderKind.evening]!.time, '20:30');
      expect(byKey[ReminderKind.morning]!.time, '07:30');
      expect(byKey[ReminderKind.weekly]!.weekday, DateTime.friday);
      expect(byKey[ReminderKind.weekly]!.time, '17:00');
    });

    test('foreign keys are enforced', () async {
      await expectLater(addQuiz(999), throwsA(isA<SqliteException>()));
    });
  });

  group('role rows', () {
    test('upsert by (code, batch, role) keeps the id and updates', () async {
      final id = await addEc5208();
      final again = await roleRows.upsert(
        RoleRowsCompanion.insert(
          moduleCode: 'EC5208',
          batch: '25th',
          moduleName: 'Mobile App Development (renamed)',
          moduleType: ModuleType.taught,
          role: Role.teacher,
        ),
      );
      expect(again, id);
      expect((await roleRows.byId(id))!.moduleName, contains('renamed'));
      expect(await roleRows.getAll(), hasLength(1));
    });

    test('a different role is a different row', () async {
      final teacher = await addEc5208();
      final moderator = await roleRows.upsert(
        RoleRowsCompanion.insert(
          moduleCode: 'EC5208',
          batch: '25th',
          moduleName: 'Mobile Application Development',
          moduleType: ModuleType.taught,
          role: Role.moderator,
        ),
      );
      expect(moderator, isNot(teacher));
    });

    test('watchActive hides inactive rows, ordered by sheet row', () async {
      final ec5208 = await addEc5208();
      await roleRows.upsert(
        RoleRowsCompanion.insert(
          moduleCode: 'EE3202',
          batch: '25th',
          moduleName: 'Data Structures and Algorithms',
          moduleType: ModuleType.taught,
          role: Role.teacher,
          sheetRow: const Value(129),
        ),
      );
      var active = await roleRows.watchActive().first;
      expect(active.map((r) => r.moduleCode), ['EE3202', 'EC5208']);

      await roleRows.setActive(ec5208, active: false);
      active = await roleRows.watchActive().first;
      expect(active.map((r) => r.moduleCode), ['EE3202']);
    });
  });

  group('entries', () {
    test('add, read back, and map to the domain', () async {
      final row = await addEc5208();
      final id = await addQuiz(row);

      final stored = (await entries.byId(id))!;
      expect(stored.date, testToday);
      expect(stored.status, EntryStatus.complete);
      expect(stored.source, EntrySource.manual);
      expect(stored.createdAt, testNow);

      final input = stored.toInput();
      expect(input.activity, Activity.caPrep);
      expect(input.subtype, Subtype.quiz);
      expect(input.count, 10);
      expect(input.counts, isTrue);
    });

    test('soft delete hides the entry; undo brings it back', () async {
      final row = await addEc5208();
      final id = await addQuiz(row);

      await entries.softDelete(id);
      expect(await entries.watchForDate(testToday).first, isEmpty);
      expect((await entries.byId(id))!.toInput().counts, isFalse);

      await entries.undoDelete(id);
      expect(await entries.watchForDate(testToday).first, hasLength(1));
    });

    test('drafts are listed separately and do not count', () async {
      final row = await addEc5208();
      await entries.add(
        roleRowId: row,
        date: testToday,
        activity: Activity.caMarking,
        subtype: Subtype.structured,
        status: EntryStatus.draft,
      );
      final drafts = await entries.watchDrafts().first;
      expect(drafts, hasLength(1));
      expect(drafts.single.toInput().counts, isFalse);

      await entries.finishDraft(
        drafts.single.copyWith(
          count: const Value(40),
          questionsPerPaper: const Value(3),
        ),
      );
      expect(await entries.watchDrafts().first, isEmpty);
    });

    test('range queries are inclusive and newest first', () async {
      final row = await addEc5208();
      for (final date in ['2026-10-25', '2026-10-26', '2026-10-29']) {
        await addQuiz(row, date: date);
      }
      final week = await entries
          .watchRange(from: '2026-10-26', to: '2026-11-01')
          .first;
      expect(week.map((e) => e.date), ['2026-10-29', '2026-10-26']);
      expect(await entries.watchRange().first, hasLength(3));
    });

    test(
      'entries in a closed period cannot be added, edited or deleted',
      () async {
        final row = await addEc5208();
        final id = await addQuiz(row, date: '2026-07-15');
        final period = await periods.create(
          label: '2025/26 Semester 2',
          startDate: '2026-03-01',
          endDate: '2026-07-31',
        );
        await periods.close(period);

        expect(await periods.isLocked('2026-07-15'), isTrue);
        expect(await periods.isLocked('2026-08-01'), isFalse);
        await expectLater(
          addQuiz(row, date: '2026-07-20'),
          throwsA(isA<PeriodLockedException>()),
        );
        await expectLater(
          entries.softDelete(id),
          throwsA(isA<PeriodLockedException>()),
        );
        final stored = (await entries.byId(id))!;
        await expectLater(
          entries.save(stored.copyWith(count: const Value(20))),
          throwsA(isA<PeriodLockedException>()),
        );
        // Moving an open entry into the closed period is refused too.
        final open = await addQuiz(row);
        await expectLater(
          entries.save(
            (await entries.byId(open))!.copyWith(date: '2026-07-01'),
          ),
          throwsA(isA<PeriodLockedException>()),
        );
      },
    );
  });

  group('periods', () {
    test('current year starts after the last closed period', () async {
      expect(await periods.watchCurrentYearStart().first, isNull);

      final open = await periods.create(
        label: 'open',
        startDate: '2026-08-01',
        endDate: '2027-01-31',
      );
      expect(await periods.watchCurrentYearStart().first, isNull);

      final closed = await periods.create(
        label: '2025/26',
        startDate: '2025-08-01',
        endDate: '2026-07-31',
      );
      await periods.close(closed);
      expect(await periods.watchCurrentYearStart().first, '2026-08-01');
      expect(open, isNot(closed));
    });
  });

  group('rates', () {
    test('nothing stored → all defaults, flagged as defaults', () async {
      final rates = await RatesRepository(db).getRateSet();
      expect(rates, RateSet.defaults());
      expect(rates.defaultKeys, RateKey.values.toSet());
    });

    test('replaceAll stores values and default flags', () async {
      final repo = RatesRepository(db);
      await repo.replaceAll(RateSet.from({RateKey.caPrepQuiz: 0.2}));

      final rates = await repo.watchRateSet().first;
      expect(rates.hours(RateKey.caPrepQuiz), 0.2);
      expect(rates.isDefault(RateKey.caPrepQuiz), isFalse);
      expect(rates.isDefault(RateKey.caPrepEssay), isTrue);
      expect(await db.select(db.rates).get(), hasLength(RateKey.values.length));
    });
  });
}
