import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/repositories/entries_repository.dart';
import 'package:workload_logger/data/repositories/periods_repository.dart';
import 'package:workload_logger/domain/enums.dart';

import '../../app_harness.dart';
import '../../data/test_database.dart' show testNow, testToday;

Future<void> openHistory(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppBottomBar),
      matching: find.text('History'),
    ),
  );
  await settle(tester);
}

Future<int> ec3202(AppDatabase db) async => (await db.select(db.roleRows).get())
    .firstWhere((r) => r.moduleCode == 'EC3202')
    .id;

void main() {
  testApp('days, draft card and other work (SPEC §8.6)', (tester) async {
    await pumpApp(tester, demo: true);
    await openHistory(tester);

    expect(find.text('Drafts · 1'), findsOneWidget);
    expect(find.text('DRAFT · NEEDS A COUNT'), findsOneWidget);
    expect(find.text('EC5406 · Students evaluated'), findsOneWidget);
    expect(
      find.text(
        'From your quick note: "panel evaluation, software group project"',
      ),
      findsOneWidget,
    );
    await reveal(tester, find.text('TODAY · THU 29 OCT'));
    await reveal(tester, find.text('Prepared CA · Quiz'));
    await reveal(tester, find.text('YESTERDAY · WED 28 OCT'));
    await reveal(tester, find.text('Research · paper reading'));
    expect(find.text('2 h spent · not in the workload model'), findsOneWidget);
  });

  testApp('Drafts tab; Discard and Undo', (tester) async {
    await pumpApp(tester, demo: true);
    await openHistory(tester);
    await tapOn(tester, find.text('Drafts · 1'));
    expect(find.text('Prepared CA · Quiz'), findsNothing);

    await tapOn(tester, find.text('Discard'));
    expect(find.text('Draft discarded'), findsOneWidget);
    expect(find.text('Drafts · 0'), findsOneWidget);
    expect(find.text('No drafts. Everything is complete.'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(find.text('Drafts · 1'), findsOneWidget);
  });

  testApp('Finish entry opens the draft for editing', (tester) async {
    await pumpApp(tester, demo: true);
    await openHistory(tester);
    await tapOn(tester, find.text('Finish entry'));
    expect(find.text('Edit entry'), findsOneWidget);
    expect(find.text('Students evaluated'), findsOneWidget);
  });

  testApp('delete an entry from its edit screen, then Undo', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openHistory(tester);
    await tapOn(tester, find.text('Prepared CA · Quiz'));
    await tapOn(tester, find.byTooltip('Delete entry'));

    expect(find.text('History'), findsOneWidget);
    expect(find.text('Entry deleted'), findsOneWidget);
    expect(find.text('Prepared CA · Quiz'), findsNothing);
    final quiz = await (db.select(
      db.entries,
    )..where((e) => e.activity.equalsValue(Activity.caPrep))).getSingle();
    expect(quiz.deletedAt, isNotNull);

    await tester.tap(find.text('Undo'));
    await settle(tester);
    await reveal(tester, find.text('Prepared CA · Quiz'));
  });

  testApp('delete other work, then Undo', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openHistory(tester);
    await tapOn(tester, find.text('Research · paper reading'));
    await tapOn(tester, find.text('Delete'));
    expect(find.text('Other work deleted'), findsOneWidget);
    expect(await db.select(db.otherWork).get(), isEmpty);

    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(await db.select(db.otherWork).get(), hasLength(1));
  });

  testApp('entries in a closed period are read-only', (tester) async {
    final db = await pumpApp(tester, demo: true);
    final periods = PeriodsRepository(db, now: () => testNow);
    await periods.close(
      await periods.create(
        label: '2025/26',
        startDate: '2025-08-01',
        endDate: testToday,
      ),
    );
    await openHistory(tester);
    await tapOn(tester, find.text('Prepared CA · Quiz'));

    expect(find.textContaining('This period is closed.'), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    expect(find.byTooltip('Delete entry'), findsNothing);
  });

  testApp('marking batches show a progress card', (tester) async {
    final db = await pumpApp(tester, demo: true);
    final entries = EntriesRepository(
      db,
      PeriodsRepository(db),
      now: () => testNow,
    );
    final row = await ec3202(db);
    for (final (papers, qpp) in [(40.0, 1.0), (38.0, 2.0)]) {
      await entries.add(
        roleRowId: row,
        date: testToday,
        activity: Activity.examMarking,
        subtype: Subtype.essay,
        count: papers,
        questionsPerPaper: qpp,
      );
    }
    await openHistory(tester);
    expect(find.text('EC3202 end-exam marking'), findsOneWidget);
    expect(find.text('30.9 h'), findsOneWidget);
    expect(find.text('271 papers · logged in 3 batches'), findsOneWidget);
  });
}
