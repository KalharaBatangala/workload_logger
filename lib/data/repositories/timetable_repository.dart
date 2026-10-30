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

  Future<List<TimetableSlot>> getAll() => _db.select(_db.timetableSlots).get();

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

  // Answers to Today's timetable cards.

  /// Slot id → answer, for one date.
  Stream<Map<int, SlotAnswer>> watchAnswers(String date) =>
      (_db.select(_db.timetableAnswers)..where((a) => a.date.equals(date)))
          .watch()
          .map((rows) => {for (final row in rows) row.slotId: row.answer});

  Future<void> answer(String date, int slotId, SlotAnswer answer) => _db
      .into(_db.timetableAnswers)
      .insertOnConflictUpdate(
        TimetableAnswer(date: date, slotId: slotId, answer: answer),
      );

  Future<void> clearAnswer(String date, int slotId) => (_db.delete(
    _db.timetableAnswers,
  )..where((a) => a.date.equals(date) & a.slotId.equals(slotId))).go();
}
