import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/data/db/app_database.dart';
import 'package:workload_logger/data/providers.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/reminder_planner.dart';
import 'package:workload_logger/features/reminders/notification_service.dart';
import 'package:workload_logger/features/reminders/providers.dart';

import '../../app_harness.dart';
import '../../data/test_database.dart' as data;

/// Thursday 29 Oct 2026, 18:00: before tonight's evening reminder.
final thursdayEvening = DateTime(2026, 10, 29, 18);

void main() {
  group('scheduler (demo data)', () {
    late AppDatabase db;
    late ProviderContainer c;
    late FakeNotificationService fake;

    setUp(() async {
      db = data.openTestDatabase();
      fake = FakeNotificationService();
      c = ProviderContainer.test(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => thursdayEvening),
          notificationServiceProvider.overrideWithValue(fake),
        ],
      );
      await c.read(demoSeederProvider).seed();
    });
    tearDown(() => db.close());

    Future<void> finishOnboarding() =>
        c.read(profileRepositoryProvider).setOnboardingDone();

    Iterable<PlannedReminder> kind(ReminderKind k) =>
        fake.scheduled.where((r) => r.kind == k);

    test('nothing is scheduled before onboarding is finished', () async {
      await c.read(reminderSchedulerProvider).refresh();
      expect(fake.scheduled, isEmpty);
    });

    test('plans from the real data', () async {
      await finishOnboarding();
      await c.read(reminderSchedulerProvider).refresh();

      // Today already has the sample quiz: no evening reminder tonight.
      expect(kind(ReminderKind.evening).first.payload.date, '2026-10-30');
      // Thursday has entries: no catch-up about it on Friday morning.
      expect(
        kind(ReminderKind.morning).map((r) => r.payload.date),
        isNot(contains('2026-10-29')),
      );
      expect(
        kind(ReminderKind.weekly).first.body,
        'This week: 1 entry, 1.0 h credited. 1 draft waiting.',
      );
      // Next Thursday: the demo timetable's EC5208 lecture.
      final nextThursday = kind(ReminderKind.evening)
          .firstWhere((r) => r.payload.date == '2026-11-05');
      expect(nextThursday.body, startsWith('EC5208 lecture'));
      expect(nextThursday.actions, contains(ReminderAction.lectureDone));
    });

    test('submission reminder counts zero rows', () async {
      await finishOnboarding();
      await c.read(profileRepositoryProvider).setSubmissionDate('2026-11-10');
      await c.read(reminderSchedulerProvider).refresh();
      expect(
        kind(ReminderKind.submission).single.body,
        '3 role rows are still at zero.',
      );
    });

    test('changes re-plan automatically', () async {
      await finishOnboarding();
      c.read(reminderSyncProvider);
      await data.settle();
      final before = fake.replaceCalls;

      final evening = (await c
          .read(reminderSettingsRepositoryProvider)
          .byKey(ReminderKind.evening))!;
      await c
          .read(reminderSettingsRepositoryProvider)
          .save(evening.copyWith(enabled: false));
      await data.settle();

      expect(fake.replaceCalls, greaterThan(before));
      expect(kind(ReminderKind.evening), isEmpty);
    });
  });

  group('tapping reminders', () {
    ReminderTap tap(ReminderKind kind, String date, [ReminderAction? action]) =>
        ReminderTap(ReminderPayload(kind, date), action);

    testApp('Lecture done logs the slot as a lecture, with Undo', (
      tester,
    ) async {
      final fake = FakeNotificationService();
      final db = await pumpApp(tester, demo: true, notifications: fake);
      fake.tap(
        tap(ReminderKind.evening, '2026-10-29', ReminderAction.lectureDone),
      );
      await settle(tester);

      final lectures = await (db.select(
        db.entries,
      )..where((e) => e.activity.equalsValue(Activity.lecture))).get();
      expect(lectures.single.count, 2);
      expect(lectures.single.source, EntrySource.notification);
      expect(find.text('Lecture logged for Thursday'), findsOneWidget);
      // The timetable card on Today is answered too.
      expect(find.text('EC5208 lecture, 10:00 – 12:00'), findsNothing);
    });

    testApp('Nothing marks the day', (tester) async {
      final fake = FakeNotificationService();
      final db = await pumpApp(tester, demo: true, notifications: fake);
      fake.tap(tap(ReminderKind.morning, '2026-10-28', ReminderAction.nothing));
      await settle(tester);

      final review = await (db.select(
        db.dayReviews,
      )..where((d) => d.date.equals('2026-10-28'))).getSingle();
      expect(review.status, DayReviewStatus.nothingToLog);
      expect(find.text('Noted: nothing to log for Wednesday'), findsOneWidget);
    });

    testApp('the morning catch-up opens Step 1 dated yesterday', (
      tester,
    ) async {
      final fake = FakeNotificationService();
      await pumpApp(tester, demo: true, notifications: fake);
      fake.tap(tap(ReminderKind.morning, '2026-10-28', ReminderAction.logWork));
      await settle(tester);
      expect(find.text('Which module?'), findsOneWidget);
      expect(find.bySemanticsLabel('Date: Yesterday. Change'), findsOneWidget);
    });

    testApp('weekly → History, submission → Summary', (tester) async {
      final fake = FakeNotificationService();
      await pumpApp(tester, demo: true, notifications: fake);
      fake.tap(tap(ReminderKind.weekly, '2026-10-30'));
      await settle(tester);
      expect(find.text('All entries'), findsOneWidget);
      fake.tap(tap(ReminderKind.submission, '2026-11-07'));
      await settle(tester);
      expect(find.text('Your role rows'), findsOneWidget);
    });

    testApp('a tap that launched the app is handled at start', (tester) async {
      final fake = FakeNotificationService()
        ..pendingLaunchTap = tap(ReminderKind.evening, '2026-10-29');
      await pumpApp(tester, demo: true, notifications: fake);
      await settle(tester);
      expect(find.text('Which module?'), findsOneWidget);
    });
  });
}
