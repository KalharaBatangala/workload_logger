import '../db/app_database.dart';

/// Number of postgraduate students supervised per academic year (SPEC §3.4).
class PgSupervisionRepository {
  PgSupervisionRepository(this._db);

  final AppDatabase _db;

  Stream<int> watchStudents(String academicYearLabel) =>
      (_db.select(_db.pgSupervision)
            ..where((p) => p.academicYearLabel.equals(academicYearLabel)))
          .watchSingleOrNull()
          .map((row) => row?.students ?? 0);

  Future<int> students(String academicYearLabel) async =>
      (await (_db.select(_db.pgSupervision)
                ..where((p) => p.academicYearLabel.equals(academicYearLabel)))
              .getSingleOrNull())
          ?.students ??
      0;

  Future<void> setStudents(String academicYearLabel, int students) => _db
      .into(_db.pgSupervision)
      .insertOnConflictUpdate(
        PgSupervisionRow(
          academicYearLabel: academicYearLabel,
          students: students,
        ),
      );
}
