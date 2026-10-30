import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/domain/enums.dart';

import '../../app_harness.dart';

/// Lists only build what is near the screen, so bring [finder] into the
/// tree first (scrolling down if needed), then tap it.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await reveal(tester, finder);
  await tester.tap(finder);
  await settle(tester);
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

/// Scrolls back to the hero and finds its big number.
Future<Finder> hero(WidgetTester tester, String value) async {
  await tester.scrollUntilVisible(
    find.text('CREDITED TODAY'),
    -300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  return find.text(value);
}

const card = 'EC5208 lecture, 10:00 – 12:00';

void main() {
  testApp('greeting and hero (SPEC §8.1)', (tester) async {
    await pumpApp(tester, demo: true);
    expect(find.text('Thursday, 29 October'), findsOneWidget);
    expect(find.text('Good evening, Kalhara'), findsOneWidget);
    expect(find.text('CREDITED TODAY'), findsOneWidget);
    expect(find.text('1.0'), findsOneWidget);
    expect(find.text('1 entry'), findsOneWidget);
    expect(find.text('1.0 h'), findsOneWidget); // this week
    expect(find.text('79.7 h'), findsOneWidget);
  });

  testApp('timetable card: Yes logs 2 h, Undo takes it back', (tester) async {
    await pumpApp(tester, demo: true);
    expect(find.text(card), findsOneWidget);

    await tapOn(tester, find.text('Yes, 2 h'));
    expect(find.text(card), findsNothing);
    expect(find.text('Logged 2 h lecture'), findsOneWidget);
    expect(find.text('Lecture conducted'), findsOneWidget);
    expect(await hero(tester, '3.0'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(find.text(card), findsOneWidget);
    expect(await hero(tester, '1.0'), findsOneWidget);
  });

  testApp('timetable card: No hides it', (tester) async {
    await pumpApp(tester, demo: true);
    await tapOn(tester, find.text('No'));
    expect(find.text(card), findsNothing);
    expect(await hero(tester, '1.0'), findsOneWidget);
  });

  testApp('timetable card: Other hours opens Step 3 for a lecture', (
    tester,
  ) async {
    await pumpApp(tester, demo: true);
    await tapOn(tester, find.text('Other hours'));
    expect(find.text('Lecture conducted'), findsOneWidget);
    expect(find.text('Hours'), findsOneWidget);
    expect(find.text('Enter the hours you taught'), findsOneWidget);
  });

  testApp('tap an entry to edit it', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await tapOn(tester, find.text('Prepared CA · Quiz'));
    expect(find.text('Edit entry'), findsOneWidget);

    await tapOn(tester, find.bySemanticsLabel('Set to 20'));
    await tapOn(tester, find.text('Save'));

    expect(find.byType(AppBottomBar), findsOneWidget);
    expect(find.text('Entry updated'), findsOneWidget);
    expect(await hero(tester, '2.0'), findsOneWidget);
    final quiz = await (db.select(
      db.entries,
    )..where((e) => e.activity.equalsValue(Activity.caPrep))).getSingle();
    expect(quiz.count, 20);
  });

  testApp('a draft can be finished from Today', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await reveal(tester, find.text('Draft'));
    await tapOn(tester, find.text('Marked CA · Project'));
    await tapOn(tester, find.bySemanticsLabel('Set to 50'));
    await tapOn(tester, find.text('Save'));

    final drafts = await (db.select(
      db.entries,
    )..where((e) => e.status.equalsValue(EntryStatus.draft))).get();
    expect(drafts, isEmpty);
    expect(await hero(tester, '11.0'), findsOneWidget); // 1.0 + 50 × 12 min
    expect(find.text('2 entries'), findsOneWidget);
  });

  testApp('quick log chip opens Step 2 for that module', (tester) async {
    await pumpApp(tester, demo: true);
    await tapOn(tester, find.bySemanticsLabel('Log work for EC5208'));
    expect(find.text('What did you do?'), findsOneWidget);
    expect(find.text('Mobile Application Development'), findsOneWidget);
  });

  testApp('zero-rows nudge lists 3 rows and opens Summary', (tester) async {
    await pumpApp(tester, demo: true);
    await tapOn(tester, find.text('3 of your role rows are still at zero'));
    expect(find.text('Summary arrives in M7.'), findsOneWidget);
  });

  testApp('empty state with nothing logged', (tester) async {
    await pumpApp(tester);
    expect(find.text('0 entries'), findsOneWidget);
    await reveal(tester, find.text('Nothing logged yet today.'));
    await reveal(tester, find.text('All modules'));
    expect(find.text('3 of your role rows are still at zero'), findsNothing);
  });
}
