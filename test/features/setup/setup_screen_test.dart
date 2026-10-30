import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/data/workbook/workbook_parser.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/features/onboarding/providers.dart';
import 'package:workload_logger/features/reminders/notification_service.dart';

import '../../app_harness.dart';
import '../../data/workbook/xlsx_reader_test.dart' show referenceBytes;

Future<void> openSetup(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppBottomBar),
      matching: find.text('Setup'),
    ),
  );
  await settle(tester);
}

void main() {
  testApp('sections render with demo data (SPEC §8.8)', (tester) async {
    await pumpApp(tester, demo: true);
    await openSetup(tester);

    expect(find.text('Demo data'), findsOneWidget);
    expect(
      find.text('8 role rows for you · rates from Admin_Config'),
      findsOneWidget,
    );
    expect(find.text('Thu 10:00 – 12:00'), findsOneWidget);
    expect(find.text('Tue 13:00 – 16:00'), findsOneWidget);
    await reveal(tester, find.text('Every day at 8:30 pm'));
    expect(find.text('7:30 am, only if yesterday is empty'), findsOneWidget);
    expect(find.text('Fridays at 5:00 pm'), findsOneWidget);
    await reveal(tester, find.text('Remove demo data'));
    expect(find.text('BACKUP'), findsNothing, reason: 'phase 2');
  });

  testApp('switching a reminder off re-plans without it', (tester) async {
    final fake = FakeNotificationService();
    final db = await pumpApp(tester, demo: true, notifications: fake);
    await openSetup(tester);
    await reveal(tester, find.text('Evening check-in'));
    expect(fake.scheduled.any((r) => r.kind == ReminderKind.evening), isTrue);

    await tester.tap(find.bySemanticsLabel('Evening check-in').last);
    await settle(tester);

    final evening = await (db.select(
      db.reminderSettings,
    )..where((r) => r.key.equalsValue(ReminderKind.evening))).getSingle();
    expect(evening.enabled, isFalse);
    expect(fake.scheduled.any((r) => r.kind == ReminderKind.evening), isFalse);
  });

  testApp('add a class slot, then delete it with Undo', (tester) async {
    final db = await pumpApp(tester, demo: true);
    await openSetup(tester);

    await tapOn(tester, find.text('Add a class slot'));
    await tapOn(tester, find.text('Mon'));
    await tapOn(tester, find.text('Add slot'));
    expect(await db.select(db.timetableSlots).get(), hasLength(3));
    expect(find.text('Mon 08:00 – 10:00'), findsOneWidget);

    await tapOn(tester, find.text('Mon 08:00 – 10:00'));
    await tapOn(tester, find.text('Delete slot'));
    expect(await db.select(db.timetableSlots).get(), hasLength(2));
    await tester.tap(find.text('Undo'));
    await settle(tester);
    expect(await db.select(db.timetableSlots).get(), hasLength(3));
  });

  testApp('PG students, categories and submission date', (tester) async {
    await pumpApp(tester, demo: true);
    await openSetup(tester);

    await tapOn(tester, find.text('Postgraduate supervision'));
    await tester.enterText(find.byType(TextField).last, '2');
    await tapOn(tester, find.text('OK'));
    expect(find.text('2 students'), findsOneWidget);

    await tapOn(tester, find.text('Submission date'));
    await tapOn(tester, find.text('OK'));
    expect(find.text('Thu 29 Oct'), findsOneWidget);

    await tapOn(tester, find.text('Other-work categories'));
    await tapOn(tester, find.text('Add a category'));
    await tester.enterText(find.byType(TextField).last, 'Reviewing papers');
    await tapOn(tester, find.text('OK'));
    expect(find.text('Reviewing papers'), findsOneWidget);
  });

  testApp('rates are listed read-only', (tester) async {
    await pumpApp(tester, demo: true);
    await openSetup(tester);
    await tapOn(tester, find.text('Demo data'));
    expect(find.text('Rates'), findsOneWidget);
    expect(find.text('Exam - MCQ'), findsOneWidget);
    expect(find.text('0.002 h'), findsOneWidget);
  });

  testApp('remove demo data returns to onboarding', (tester) async {
    await pumpApp(tester, demo: true);
    await openSetup(tester);
    await tapOn(tester, find.text('Remove demo data'));
    await tapOn(tester, find.text('Remove'));
    expect(find.text('Log your workload in seconds'), findsOneWidget);
  });

  testApp('load a newer workbook: first replaces demo, then asks', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      demo: true,
      overrides: [
        pickWorkbookProvider.overrideWithValue(
          () async =>
              (name: 'DEIE_Workload_Model_V10_1.xlsx', bytes: referenceBytes),
        ),
        parseWorkbookProvider.overrideWithValue(
          (bytes) async => parseWorkbook(bytes),
        ),
      ],
    );
    await openSetup(tester);

    await tapOn(tester, find.text('Load a newer workbook'));
    expect(find.text('Workbook loaded: 8 role rows'), findsOneWidget);
    expect(find.text('DEIE_Workload_Model_V10_1.xlsx'), findsOneWidget);
    final roleRows = await db.select(db.roleRows).get();
    expect(roleRows.every((r) => !r.isDemo), isTrue);

    await tapOn(tester, find.text('Load a newer workbook'));
    expect(find.text('Replace opening balances?'), findsOneWidget);
    await tapOn(tester, find.text('Keep'));
    expect(find.text('Workbook loaded: 8 role rows'), findsWidgets);
  });

  testApp('Today\'s bell opens Setup at Reminders', (tester) async {
    await pumpApp(tester, demo: true);
    await tester.tap(find.byTooltip('Reminder settings'));
    await settle(tester);
    // Visible without scrolling by hand.
    expect(find.text('Evening check-in').hitTestable(), findsOneWidget);
  });

  testApp('submission reminder: change date, then clear it', (tester) async {
    await pumpApp(tester, demo: true);
    await openSetup(tester);
    await tapOn(tester, find.text('Before submission'));
    await tapOn(tester, find.text('Change submission date'));
    await tapOn(tester, find.text('OK'));
    await reveal(tester, find.text('Thu 29 Oct'));

    await tapOn(tester, find.text('Before submission'));
    await tapOn(tester, find.text('Clear submission date'));
    await reveal(tester, find.text('Not set'));
  });
}
