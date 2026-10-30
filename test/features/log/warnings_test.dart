import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/enums.dart';

import '../../app_harness.dart';

Future<void> openStep3(
  WidgetTester tester,
  String module,
  String activity,
) async {
  await tester.tap(find.byTooltip('Log work'));
  await settle(tester);
  await tapOn(tester, find.text(module).last);
  await tapOn(tester, find.text(activity));
}

void main() {
  testApp('more students than the module has: warned, still saved', (
    tester,
  ) async {
    final db = await pumpApp(tester, demo: true);
    // EC5406 has 200 students and the workbook already lists 200 evaluated.
    await openStep3(tester, 'Software Group Project', 'Marked CA');
    await tapOn(tester, find.bySemanticsLabel('Set to 20'));
    await reveal(
      tester,
      find.text('This makes 220 students for EC5406, which has 200 students.'),
    );

    await tapOn(tester, find.text('Save'));
    expect(find.text('+4.0 h'), findsOneWidget);
    final project = await (db.select(
      db.entries,
    )..where((e) => e.subtype.equalsValue(Subtype.project))).get();
    expect(project.where((e) => e.count == 20), hasLength(1));
  });

  testApp('the same entry again within 10 minutes: warned', (tester) async {
    await pumpApp(tester, demo: true);
    // The demo data logged "10 quiz questions" on EC5208 just now.
    await openStep3(tester, 'Mobile Application Development', 'Prepared CA');
    await tapOn(tester, find.bySemanticsLabel('Set to 10'));
    await reveal(
      tester,
      find.text('You logged the same just now. Saving again adds it twice.'),
    );
    await tapOn(tester, find.bySemanticsLabel('Set to 5'));
    expect(find.textContaining('You logged the same'), findsNothing);
  });
}
