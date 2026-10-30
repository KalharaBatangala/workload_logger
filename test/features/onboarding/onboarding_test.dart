import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/data/workbook/workbook_parser.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/features/onboarding/providers.dart';

import '../../app_harness.dart';
import '../../data/workbook/xlsx_reader_test.dart' show referenceBytes;

void main() {
  // The parser normally runs on a background isolate, which does not run
  // inside widget tests' fake clock; parse in place instead.
  final parseInPlace = parseWorkbookProvider.overrideWithValue(
    (bytes) async => parseWorkbook(bytes),
  );

  testApp('a fresh install opens onboarding', (tester) async {
    await pumpApp(tester, onboarded: false);
    expect(find.text('Log your workload in seconds'), findsOneWidget);
    expect(find.byType(AppBottomBar), findsNothing);
  });

  testApp('a finished profile opens Today', (tester) async {
    await pumpApp(tester);
    expect(find.byType(AppBottomBar), findsOneWidget);
    expect(find.text('Log your workload in seconds'), findsNothing);
  });

  testApp('demo path: welcome → reminder time → Today', (tester) async {
    final db = await pumpApp(tester, onboarded: false);

    await tester.tap(find.text('Try with demo data'));
    await tester.pumpAndSettle();
    expect(find.text('When should we remind you?'), findsOneWidget);
    expect(find.text('8:30 pm'), findsOneWidget);
    expect(find.text('Step 3 of 3'), findsOneWidget);

    await tester.tap(find.text('Finish'));
    await settle(tester);

    expect(find.byType(AppBottomBar), findsOneWidget);
    expect(find.text('Today arrives in M5.'), findsOneWidget);
    final profile = await db.select(db.profile).getSingle();
    expect(profile.isDemo, isTrue);
    expect(profile.onboardingDone, isTrue);
  });

  testApp('workbook path: load → pick name → preview → import → Today', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      onboarded: false,
      overrides: [
        parseInPlace,
        pickWorkbookProvider.overrideWithValue(
          () async =>
              (name: 'DEIE_Workload_Model_V10_1.xlsx', bytes: referenceBytes),
        ),
      ],
    );

    await tester.tap(find.text('Load my workbook'));
    await tester.pumpAndSettle();
    expect(find.text('Step 1 of 3'), findsOneWidget);

    await tester.tap(find.text('Choose .xlsx file'));
    await tester.pumpAndSettle();
    expect(find.text('Which one is you?'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'kalhara');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mr. Kalhara Batangala'));
    await tester.pumpAndSettle();

    expect(find.text('8 role rows for you'), findsOneWidget);
    expect(find.text('78.7 h already in the workbook'), findsOneWidget);
    expect(find.text('Row 914 skipped: no module code'), findsOneWidget);
    expect(find.widgetWithText(TextField, '2025/26'), findsOneWidget);

    await tester.ensureVisible(find.text('Use this workbook'));
    await tester.tap(find.text('Use this workbook'));
    await tester.pumpAndSettle();
    expect(find.text('When should we remind you?'), findsOneWidget);

    await tester.tap(find.text('Finish'));
    await settle(tester);
    expect(find.byType(AppBottomBar), findsOneWidget);

    final profile = await db.select(db.profile).getSingle();
    expect(profile.staffName, 'Mr. Kalhara Batangala');
    expect(profile.academicYearLabel, '2025/26');
    expect(profile.isDemo, isFalse);
    expect(await db.select(db.roleRows).get(), hasLength(8));
    final evening = await (db.select(
      db.reminderSettings,
    )..where((r) => r.key.equalsValue(ReminderKind.evening))).getSingle();
    expect(evening.time, '20:30');
  });

  testApp('a wrong file shows a plain error and stays on the step', (
    tester,
  ) async {
    await pumpApp(
      tester,
      onboarded: false,
      overrides: [
        parseInPlace,
        pickWorkbookProvider.overrideWithValue(
          () async => (name: 'notes.xlsx', bytes: Uint8List.fromList([1, 2])),
        ),
      ],
    );
    await tester.tap(find.text('Load my workbook'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose .xlsx file'));
    await tester.pumpAndSettle();

    expect(find.text('This is not an .xlsx file.'), findsOneWidget);
    expect(find.text('Which one is you?'), findsNothing);
  });

  testApp('cancelling the file picker changes nothing', (tester) async {
    await pumpApp(
      tester,
      onboarded: false,
      overrides: [pickWorkbookProvider.overrideWithValue(() async => null)],
    );
    await tester.tap(find.text('Load my workbook'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose .xlsx file'));
    await tester.pumpAndSettle();
    expect(find.text('Load the workload workbook'), findsOneWidget);
    expect(find.text('No file chosen yet'), findsOneWidget);
  });
}
