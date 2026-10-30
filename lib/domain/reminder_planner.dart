/// Which reminders to schedule (SPEC §9). Pure Dart.
///
/// Android cannot skip a repeating alarm on some days, so the app plans
/// one-shot notifications for the coming days and re-plans whenever
/// something changes (app start, every save, settings).
library;

import 'dart:convert';

import 'dates.dart';
import 'enums.dart';

/// A reminder's settings.
class ReminderConfig {
  const ReminderConfig({
    required this.enabled,
    required this.time,
    this.weekday,
  });

  final bool enabled;

  /// `HH:mm`.
  final String time;

  /// Weekly reminder only: 1 = Monday … 7 = Sunday.
  final int? weekday;
}

/// A timetable slot, as the planner needs it.
class PlannerSlot {
  const PlannerSlot({
    required this.weekday,
    required this.kind,
    required this.moduleCode,
  });

  final int weekday;
  final SlotKind kind;
  final String moduleCode;
}

class PlannerInputs {
  const PlannerInputs({
    required this.now,
    required this.settings,
    this.slots = const [],
    this.datesWithEntries = const {},
    this.reviewedDates = const {},
    this.weekEntries = 0,
    this.weekHours = 0,
    this.drafts = 0,
    this.submissionDate,
    this.zeroRows = 0,
    this.days = 14,
  });

  final DateTime now;
  final Map<ReminderKind, ReminderConfig> settings;
  final List<PlannerSlot> slots;

  /// Dates (`yyyy-MM-dd`) that already have logged work.
  final Set<String> datesWithEntries;

  /// Dates marked "nothing to log" or reviewed.
  final Set<String> reviewedDates;

  /// This week so far (Monday–Sunday), for the weekly review text.
  final int weekEntries;
  final double weekHours;
  final int drafts;

  final String? submissionDate;

  /// Role rows still at zero, for the submission reminder.
  final int zeroRows;

  /// How many days ahead to plan.
  final int days;
}

/// What a notification's buttons do.
enum ReminderAction { logWork, lectureDone, nothing }

/// Data carried by a notification: what it is about and for which date.
class ReminderPayload {
  const ReminderPayload(this.kind, this.date);

  final ReminderKind kind;

  /// The day the reminder is about (yesterday for the morning catch-up).
  final String date;

  String encode() => jsonEncode({'kind': kind.name, 'date': date});

  static ReminderPayload? decode(String? text) {
    if (text == null) return null;
    try {
      final json = jsonDecode(text) as Map<String, dynamic>;
      return ReminderPayload(
        ReminderKind.values.byName(json['kind'] as String),
        json['date'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}

class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
    required this.payload,
    this.actions = const [],
  });

  final int id;

  /// Local wall-clock time.
  final DateTime at;
  final String title;
  final String body;
  final ReminderPayload payload;
  final List<ReminderAction> actions;

  ReminderKind get kind => payload.kind;
}

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Notification ids: one range per kind, offset by the day in the window.
const _idBase = {
  ReminderKind.evening: 1000,
  ReminderKind.morning: 2000,
  ReminderKind.weekly: 3000,
  ReminderKind.submission: 4000,
};

DateTime _at(String date, String hhmm) {
  final d = parseIsoDate(date);
  final parts = hhmm.split(':');
  return DateTime(
    d.year,
    d.month,
    d.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

String _hours(double h) => h.toStringAsFixed(1);

/// Plans the reminders for the next [PlannerInputs.days] days.
List<PlannedReminder> planReminders(PlannerInputs inputs) {
  final now = inputs.now;
  final today = isoDate(now);
  final planned = <PlannedReminder>[];

  void add(
    ReminderKind kind,
    int index,
    DateTime at,
    String title,
    String body,
    String aboutDate, [
    List<ReminderAction> actions = const [],
  ]) {
    if (!at.isAfter(now)) return; // past times are dropped
    planned.add(
      PlannedReminder(
        id: _idBase[kind]! + index,
        at: at,
        title: title,
        body: body,
        payload: ReminderPayload(kind, aboutDate),
        actions: actions,
      ),
    );
  }

  bool settled(String date) =>
      inputs.datesWithEntries.contains(date) ||
      inputs.reviewedDates.contains(date);

  List<PlannerSlot> slotsOn(String date) {
    final weekday = parseIsoDate(date).weekday;
    return [
      for (final s in inputs.slots)
        if (s.weekday == weekday) s,
    ];
  }

  // Evening check-in: every day; today only while nothing is logged.
  final evening = inputs.settings[ReminderKind.evening];
  if (evening != null && evening.enabled) {
    for (var i = 0; i < inputs.days; i++) {
      final date = addDays(today, i);
      if (date == today && settled(date)) continue;
      final slots = slotsOn(date);
      final hasLecture = slots.any((s) => s.kind == SlotKind.lecture);
      final body = slots.isEmpty
          ? 'Anything to log today?'
          : '${slots.map((s) => '${s.moduleCode} ${s.kind.name}').join(' and ')} '
                '${slots.length == 1 ? 'was' : 'were'} on your timetable. '
                'Did you also prepare, mark or evaluate anything?';
      add(
        ReminderKind.evening,
        i,
        _at(date, evening.time),
        'Anything to log today?',
        body,
        date,
        [
          ReminderAction.logWork,
          if (hasLecture) ReminderAction.lectureDone,
          ReminderAction.nothing,
        ],
      );
    }
  }

  // Next-morning catch-up about the day before.
  final morning = inputs.settings[ReminderKind.morning];
  if (morning != null && morning.enabled) {
    for (var i = 0; i < inputs.days; i++) {
      final day = addDays(today, i - 1); // the day the reminder is about
      final weekday = parseIsoDate(day).weekday;
      final relevant = weekday <= DateTime.friday || slotsOn(day).isNotEmpty;
      if (!relevant || settled(day)) continue;
      add(
        ReminderKind.morning,
        i,
        _at(addDays(day, 1), morning.time),
        'Nothing logged for ${_weekdayNames[weekday - 1]}',
        'Tap to log it now. The date is already set to yesterday.',
        day,
        const [ReminderAction.logWork, ReminderAction.nothing],
      );
    }
  }

  // Weekly review.
  final weekly = inputs.settings[ReminderKind.weekly];
  if (weekly != null && weekly.enabled) {
    final weekday = weekly.weekday ?? DateTime.friday;
    final weekEnd = addDays(weekStart(today), 6);
    for (var i = 0; i < inputs.days; i++) {
      final date = addDays(today, i);
      if (parseIsoDate(date).weekday != weekday) continue;
      final String body;
      if (date.compareTo(weekEnd) <= 0) {
        final entries = inputs.weekEntries == 1
            ? '1 entry'
            : '${inputs.weekEntries} entries';
        final drafts = switch (inputs.drafts) {
          0 => '',
          1 => ' 1 draft waiting.',
          final n => ' $n drafts waiting.',
        };
        body =
            'This week: $entries, ${_hours(inputs.weekHours)} h credited.'
            '$drafts';
      } else {
        body = 'Time for your weekly review.';
      }
      add(
        ReminderKind.weekly,
        i,
        _at(date, weekly.time),
        'Weekly review',
        body,
        date,
      );
    }
  }

  // Three days before the submission date.
  final submission = inputs.settings[ReminderKind.submission];
  final due = inputs.submissionDate;
  if (submission != null && submission.enabled && due != null) {
    final date = addDays(due, -3);
    final body = switch (inputs.zeroRows) {
      0 => 'All your role rows have hours. Time to export.',
      1 => '1 role row is still at zero.',
      final n => '$n role rows are still at zero.',
    };
    add(
      ReminderKind.submission,
      0,
      _at(date, submission.time),
      'Submission in 3 days',
      body,
      date,
    );
  }

  planned.sort((a, b) => a.at.compareTo(b.at));
  return planned;
}
