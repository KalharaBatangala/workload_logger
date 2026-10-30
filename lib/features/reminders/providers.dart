import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/messenger.dart';
import '../../core/router.dart';
import '../../data/period_report.dart';
import '../../data/providers.dart';
import '../../data/repositories/entries_repository.dart';
import '../../domain/activity_catalogue.dart';
import '../../domain/dates.dart';
import '../../domain/enums.dart';
import '../../domain/reminder_planner.dart';
import '../../domain/summary.dart';
import 'notification_service.dart';

/// The device's notifications. Tests override this with a fake.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(),
);

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Gathers what the planner needs and replaces the scheduled reminders.
class ReminderScheduler {
  ReminderScheduler(this._ref);

  final Ref _ref;

  Future<void> refresh() async {
    final service = _ref.read(notificationServiceProvider);
    final profile = await _ref.read(profileRepositoryProvider).get();
    if (profile == null || !profile.onboardingDone) {
      await service.replaceAll(const []);
      return;
    }
    await service.replaceAll(planReminders(await gatherInputs()));
  }

  Future<PlannerInputs> gatherInputs() async {
    final now = _ref.read(clockProvider)();
    final today = isoDate(now);
    final monday = weekStart(today);
    final entries = _ref.read(entriesRepositoryProvider);
    final rates = await _ref.read(ratesRepositoryProvider).getRateSet();
    final rows = await _ref.read(roleRowsRepositoryProvider).getAll();
    final byId = {for (final r in rows) r.id: r};
    final profile = await _ref.read(profileRepositoryProvider).get();

    final recent = await entries.getRange(from: addDays(today, -1));
    final logged = [
      for (final e in recent)
        if (!e.isOpeningBalance) e,
    ];
    final thisWeek = [
      for (final e in await entries.getRange(from: monday, to: today))
        if (!e.isOpeningBalance && e.status == EntryStatus.complete) e,
    ];
    final drafts = (await entries.getRange())
        .where((e) => e.status == EntryStatus.draft)
        .length;

    final yearStart = await _ref
        .read(periodsRepositoryProvider)
        .currentYearStart();
    final report = buildPeriodReport(
      rows,
      await entries.getRange(from: yearStart),
      rates,
    );
    final zeroRows = report
        .where(
          (r) =>
              r.row.isActive &&
              !isAutomaticRole(r.row.role) &&
              r.hours.total == 0,
        )
        .length;

    final settings = await _ref
        .read(reminderSettingsRepositoryProvider)
        .getAll();
    final slots = await _ref.read(timetableRepositoryProvider).getAll();

    return PlannerInputs(
      now: now,
      settings: {
        for (final s in settings)
          s.key: ReminderConfig(
            enabled: s.enabled,
            time: s.time,
            weekday: s.weekday,
          ),
      },
      slots: [
        for (final s in slots)
          if (byId[s.roleRowId] != null)
            PlannerSlot(
              weekday: s.weekday,
              kind: s.kind,
              moduleCode: byId[s.roleRowId]!.moduleCode,
            ),
      ],
      datesWithEntries: {for (final e in logged) e.date},
      reviewedDates: await _ref
          .read(dayReviewsRepositoryProvider)
          .datesFrom(addDays(today, -1)),
      weekEntries: thisWeek.length,
      weekHours: creditedHours(thisWeek.map((e) => e.toInput()), rates),
      drafts: drafts,
      submissionDate: profile?.submissionDate,
      zeroRows: zeroRows,
    );
  }
}

final reminderSchedulerProvider = Provider(ReminderScheduler.new);

/// Re-plans reminders whenever entries, reviews, settings, the timetable or
/// the profile change (SPEC §9: on start, settings change and every save).
/// Several changes in one go cause one re-plan.
final reminderSyncProvider = Provider<void>((ref) {
  var pending = false;
  void changed(Object? _) {
    if (pending) return;
    pending = true;
    scheduleMicrotask(() {
      pending = false;
      ref.read(reminderSchedulerProvider).refresh().ignore();
    });
  }

  final today = ref.read(todayProvider);
  final subscriptions = [
    ref
        .read(entriesRepositoryProvider)
        .watchRange(from: addDays(today, -1))
        .listen(changed),
    ref.read(otherWorkRepositoryProvider).watchRange().listen(changed),
    ref.read(dayReviewsRepositoryProvider).watchChanges().listen(changed),
    ref.read(reminderSettingsRepositoryProvider).watchAll().listen(changed),
    ref.read(timetableRepositoryProvider).watchAll().listen(changed),
    ref.read(profileRepositoryProvider).watch().listen(changed),
  ];
  ref.onDispose(() {
    for (final s in subscriptions) {
      s.cancel();
    }
  });
});

/// What tapping a reminder or one of its buttons does. Buttons open the app
/// (decided with the owner), which records the answer here.
class ReminderTapHandler {
  ReminderTapHandler(this._ref);

  final Ref _ref;

  void _say(String text, {SnackBarAction? action}) => _ref
      .read(scaffoldMessengerKeyProvider)
      .currentState
      ?.showSnackBar(SnackBar(content: Text(text), action: action));

  Future<void> handle(ReminderTap tap) async {
    final router = _ref.read(routerProvider);
    final date = tap.payload.date;
    final day = _weekdayNames[parseIsoDate(date).weekday - 1];

    switch (tap.action) {
      case ReminderAction.lectureDone:
        final id = await _logLecture(date);
        router.go(AppRoutes.today);
        if (id == null) {
          _say('No lecture on your timetable for $day.');
        } else {
          final entries = _ref.read(entriesRepositoryProvider);
          _say(
            'Lecture logged for $day',
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => entries.softDelete(id),
            ),
          );
        }
      case ReminderAction.nothing:
        await _ref
            .read(dayReviewsRepositoryProvider)
            .mark(date, DayReviewStatus.nothingToLog);
        router.go(AppRoutes.today);
        _say('Noted: nothing to log for $day');
      case ReminderAction.logWork || null:
        switch (tap.payload.kind) {
          case ReminderKind.evening || ReminderKind.morning:
            router.go(AppRoutes.logOn(date));
          case ReminderKind.weekly:
            router.go(AppRoutes.history);
          case ReminderKind.submission:
            router.go(AppRoutes.summary);
        }
    }
  }

  /// "Lecture done": the day's first lecture slot, as a lecture entry
  /// (source = notification). Returns the entry id, or null if none.
  Future<String?> _logLecture(String date) async {
    final weekday = parseIsoDate(date).weekday;
    final slots = await _ref.read(timetableRepositoryProvider).getAll();
    final slot = slots
        .where((s) => s.weekday == weekday && s.kind == SlotKind.lecture)
        .firstOrNull;
    if (slot == null) return null;
    final id = await _ref
        .read(entriesRepositoryProvider)
        .add(
          roleRowId: slot.roleRowId,
          date: date,
          activity: Activity.lecture,
          count: slotLengthHours(slot.startTime, slot.endTime),
          source: EntrySource.notification,
        );
    await _ref
        .read(timetableRepositoryProvider)
        .answer(date, slot.id, SlotAnswer.yes);
    return id;
  }
}

final reminderTapHandlerProvider = Provider(ReminderTapHandler.new);

/// Starts reminders once: sets up notifications, plans them, and handles
/// the tap that launched the app (if any).
final remindersBootstrapProvider = FutureProvider<void>((ref) async {
  final service = ref.read(notificationServiceProvider);
  final handler = ref.read(reminderTapHandlerProvider);
  await service.init(onTap: (tap) => handler.handle(tap).ignore());
  ref.read(reminderSyncProvider);
  await ref.read(reminderSchedulerProvider).refresh();
  final launch = await service.launchTap();
  if (launch != null) await handler.handle(launch);
});
