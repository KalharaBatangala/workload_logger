import 'package:drift/drift.dart';

import '../../domain/dates.dart';
import '../db/app_database.dart';

/// Thrown when writing an entry dated inside a closed period.
class PeriodLockedException implements Exception {
  PeriodLockedException(this.date);

  final String date;

  @override
  String toString() => 'PeriodLockedException: $date is in a closed period';
}

class PeriodsRepository {
  PeriodsRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<List<Period>> watchAll() => (_db.select(
    _db.periods,
  )..orderBy([(p) => OrderingTerm.asc(p.startDate)])).watch();

  Future<int> create({
    required String label,
    required String startDate,
    required String endDate,
  }) => _db
      .into(_db.periods)
      .insert(
        PeriodsCompanion.insert(
          label: label,
          startDate: startDate,
          endDate: endDate,
        ),
      );

  /// Closes (locks) a period: its entries become read-only.
  Future<void> close(int id) =>
      (_db.update(_db.periods)..where((p) => p.id.equals(id))).write(
        PeriodsCompanion(lockedAt: Value(_now())),
      );

  /// Whether [date] falls inside any closed period.
  Future<bool> isLocked(String date) async {
    final match =
        await (_db.select(_db.periods)
              ..where(
                (p) =>
                    p.lockedAt.isNotNull() &
                    p.startDate.isSmallerOrEqualValue(date) &
                    p.endDate.isBiggerOrEqualValue(date),
              )
              ..limit(1))
            .getSingleOrNull();
    return match != null;
  }

  /// Throws [PeriodLockedException] if [date] is in a closed period.
  Future<void> ensureUnlocked(String date) async {
    if (await isLocked(date)) throw PeriodLockedException(date);
  }

  /// First day of the current academic year: the day after the last closed
  /// period ends, or null (everything) if no period has been closed.
  Stream<String?> watchCurrentYearStart() {
    final lastEnd = _db.periods.endDate.max();
    final query = _db.selectOnly(_db.periods)
      ..addColumns([lastEnd])
      ..where(_db.periods.lockedAt.isNotNull());
    return query
        .map((row) => row.read(lastEnd))
        .watchSingle()
        .map((end) => end == null ? null : addDays(end, 1));
  }
}
