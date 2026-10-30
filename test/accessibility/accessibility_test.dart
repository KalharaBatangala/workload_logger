import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';

import '../app_harness.dart';

/// Android's accessibility guidelines on whatever is on screen: 48 dp tap
/// targets (SPEC asks ≥ 44), a label on everything tappable, readable
/// contrast.
Future<void> checkGuidelines(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

Future<void> openTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(AppBottomBar), matching: find.text(label)),
  );
  await settle(tester);
}

/// Screens to check, each reached from Today with demo data.
final screens = <String, Future<void> Function(WidgetTester)>{
  'Today': (_) async {},
  'History': (t) => openTab(t, 'History'),
  'Summary': (t) => openTab(t, 'Summary'),
  'Setup': (t) => openTab(t, 'Setup'),
  'Role-row detail': (t) async {
    await openTab(t, 'Summary');
    await tapOn(t, find.text('7.4 h'));
  },
  'Log step 1': (t) async {
    await t.tap(find.byTooltip('Log work'));
    await settle(t);
  },
  'Log step 2': (t) async {
    await t.tap(find.byTooltip('Log work'));
    await settle(t);
    await tapOn(t, find.text('Mobile Application Development').last);
  },
  'Log step 3': (t) async {
    await t.tap(find.byTooltip('Log work'));
    await settle(t);
    await tapOn(t, find.text('Mobile Application Development').last);
    await tapOn(t, find.text('Prepared CA'));
  },
  'Saved': (t) async {
    await t.tap(find.byTooltip('Log work'));
    await settle(t);
    await tapOn(t, find.text('Mobile Application Development').last);
    await tapOn(t, find.text('Prepared CA'));
    await tapOn(t, find.bySemanticsLabel('Set to 10'));
    await tapOn(t, find.text('Save'));
  },
};

void main() {
  for (final MapEntry(key: name, value: open) in screens.entries) {
    testApp('$name meets the accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, demo: true);
      await open(tester);
      await checkGuidelines(tester);
      semantics.dispose();
    });

    testApp('$name lays out at 1.3× text size', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpApp(tester, demo: true);
      await open(tester);
      // Overflows are reported as exceptions; there must be none.
      expect(tester.takeException(), isNull);
    });
  }

  testApp('onboarding meets the accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester, onboarded: false);
    await checkGuidelines(tester);
    semantics.dispose();
  });

  testApp('onboarding lays out at 1.3× text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(tester, onboarded: false);
    expect(tester.takeException(), isNull);
  });
}
