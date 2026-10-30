import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/features/today/providers.dart';

import '../../data/test_database.dart';

void main() {
  late AppDatabase db;

  Future<ProviderContainer> start({DateTime? now}) async {
    final container = testContainer(db, now: now);
    await container.read(demoSeederProvider).seed();
    // Keep the providers under test alive, as the Today screen would.
    container
      ..listen(timetableCardsProvider, (_, _) {})
      ..listen(totalsProvider, (_, _) {})
      ..listen(todayLoggedEntriesProvider, (_, _) {})
      ..listen(zeroRowsProvider, (_, _) {})
      ..listen(quickLogCodesProvider, (_, _) {});
    await settle();
    return container;
  }

  Future<List<TimetableCard>> cards(ProviderContainer c) async {
    await settle();
    return c.read(timetableCardsProvider.future);
  }

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('today\'s list leaves out opening balances', () async {
    final c = await start();
    final entries = c.read(todayLoggedEntriesProvider).value!;
    expect(
      entries.map((e) => e.activity),
      unorderedEquals([
        Activity.caPrep, // the sample quiz
        Activity.caMarking, // the sample draft
      ]),
    );
  });

  test('zero rows: the three Second Examiner rows (SPEC §8.1)', () async {
    final c = await start();
    final rows = c.read(zeroRowsProvider);
    expect(rows.map((r) => '${r.moduleCode} ${r.batch}'), [
      'EC5204 25th',
      'EC5207 25th',
      'EC5204 24th',
    ]);
    expect(rows.every((r) => r.role == Role.secondExaminer), isTrue);
  });

  test('quick log shows recently logged modules', () async {
    final c = await start();
    expect(
      c.read(quickLogCodesProvider),
      unorderedEquals(['EC5208', 'EC5406']),
    );
  });

  group('timetable cards (Thursday: EC5208 lecture 10:00–12:00)', () {
    test('one card, two hours', () async {
      final c = await start();
      final list = await cards(c);
      expect(list, hasLength(1));
      expect(list.single.row.moduleCode, 'EC5208');
      expect(list.single.isLab, isFalse);
      expect(list.single.hours, 2);
    });

    test(
      'Yes logs a 2 h lecture from the timetable; Undo reverses it',
      () async {
        final c = await start();
        final actions = c.read(todayActionsProvider);
        final yes = await actions.answerYes((await cards(c)).single);

        expect(await cards(c), isEmpty);
        final lectures = await (db.select(
          db.entries,
        )..where((e) => e.activity.equalsValue(Activity.lecture))).get();
        expect(lectures.single.count, 2);
        expect(lectures.single.source, EntrySource.timetable);
        expect((await c.read(totalsProvider.future)).today, closeTo(3.0, 1e-9));

        await actions.undoYes(yes);
        expect(await cards(c), hasLength(1));
        expect((await c.read(totalsProvider.future)).today, closeTo(1.0, 1e-9));
      },
    );

    test('No hides the card for the day', () async {
      final c = await start();
      await c.read(todayActionsProvider).answerNo((await cards(c)).single);
      expect(await cards(c), isEmpty);
    });

    test('a lecture logged by hand also answers it', () async {
      final c = await start();
      final ec5208 = (await c.read(roleRowsRepositoryProvider).getAll())
          .firstWhere((r) => r.moduleCode == 'EC5208');
      await c
          .read(entriesRepositoryProvider)
          .add(
            roleRowId: ec5208.id,
            date: testToday,
            activity: Activity.lecture,
            count: 1.5,
          );
      expect(await cards(c), isEmpty);
    });
  });

  test('Tuesday lab slot: Yes logs other work, nothing credited', () async {
    final c = await start(now: DateTime(2026, 10, 27, 18));
    final card = (await cards(c)).single;
    expect(card.isLab, isTrue);
    expect(card.hours, 3);

    final before = (await c.read(totalsProvider.future)).today;
    await c.read(todayActionsProvider).answerYes(card);
    final other = await db.select(db.otherWork).get();
    final lab = other.singleWhere((o) => o.date == '2026-10-27');
    expect(lab.spentMinutes, 180);
    final category = await (db.select(
      db.otherCategories,
    )..where((k) => k.id.equals(lab.categoryId))).getSingle();
    expect(category.name, labCategoryName);
    // Only the sample quiz (1.0 h) counts; the lab adds nothing.
    expect((await c.read(totalsProvider.future)).today, before);
  });

  test('slot length is rounded to half hours', () {
    TimetableCard card(String start, String end) => TimetableCard(
      slot: TimetableSlot(
        id: 1,
        roleRowId: 1,
        kind: SlotKind.lecture,
        weekday: 4,
        startTime: start,
        endTime: end,
        isDemo: false,
      ),
      row: RoleRow(
        id: 1,
        moduleCode: 'X',
        batch: '25th',
        moduleName: 'X',
        moduleType: ModuleType.taught,
        credits: 0,
        students: 0,
        role: Role.teacher,
        isActive: true,
        isDemo: false,
      ),
    );
    expect(card('08:00', '08:50').hours, 1);
    expect(card('08:00', '09:15').hours, 1.5); // 1.25 rounds up
    expect(card('08:00', '08:10').hours, 0.5);
  });
}
