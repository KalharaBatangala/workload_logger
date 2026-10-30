import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/core/widgets/app_scaffold.dart';

import '../app_harness.dart';

void main() {
  Finder tab(String label) => find.descendant(
    of: find.byType(AppBottomBar),
    matching: find.text(label),
  );

  testApp('starts on Today with the bottom bar', (tester) async {
    await pumpApp(tester);

    expect(find.text('Today arrives in M5.'), findsOneWidget);
    expect(find.byType(AppBottomBar), findsOneWidget);
    for (final label in ['Today', 'History', 'Log', 'Summary', 'Setup']) {
      expect(tab(label), findsOneWidget);
    }
  });

  testApp('tabs switch between the four main screens', (tester) async {
    await pumpApp(tester);

    for (final (label, milestone) in [
      ('History', 'M6'),
      ('Summary', 'M7'),
      ('Setup', 'M8'),
      ('Today', 'M5'),
    ]) {
      await tester.tap(tab(label));
      await tester.pumpAndSettle();
      expect(find.text('$label arrives in $milestone.'), findsOneWidget);
    }
  });

  testApp('Log opens full screen without the bottom bar and closes', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Log work'));
    await tester.pumpAndSettle();

    expect(find.text('Which module?'), findsOneWidget);
    expect(find.byType(AppBottomBar), findsNothing);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Which module?'), findsNothing);
    expect(find.byType(AppBottomBar), findsOneWidget);
  });

  testApp('the raised part of the Log button is tappable', (tester) async {
    await pumpApp(tester);
    final button = tester.getRect(find.byKey(const Key('logButton')));
    final barTop = tester.getRect(find.byType(AppBottomBar)).top;

    // Tap the button where it sits above the white bar.
    await tester.tapAt(Offset(button.center.dx, barTop + 8));
    await tester.pumpAndSettle();

    expect(find.text('Which module?'), findsOneWidget);
  });
}
