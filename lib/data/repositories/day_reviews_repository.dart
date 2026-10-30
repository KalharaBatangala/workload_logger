import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db/app_database.dart';

/// Days the user marked as reviewed or "nothing to log".
class DayReviewsRepository {
  DayReviewsRepository(this._db);

  final AppDatabase _db;

  Future<DayReview?> forDate(String date) => (_db.select(
    _db.dayReviews,
  )..where((d) => d.date.equals(date))).getSingleOrNull();

  Future<void> mark(String date, DayReviewStatus status) => _db
      .into(_db.dayReviews)
      .insertOnConflictUpdate(DayReview(date: date, status: status));

  Future<void> clear(String date) =>
      (_db.delete(_db.dayReviews)..where((d) => d.date.equals(date))).go();

  /// Reviewed dates from [from] on.
  Future<Set<String>> datesFrom(String from) async => {
    for (final row in await (_db.select(
      _db.dayReviews,
    )..where((d) => d.date.isBiggerOrEqualValue(from))).get())
      row.date,
  };

  /// Emits whenever a review changes (to re-plan reminders).
  Stream<void> watchChanges() => _db.select(_db.dayReviews).watch();
}
