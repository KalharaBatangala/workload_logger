import 'package:flutter_test/flutter_test.dart';
import 'package:workload_logger/domain/enums.dart';
import 'package:workload_logger/domain/reminder_planner.dart';

/// Thursday 29 October 2026, 18:00.
final thursday = DateTime(2026, 10, 29, 18);

const defaults = {
  ReminderKind.evening: ReminderConfig(enabled: true, time: '20:30'),
  ReminderKind.morning: ReminderConfig(enabled: true, time: '07:30'),
  ReminderKind.weekly: ReminderConfig(
    enabled: true,
    time: '17:00',
    weekday: DateTime.friday,
  ),
  ReminderKind.submission: ReminderConfig(enabled: true, time: '09:00'),
};

const ec5208Lecture = PlannerSlot(
  weekday: DateTime.thursday,
  kind: SlotKind.lecture,
  moduleCode: 'EC5208',
);

List<PlannedReminder> plan({
  DateTime? now,
  Map<ReminderKind, ReminderConfig> settings = defaults,
  List<PlannerSlot> slots = const [ec5208Lecture],
  Set<String> entries = const {},
  Set<String> reviewed = const {},
  String? submission,
  int weekEntries = 0,
  double weekHours = 0,
  int drafts = 0,
  int zeroRows = 0,
}) => planReminders(
  PlannerInputs(
    now: now ?? thursday,
    settings: settings,
    slots: slots,
    datesWithEntries: entries,
    reviewedDates: reviewed,
    submissionDate: submission,
    weekEntries: weekEntries,
    weekHours: weekHours,
    drafts: drafts,
    zeroRows: zeroRows,
  ),
);

Iterable<PlannedReminder> ofKind(List<PlannedReminder> p, ReminderKind k) =>
    p.where((r) => r.kind == k);

void main() {
  group('evening check-in', () {
    test('tonight at 20:30 with the timetable text and Lecture done', () {
      final tonight = ofKind(plan(), ReminderKind.evening).first;
      expect(tonight.at, DateTime(2026, 10, 29, 20, 30));
      expect(tonight.payload.date, '2026-10-29');
      expect(
        tonight.body,
        'EC5208 lecture was on your timetable. Did you also prepare, mark or '
        'evaluate anything?',
      );
      expect(tonight.actions, [
        ReminderAction.logWork,
        ReminderAction.lectureDone,
        ReminderAction.nothing,
      ]);
    });

    test('other days: plain question, no Lecture done', () {
      final friday = ofKind(plan(), ReminderKind.evening).elementAt(1);
      expect(friday.payload.date, '2026-10-30');
      expect(friday.body, 'Anything to log today?');
      expect(friday.actions, [ReminderAction.logWork, ReminderAction.nothing]);
    });

    test('skipped tonight once something is logged or reviewed', () {
      for (final p in [
        plan(entries: {'2026-10-29'}),
        plan(reviewed: {'2026-10-29'}),
      ]) {
        expect(
          ofKind(p, ReminderKind.evening).first.payload.date,
          '2026-10-30',
        );
      }
    });

    test('14 days ahead, past times dropped', () {
      expect(ofKind(plan(), ReminderKind.evening), hasLength(14));
      final late = plan(now: DateTime(2026, 10, 29, 22));
      expect(
        ofKind(late, ReminderKind.evening).first.payload.date,
        '2026-10-30',
      );
      expect(ofKind(late, ReminderKind.evening), hasLength(13));
    });
  });

  group('next-morning catch-up', () {
    test('Friday 07:30 about Thursday when Thursday has nothing', () {
      final first = ofKind(plan(), ReminderKind.morning).first;
      expect(first.at, DateTime(2026, 10, 30, 7, 30));
      expect(first.payload.date, '2026-10-29');
      expect(first.title, 'Nothing logged for Thursday');
    });

    test('not when the day has entries or a review', () {
      expect(
        ofKind(
          plan(entries: {'2026-10-29'}),
          ReminderKind.morning,
        ).first.payload.date,
        '2026-10-30',
      );
    });

    test('not after a weekend day without slots', () {
      final dates = ofKind(
        plan(),
        ReminderKind.morning,
      ).map((r) => r.payload.date);
      expect(dates, isNot(contains('2026-10-31'))); // Saturday
      expect(dates, isNot(contains('2026-11-01'))); // Sunday
      expect(dates, contains('2026-11-02')); // Monday
    });

    test('a weekend day with a slot is included', () {
      const saturdayLab = PlannerSlot(
        weekday: DateTime.saturday,
        kind: SlotKind.lab,
        moduleCode: 'EC5208',
      );
      final dates = ofKind(
        plan(slots: const [saturdayLab]),
        ReminderKind.morning,
      ).map((r) => r.payload.date);
      expect(dates, contains('2026-10-31'));
    });
  });

  group('weekly review', () {
    test('this Friday with current counts, later Fridays plain', () {
      final weekly = ofKind(
        plan(weekEntries: 4, weekHours: 7.5, drafts: 2),
        ReminderKind.weekly,
      ).toList();
      expect(weekly, hasLength(2));
      expect(weekly.first.at, DateTime(2026, 10, 30, 17));
      expect(
        weekly.first.body,
        'This week: 4 entries, 7.5 h credited. 2 drafts waiting.',
      );
      expect(weekly.last.body, 'Time for your weekly review.');
    });

    test('no drafts → no drafts sentence', () {
      final weekly = ofKind(
        plan(weekEntries: 1, weekHours: 1),
        ReminderKind.weekly,
      ).first;
      expect(weekly.body, 'This week: 1 entry, 1.0 h credited.');
    });
  });

  group('before submission', () {
    test('3 days before at 09:00 with the zero rows', () {
      final s = ofKind(
        plan(submission: '2026-11-10', zeroRows: 3),
        ReminderKind.submission,
      ).single;
      expect(s.at, DateTime(2026, 11, 7, 9));
      expect(s.body, '3 role rows are still at zero.');
    });

    test('none without a submission date or when already past', () {
      expect(ofKind(plan(), ReminderKind.submission), isEmpty);
      expect(
        ofKind(plan(submission: '2026-10-30'), ReminderKind.submission),
        isEmpty,
      );
    });
  });

  test('disabled reminders are not planned', () {
    final p = plan(
      settings: {
        ...defaults,
        ReminderKind.evening: const ReminderConfig(
          enabled: false,
          time: '20:30',
        ),
      },
    );
    expect(ofKind(p, ReminderKind.evening), isEmpty);
    expect(ofKind(p, ReminderKind.morning), isNotEmpty);
  });

  test('ids are unique and the list is in time order', () {
    final p = plan(submission: '2026-11-10');
    expect(p.map((r) => r.id).toSet(), hasLength(p.length));
    for (var i = 1; i < p.length; i++) {
      expect(p[i].at.isBefore(p[i - 1].at), isFalse);
    }
  });

  test('payload round-trips through JSON', () {
    const payload = ReminderPayload(ReminderKind.morning, '2026-10-29');
    final decoded = ReminderPayload.decode(payload.encode())!;
    expect(decoded.kind, ReminderKind.morning);
    expect(decoded.date, '2026-10-29');
    expect(ReminderPayload.decode('nonsense'), isNull);
  });
}
