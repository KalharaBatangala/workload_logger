import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/enums.dart';
import '../../domain/rates.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Other-work categories created with the database (SPEC §6).
const defaultOtherCategories = [
  'Research',
  'Administration / committees',
  'Student advising',
  'Lab sessions conducted',
  'Outreach',
  'Self-development',
];

@DriftDatabase(
  tables: [
    Profile,
    Rates,
    RoleRows,
    Entries,
    EntryPhotos,
    OtherWork,
    OtherCategories,
    TimetableSlots,
    ReminderSettings,
    DayReviews,
    PgSupervision,
    Periods,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// [executor] lets tests pass an in-memory database.
  AppDatabase(super.executor);

  /// The app's on-device database file.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'workload_logger'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaults();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedDefaults() async {
    await batch((b) {
      b.insertAll(otherCategories, [
        for (final (i, name) in defaultOtherCategories.indexed)
          OtherCategoriesCompanion.insert(name: name, sortOrder: i),
      ]);
      // SPEC §8.8 / §9 defaults. The submission reminder's time is not in the
      // spec; 09:00 is a placeholder until M8.
      b.insertAll(reminderSettings, [
        ReminderSettingsCompanion.insert(
          key: ReminderKind.evening,
          enabled: true,
          time: '20:30',
        ),
        ReminderSettingsCompanion.insert(
          key: ReminderKind.morning,
          enabled: true,
          time: '07:30',
        ),
        ReminderSettingsCompanion.insert(
          key: ReminderKind.weekly,
          enabled: true,
          time: '17:00',
          weekday: const Value(DateTime.friday),
        ),
        ReminderSettingsCompanion.insert(
          key: ReminderKind.submission,
          enabled: true,
          time: '09:00',
        ),
      ]);
    });
  }
}
