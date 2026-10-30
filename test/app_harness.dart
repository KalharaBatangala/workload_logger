import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/app.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/demo_seed.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/features/reminders/notification_service.dart';
import 'package:workload_logger/features/reminders/providers.dart';

import 'data/test_database.dart';

final _openDatabases = <AppDatabase>[];

/// Like [testWidgets], for tests that start the app with [pumpApp].
///
/// When the widget tree goes away, drift closes its query streams on a
/// zero-length timer. Flutter checks for pending timers straight after the
/// test body, so the app is unmounted and that timer is allowed to fire
/// inside the body.
void testApp(String description, Future<void> Function(WidgetTester) body) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      for (final db in _openDatabases) {
        await db.close();
      }
      _openDatabases.clear();
    }
  });
}

/// Starts the whole app on an in-memory database with the fixed test clock.
/// With [onboarded], a finished profile exists so the app opens on Today;
/// with [demo], the demo data is loaded as well (78.7 h + a 1.0 h quiz).
/// Use inside [testApp].
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  bool onboarded = true,
  bool demo = false,
  FakeNotificationService? notifications,
  List<Override> overrides = const [],
}) async {
  // The phone frame of the designs: 390 × 844 logical pixels.
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final db = openTestDatabase();
  _openDatabases.add(db);
  if (demo) {
    await DemoSeeder(db, now: () => testNow).seed();
    await (db.update(db.profile))
        .write(const ProfileCompanion(onboardingDone: Value(true)));
  } else if (onboarded) {
    await db
        .into(db.profile)
        .insert(
          ProfileCompanion.insert(
            staffName: 'Mr. Kalhara Batangala',
            displayName: 'Kalhara',
            academicYearLabel: '2025/26',
            onboardingDone: const Value(true),
          ),
        );
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => testNow),
        notificationServiceProvider.overrideWithValue(
          notifications ?? FakeNotificationService(),
        ),
        ...overrides,
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}

/// Like [WidgetTester.pumpAndSettle], but first lets drift deliver query
/// updates, which arrive on zero-length timers rather than as frames.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.pump(Duration.zero);
  }
  await tester.pumpAndSettle();
}

/// Lists only build what is near the screen, so bring [finder] into the
/// tree first (scrolling down if needed), then make sure it is visible.
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

/// [reveal]s [finder] and taps it.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  await reveal(tester, finder);
  await tester.tap(finder);
  await settle(tester);
}
