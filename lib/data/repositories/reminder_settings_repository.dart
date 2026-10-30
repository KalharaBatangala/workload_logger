import '../../domain/enums.dart';
import '../db/app_database.dart';

/// The four reminders' on/off state, time and weekday.
class ReminderSettingsRepository {
  ReminderSettingsRepository(this._db);

  final AppDatabase _db;

  Stream<Map<ReminderKind, ReminderSetting>> watchAll() => _db
      .select(_db.reminderSettings)
      .watch()
      .map((rows) => {for (final row in rows) row.key: row});

  Future<void> save(ReminderSetting setting) =>
      _db.into(_db.reminderSettings).insertOnConflictUpdate(setting);
}
