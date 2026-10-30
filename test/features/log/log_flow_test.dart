import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/features/log/providers.dart';
import 'package:workload_logger/features/log/screens/details_screen.dart';

import '../../app_harness.dart';

/// Scrolls [finder] into view and taps it.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await settle(tester);
}

Future<void> openLog(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Log work'));
  await settle(tester);
}

/// Opens Step 3 for [activity] on the module with [moduleName].
Future<void> openActivity(
  WidgetTester tester,
  String moduleName,
  String activity,
) async {
  await openLog(tester);
  await tapOn(tester, find.text(moduleName).last);
  await tapOn(tester, find.text(activity));
}

LogFlowState flowState(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(DetailsScreen)))
        .read(logFlowProvider);

Future<List<EntryRow>> entriesOf(AppDatabase db, Activity activity) =>
    (db.select(
      db.entries,
    )..where((e) => e.activity.equalsValue(activity))).get();

void main() {
  testApp('quiz 10 → "+1.0 h"; switching to Structured → "15.0 h"', (
    tester,
  ) async {
    await pumpApp(tester, demo: true);
    await openActivity(tester, 'Mobile Application Development', 'Prepared CA');

    // Quiz is pre-selected: the demo data logged a quiz on EC5208 before.
    expect(find.text('Questions prepared'), findsOneWidget);
    expect(find.text('Save as draft'), findsOneWidget, reason: 'count is 0');

    await tapOn(tester, find.bySemanticsLabel('Set to 10'));
    expect(find.text('10 × 6 min credited'), findsOneWidget);
    expect(find.text('1.0 h'), findsOneWidget);
    expect(find.text('+1.0 h'), findsOneWidget);

    await tapOn(tester, find.text('Structured'));
    expect(find.text('10 × 1.5 h credited'), findsOneWidget);
    expect(find.text('15.0 h'), findsOneWidget);
    expect(find.text('+15.0 h'), findsOneWidget);
  });

  testApp('save → Saved screen → Undo restores Step 3', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openActivity(tester, 'Mobile Application Development', 'Prepared CA');
    await tapOn(tester, find.bySemanticsLabel('Set to 10'));
    await tapOn(tester, find.text('Save'));

    expect(find.text('+1.0 h'), findsOneWidget);
    expect(find.text('credited to CA Prep'), findsOneWidget);
    expect(
      find.text('Prepared CA · Quiz · 10 questions · Today'),
      findsOneWidget,
    );
    expect(find.text('2.0 h'), findsWidgets, reason: 'today: demo quiz + this');
    expect(find.text('80.7 h'), findsOneWidget, reason: '79.7 + 1.0');

    await tapOn(tester, find.text('Undo'));
    expect(find.byType(DetailsScreen), findsOneWidget);
    expect(flowState(tester).count, 10);
    expect(flowState(tester).subtype, Subtype.quiz);
    final quizzes = await entriesOf(db, Activity.caPrep);
    expect(quizzes.where((e) => e.deletedAt != null), hasLength(1));
  });

  testApp('Done goes to Today; Log another starts over', (tester) async {
    await pumpApp(tester, demo: true);
    await openActivity(tester, 'Mobile Application Development', 'Prepared CA');
    await tapOn(tester, find.bySemanticsLabel('Set to 5'));
    await tapOn(tester, find.text('Save'));
    await tapOn(tester, find.text('Log another'));
    expect(find.text('Which module?'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await settle(tester);
    expect(find.byType(AppBottomBar), findsOneWidget);
  });

  testApp('no count → "Save as draft" stores a draft', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openActivity(tester, 'Mobile Application Development', 'Prepared CA');
    await tapOn(tester, find.text('Save as draft'));

    expect(find.text('Saved as draft'), findsOneWidget);
    final drafts = await (db.select(
      db.entries,
    )..where((e) => e.status.equalsValue(EntryStatus.draft))).get();
    expect(drafts, hasLength(2), reason: 'demo draft + this one');
  });

  testApp('Step 1 merges roles and batches per module', (tester) async {
    await pumpApp(tester, demo: true);
    await openLog(tester);
    expect(find.text('RECENT'), findsOneWidget);
    expect(find.text('Second Examiner + Moderator · 25th'), findsOneWidget);
    expect(find.text('Second Examiner · 24th and 25th'), findsOneWidget);
    expect(find.text('Teacher · 25th · Project'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testApp('EC5204: choose a batch first', (tester) async {
    await pumpApp(tester, demo: true);
    await openLog(tester);
    await tapOn(
      tester,
      find.text('Object Oriented Design Patterns and Principles'),
    );
    expect(find.text('24th batch'), findsOneWidget);
    expect(find.text('Papers second-marked'), findsNothing);

    await tapOn(tester, find.text('24th batch'));
    expect(find.text('Papers second-marked'), findsOneWidget);
  });

  testApp('EC5207: both roles, one tap moderation', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openLog(tester);
    await tapOn(tester, find.text('DevOps Engineering'));
    expect(find.text('SECOND EXAMINER'), findsOneWidget);
    expect(find.text('MODERATOR'), findsOneWidget);
    expect(find.text('Papers second-marked'), findsOneWidget);

    await tapOn(tester, find.text('Moderation done'));
    expect(find.text('Moderation recorded'), findsOneWidget);
    expect(await entriesOf(db, Activity.moderationDone), hasLength(1));
  });

  testApp('marking remembers type and questions per paper', (tester) async {
    await pumpApp(tester, demo: true);
    await openActivity(tester, 'Data Structures and Algorithms', 'Marked CA');
    await tapOn(tester, find.text('Structured'));
    expect(find.text('Questions per paper'), findsOneWidget);
    await tapOn(tester, find.bySemanticsLabel('Set to 20'));
    expect(find.text('Save as draft'), findsOneWidget, reason: 'no Qs/paper');
    await tapOn(tester, find.bySemanticsLabel('Set to 3'));
    expect(find.text('20 × 3 × 6 min credited'), findsOneWidget);
    expect(find.text('6.0 h'), findsOneWidget);
    await tapOn(tester, find.text('Save'));
    await tapOn(tester, find.text('Log another'));

    await tapOn(tester, find.text('Data Structures and Algorithms').last);
    await tapOn(tester, find.text('Marked CA'));
    expect(flowState(tester).subtype, Subtype.structured);
    expect(flowState(tester).questionsPerPaper, 3);
    expect(flowState(tester).count, 0);
  });

  testApp('other work is saved and never credited', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openLog(tester);
    await tapOn(tester, find.text('Work outside the model'));
    expect(find.text('Save other work'), findsOneWidget);

    await tapOn(tester, find.text('Student advising'));
    await tapOn(tester, find.text('1 h'));
    await tapOn(tester, find.text('Save other work'));

    expect(find.byType(AppBottomBar), findsOneWidget);
    expect(find.text('Saved as other work, not credited'), findsOneWidget);
    expect(await db.select(db.otherWork).get(), hasLength(2));
  });

  testApp('the header date chip changes the day', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openLog(tester);
    await tapOn(tester, find.bySemanticsLabel('Date: Today. Change'));
    await tapOn(tester, find.text('Yesterday'));
    expect(find.bySemanticsLabel('Date: Yesterday. Change'), findsOneWidget);

    await tapOn(tester, find.text('Mobile Application Development').last);
    await tapOn(tester, find.text('Lecture conducted'));
    await tapOn(tester, find.bySemanticsLabel('Set to 2'));
    expect(find.text('2 h conducted, credited as is'), findsOneWidget);
    await tapOn(tester, find.text('Save'));
    expect(find.text('Lecture conducted · 2 h · Yesterday'), findsOneWidget);

    final lectures = await entriesOf(db, Activity.lecture);
    expect(lectures.single.date, '2026-10-28');
  });
}
