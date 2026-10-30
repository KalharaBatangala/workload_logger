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
}
