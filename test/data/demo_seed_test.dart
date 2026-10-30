import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/domain/enums.dart';

import 'test_database.dart';

Matcher hours(double expected) => closeTo(expected, 1e-9);

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = openTestDatabase();
    container = testContainer(db);
  });
  tearDown(() => db.close());

  Future<void> seed() => container.read(demoSeederProvider).seed();

  test(
    'seeds the 8 role rows with opening balances: 79.7 h this year',
    () async {
      await seed();

      final rows = await container.readNow(roleRowsProvider.future);
      expect(rows, hasLength(8));
      expect(rows.every((r) => r.isDemo), isTrue);
      expect(rows.first.moduleCode, 'EE3202'); // workbook order

      final totals = await container.readNow(totalsProvider.future);
      final year = totals.year.total;
      expect(year[Category.caMarking], hours(40.0));
      expect(year[Category.examMarking], hours(36.7));
      expect(year[Category.moderator], hours(2.0));
      expect(year[Category.caPrep], hours(1.0));
      expect(year.total, hours(79.7));
    },
  );

  test(
    'today and this week count only logged work, not opening balances',
    () async {
      await seed();
      final totals = await container.readNow(totalsProvider.future);
      expect(totals.today, hours(1.0));
      expect(totals.week, hours(1.0));
    },
  );

  test('seeds a draft, other work and two timetable slots', () async {
    await seed();
    final drafts = await container.readNow(draftsProvider.future);
    expect(drafts, hasLength(1));
    expect(drafts.single.rawText, contains('panel evaluation'));

    expect(await db.select(db.otherWork).get(), hasLength(1));
    expect(await db.select(db.timetableSlots).get(), hasLength(2));

    final profile = await container.readNow(profileProvider.future);
    expect(profile!.staffName, 'Mr. Kalhara Batangala');
    expect(profile.isDemo, isTrue);
  });

  test('remove() takes away all demo data but keeps the defaults', () async {
    final seeder = container.read(demoSeederProvider);
    await seed();
    // Real work logged against a demo module also goes.
    final ec5208 = (await container.readNow(roleRowsProvider.future))
        .firstWhere((r) => r.moduleCode == 'EC5208');
    await container
        .read(entriesRepositoryProvider)
        .add(
          roleRowId: ec5208.id,
          date: testToday,
          activity: Activity.lecture,
          count: 2,
        );

    await seeder.remove();

    expect(await seeder.hasDemoData(), isFalse);
    expect(await db.select(db.roleRows).get(), isEmpty);
    expect(await db.select(db.entries).get(), isEmpty);
    expect(await db.select(db.otherWork).get(), isEmpty);
    expect(await db.select(db.timetableSlots).get(), isEmpty);
    expect(await db.select(db.profile).get(), isEmpty);
    expect(await db.select(db.rates).get(), isEmpty);
    expect(
      await db.select(db.otherCategories).get(),
      hasLength(defaultOtherCategories.length),
    );
    expect(await db.select(db.reminderSettings).get(), hasLength(4));
  });

  test('seeding twice does not duplicate', () async {
    await seed();
    await seed();
    expect(await db.select(db.roleRows).get(), hasLength(8));
    final totals = await container.readNow(totalsProvider.future);
    expect(totals.year.total.total, hours(79.7));
  });

  test('refuses to seed over a real profile', () async {
    await container
        .read(profileRepositoryProvider)
        .save(
          ProfileCompanion.insert(
            staffName: 'Mr. Kalhara Batangala',
            displayName: 'Kalhara',
            academicYearLabel: '2025/26',
          ),
        );
    await expectLater(seed(), throwsStateError);
    expect(await db.select(db.roleRows).get(), isEmpty);
  });

  test('totals update live when an entry is added', () async {
    await seed();
    // Keep the providers alive and listening, as a screen would.
    final sub = container.listen(totalsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.readNow(totalsProvider.future);

    final ec5208 = (await container.readNow(roleRowsProvider.future))
        .firstWhere((r) => r.moduleCode == 'EC5208');
    await container
        .read(entriesRepositoryProvider)
        .add(
          roleRowId: ec5208.id,
          date: testToday,
          activity: Activity.caPrep,
          subtype: Subtype.structured,
          count: 3,
        );
    await settle();

    final totals = await container.readNow(totalsProvider.future);
    expect(totals.today, hours(5.5));
    expect(totals.year.total.total, hours(84.2));
    expect(
      await container.readNow(todayEntriesProvider.future),
      hasLength(
        // 4 opening balances + quiz + draft + structured
        7,
      ),
    );
  });

  test('a closed period starts a new year: earlier entries drop out', () async {
    await seed();
    final sub = container.listen(totalsProvider, (_, _) {});
    addTearDown(sub.close);

    final periods = container.read(periodsRepositoryProvider);
    final id = await periods.create(
      label: '2025/26',
      startDate: '2025-08-01',
      endDate: testToday,
    );
    await periods.close(id);
    await settle();

    final totals = await container.readNow(totalsProvider.future);
    // Only the automatic Moderator hours remain for the new year.
    expect(totals.year.total.total, hours(2.0));
    expect(totals.today, 0);
    expect(
      await container.readNow(currentYearStartProvider.future),
      '2026-10-30',
    );
  });

  test('profile isDemo default is false for a real profile', () async {
    await container
        .read(profileRepositoryProvider)
        .save(
          ProfileCompanion.insert(
            staffName: 'x',
            displayName: 'x',
            academicYearLabel: '2025/26',
            onboardingDone: const Value(true),
          ),
        );
    final profile = await container.read(profileRepositoryProvider).get();
    expect(profile!.isDemo, isFalse);
    expect(profile.id, 1);
  });
}
