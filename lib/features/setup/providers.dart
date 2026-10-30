import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../domain/rates.dart';
import '../reminders/providers.dart';

final reminderSettingsProvider =
    StreamProvider.autoDispose<Map<ReminderKind, ReminderSetting>>(
      (ref) => ref.watch(reminderSettingsRepositoryProvider).watchAll(),
    );

final timetableSlotsProvider = StreamProvider.autoDispose<List<TimetableSlot>>(
  (ref) => ref.watch(timetableRepositoryProvider).watchAll(),
);

final categoriesProvider = StreamProvider.autoDispose<List<OtherCategory>>(
  (ref) => ref.watch(otherWorkRepositoryProvider).watchCategories(),
);

final pgStudentsProvider = StreamProvider.autoDispose<int>((ref) async* {
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) {
    yield 0;
    return;
  }
  yield* ref
      .watch(pgSupervisionRepositoryProvider)
      .watchStudents(profile.academicYearLabel);
});

final hasDemoDataProvider = FutureProvider.autoDispose<bool>((ref) async {
  ref.watch(profileProvider); // re-check when the profile changes
  ref.watch(roleRowsProvider);
  return ref.read(demoSeederProvider).hasDemoData();
});

/// Whether Android lets the app show notifications.
final notificationsAllowedProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(notificationServiceProvider).areEnabled(),
);

/// Rates that fell back to their default because the workbook did not have
/// them (Admin_Config rates only).
int defaultRateCount(RateSet rates) =>
    rates.defaultKeys.where((k) => k.isInAdminConfig).length;

const weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Subtitles of the four reminders (SPEC §8.8).
String reminderSubtitle(ReminderSetting s, {String? submissionDate}) {
  final time = formatClockTime(s.time);
  return switch (s.key) {
    ReminderKind.evening => 'Every day at $time',
    ReminderKind.morning => '$time, only if yesterday is empty',
    ReminderKind.weekly =>
      '${weekdayNames[(s.weekday ?? DateTime.friday) - 1]}s at $time',
    ReminderKind.submission =>
      submissionDate == null
          ? 'Lists role rows still at zero · set a submission date'
          : 'Lists role rows still at zero · 3 days before '
                '${formatShortDate(submissionDate)}',
  };
}

String reminderTitle(ReminderKind kind) => switch (kind) {
  ReminderKind.evening => 'Evening check-in',
  ReminderKind.morning => 'Next-morning catch-up',
  ReminderKind.weekly => 'Weekly review',
  ReminderKind.submission => 'Before submission',
};
