import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db/app_database.dart';

/// Weekly class slots, used for timetable suggestions and reminders.
class TimetableRepository {
  TimetableRepository(this._db);

  final AppDatabase _db;

  Stream<List<TimetableSlot>> watchAll() =>
      (_db.select(_db.timetableSlots)..orderBy([
            (s) => OrderingTerm.asc(s.weekday),
            (s) => OrderingTerm.asc(s.startTime),
          ]))
          .watch();

  /// Slots on a weekday (1 = Monday … 7 = Sunday).
  Stream<List<TimetableSlot>> watchForWeekday(int weekday) =>
      (_db.select(_db.timetableSlots)
            ..where((s) => s.weekday.equals(weekday))
            ..orderBy([(s) => OrderingTerm.asc(s.startTime)]))
          .watch();

  Future<int> add({
    required int roleRowId,
    required SlotKind kind,
    required int weekday,
    required String startTime,
    required String endTime,
    bool isDemo = false,
  }) => _db
      .into(_db.timetableSlots)
      .insert(
        TimetableSlotsCompanion.insert(
          roleRowId: roleRowId,
          kind: kind,
          weekday: weekday,
          startTime: startTime,
          endTime: endTime,
          isDemo: Value(isDemo),
        ),
      );

  Future<void> save(TimetableSlot slot) =>
      _db.update(_db.timetableSlots).replace(slot);

  Future<void> remove(int id) =>
      (_db.delete(_db.timetableSlots)..where((s) => s.id.equals(id))).go();
}
