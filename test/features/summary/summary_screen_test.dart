import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/data/workbook/export_builder.dart';
import 'package:workload_logger/data/workbook/xlsx_reader.dart';

import '../../app_harness.dart';

Future<void> openSummary(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppBottomBar),
      matching: find.text('Summary'),
    ),
  );
  await settle(tester);
}

void main() {
  testApp('hero, categories and role rows (SPEC §8.7)', (tester) async {
    await pumpApp(tester, demo: true);
    await openSummary(tester);

    expect(find.text('CREDITED THIS ACADEMIC YEAR'), findsOneWidget);
    expect(find.text('79.7'), findsOneWidget);
    expect(
      find.text('Plus 2 h of other work, kept outside the model'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Period: 2025/26. Change'), findsOneWidget);
    expect(find.bySemanticsLabel('CA Marking, 40.0 h'), findsOneWidget);
    expect(find.bySemanticsLabel('Exam Marking, 36.7 h'), findsOneWidget);
    await reveal(tester, find.text('Industrial Training'));
    await reveal(tester, find.text('50.0 h'));
    await reveal(tester, find.text('Second Examiner · 24th'));
    expect(find.text('Nothing yet'), findsNWidgets(3));
  });

  testApp('tap a role row to see what the workbook receives', (tester) async {
    await pumpApp(tester, demo: true);
    await openSummary(tester);
    await tapOn(tester, find.text('7.4 h'));

    expect(find.text('Role row'), findsOneWidget);
    expect(
      find.text('End exam marking — Essay: papers marked'),
      findsOneWidget,
    );
    expect(find.text('74'), findsOneWidget);
    expect(find.text('AQ'), findsOneWidget);
    expect(find.text('7.4 h'), findsNWidgets(2)); // AQ and the total
  });

  testApp('Export shares the Data_Entry workbook', (tester) async {
    final files = <String, Uint8List>{};
    await pumpApp(
      tester,
      demo: true,
      overrides: [
        exportSinkProvider.overrideWithValue(
          (name, bytes) async => files[name] = bytes,
        ),
      ],
    );
    await openSummary(tester);
    await tester.runAsync(() async {
      await tapOn(tester, find.text('Export my Data_Entry rows (.xlsx)'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await settle(tester);

    expect(files.keys, ['Workload_Mr_Kalhara_Batangala_2026-10-29.xlsx']);
    final sheet = XlsxReader.fromBytes(files.values.single)
        .readSheet(dataEntrySheet);
    expect(sheet.at('AU', 13).value as num, closeTo(79.7, 1e-9));
  });

  testApp('Close this period starts the next year', (tester) async {
    await pumpApp(tester, demo: true);
    await openSummary(tester);
    await tapOn(tester, find.byTooltip('More'));
    await tapOn(tester, find.text('Close this period'));
    expect(find.text('Close 2025/26?'), findsOneWidget);
    expect(find.widgetWithText(TextField, '2026/27'), findsOneWidget);

    await tapOn(tester, find.text('Close 2025/26'));
    expect(find.text('2025/26 is closed. 2026/27 has begun.'), findsOneWidget);
    expect(find.bySemanticsLabel('Period: 2026/27. Change'), findsOneWidget);
    expect(find.text('2.0'), findsOneWidget, reason: 'Moderator hours only');
  });
}
